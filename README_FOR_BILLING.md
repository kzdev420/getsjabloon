# Billing with Stripe
Accepting recurring payments using Stripe is easily done with Sjabloon. From the pricing page way down to the receipts send to your customer—it's all included, so you can focus on the core of your app.

To get you going in no-time. Here is a quick-start:

1. Get your `public_key`, `private_key` and your `signing_secret` (for “webhooks”) for your Stripe account (be aware of the difference between “test” and “live” in Stripe—use ”test” in your local development first to test) and add these to your credentials by running `EDITOR="vim -f" rails credentials:edit --environment development` (`vim` can be replaced by your favourite text editor)
2. Within your Stripe account add your product's plans (Sjabloon  assumes/is tested with monthly and annual plans)
3. Once done, run `rake stripe:fetch:plans`. This will get all your plans from Stripe and add these to your database
4. Check the part about "webhooks" below
5. Check http://localhost:5000/pricing to see the result
6. You are done! ✨🤑

The typical flow for your customer is as follows: they create an account from either going to /signup or selecting a plan from the pricing page (which redirects them to /signup). Once they have an account they can go to the pricing page to select a plan. This will bring them to the checkout page. Here they see their selected plan and enter their credit card details. If their credit card details are stored successfully, they are redirected to the billing page where they get an overview of their current plan, can up-/downgrade or cancel their plan and see all their charges (including a link to download the receipt).
If a subscription goes into effect immediately (meaning you didn't add a trial period), your customer also receives an email with their receipt (as an attachment). Otherwise they receive it once their trial period is over (and then every time a subscription renews). Be sure your SMTP settings are set up correctly.
NB: It's up to you and your app to limit authorisation based on no plan and your available plans.

## How's it all working in the behind the scenes?
Sjabloon uses three gems to get billing with Stripe working: the official `stripe` gem (to use the Stripe API), the `stripe_event` gem (to easily accept/work with “webhooks” coming from Stripe) and the `receipts` gem to easily create receipts.
The next big piece is a concern added to your User model (so you can easily change this—see below on how): `Sjabloon::Stripe::Payer`. This concern extends your user model with many methods that act sort of as an abstracted layer to the Stripe API. You can run `User.first.subscribed?` to check if they are subscribed or `User.first.subscription` to see their default subscription (one can theoretically have multiple subscriptions). See all the other methods available to you.
The customer payment details are (partially) stored on the user model (by default—see below how you can change this). A User `has_many :charges` and `has_many :subscriptions`. Both `Charge`'s and `Subscription`'s `belongs_to :owner`.
Everything is scoped on `Sjabloon`. So `Sjabloon::Charge` and `Sjabloon::Subscription`. This is to make sure it won't interfere with your (future) models.

## Webhooks and Stripe
Webhooks are used extensively at Stripe and are a great way to make sure your database is up to date with Stripe.
Payments work just fine without them, but you will miss out of things like "charges". They take care, amongst others, to let you know a trial is over (first charge of their credit card), a subscription is renewed or a charge has failed (after Stripe's retried)—thus the subscription should be canceled.

### Testing webhooks locally
Stripe provides the option to listen to webhooks from the test mode to your local server via the Stripe CLI. See [their docs](https://github.com/stripe/stripe-cli) for more information.
Go to www.stripe.com > Developers > Webhooks and simply enable _all_ webhooks available. Sjabloon responds to all webhook requests found in `app/services/sjabloon/stripe/webhooks/`. That's also where you can add you any extra webhooks you need.

## Frequently asked questions
Payments/billing involves many different elements. Here are some common questions that might help you move forward. As always if you have more questions, send an email to support@getsjabloon.com.

### How can I check if a user has a subscription?
You can add `.subscribed?` to the User, eg. `User.first.subscribed?`

### How can I add coupons?
When you have no active coupons in your database, Sjabloon hides the "have a coupon?" link (and the following form) from the checkout page as coupons are not feasible for every app.
Coupons can be easily added with the following:

1. Add your coupons in your Stripe account
2. Run `rake stripe:fetch:coupons` from the command line
3. The coupon form will now show on your checkout form

### What do I need to set up for emails?
Check the keys below the `billing:` key in `config/app_config.yml`.

### How can I add a subscription to a different model than the User model (eg. Organisation, Team, etc.)
There are plenty of reasons you want to attach a subscription to another model than the User model. Sjabloon is set up to make this easy, but involves a bit more manual work. It should ideally be done early stage.

- Rollback the migration (rails db:rollback) that adds the payment fields to the Users table (add_payment_fields_to_Users). Find/replace `:Users` with whatever model you want to add it to (make sure the table name is plural!). Re-run the migration.
- In `config/app_config.yml` change the `payer_class` to your new model name (eg. "Team").
- Move `include Sjabloon::Stripe::Payer` from `model/user.rb` to your new model.
- Add a `delegate :email, to: :user` method to this new model. This assumes this is a `belongs_to` association (eg. you can run Model.user and it returns on record).
- Lastly, in `app/controllers/application_controller.rb`, change the `current_payer` to include the "current model" for which you want to add subscriptions to (eg "current_team"). For User this is the default `current_user` that comes with Devise. _You most likely need to create a "current model" method yourself._

### How can I add features to each plan as seen of the pricing page?
See `app/models/sjabloon/plan.rb`. It comes with a "jsonb" field called "features" (it uses the storext gem for this). Add features here any of you plans might have, eg. `team_members Integer`. You can update your plan with `Sjabloon::Plan.first.update team_members: 5`. The method `plan_item` in `Sjabloon::PlansHelper` tries to be smart about the design for it on your Pricing page.

### How do the “fetch” rake tasks work?
Check `lib/sjabloon/stripe/fetch.rb`. For both `Sjabloon::Coupon`'s and `Sjabloon::Plan`'s it looks up the `processor_id`. If it's available it updates the details. If not available, it create a new plan or coupon. This is to make sure you can use Stripe as your single source of truth (it's not a two-way sync—your locally-made changes are not pushed to Stripe).

### Can I fetch plans and coupons in one command?
Yes. You can run `rake stripe:fetch:all` to fetch both your plans and coupons from Stripe.

### How can I change the order of the plans of my pricing page?
You can change the position by adding an integer (1, 2, 3) to the position field of the plan (eg. `Sjabloon::Plan.first.update position: 1`). Its order by this position field in ascending order.

### How can I add a credit card on sign up?
The easiest way is to "lock down" the application by adding a `before_action` that looks if the `current_user` is `subscribed?`. If not `redirect_to` the `pricing_path`.










---
The billing with Stripe code is based/inspired on the work done by C. Oliver and J. Charnes.
---
_Acknowledgement. Sjabloon has done the utmost to ensure payments/billing with Stripe work without bugs or other problems. It is though not liable, nor can be held responsible for any erroneous behaviour, damages in any way by using it or exposing it to your Users, visitors or customers._
