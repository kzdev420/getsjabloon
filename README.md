# SJABLOON README

Thanks for using Sjabloon to get a flying start with your new Ruby on Rails project! 🎊

## Quickstart guide
There are a few steps you have to do manually. See below this quickstart for more in depth information on various features of Sjabloon.

1. You can run your new Rails app using `foreman start` or `foreman s` (make sure you have Foreman installed—`gem install foreman`).
2. Your app now runs on `http://localhost:5000`
3. Easily copy/paste UI components from the library at https://www.getsjabloon.com/features/ui-components#components
4. Work on your core product right away ✨

For details about billing with Stripe, please check the additional README_FOR_BILLING.

### Rails Credentials
Sjabloon uses Rails credentials.
You can access these using `EDITOR="vim -f" rails credentials:edit --environment development` (for development environment and, eg. `EDITOR="vim -f" rails credentials:edit --environment production` for production), where you can replace `vim` with your editor of choice. You can use this template:

**For development:**
```yml
stripe:
  private_key: ''
  public_key: ''
  signing_secret: ''

```

**For production/staging:**
```yml
stripe:
  private_key: ''
  public_key: ''
  signing_secret: ''
















```





## Running your app in development
You can run your new application with `foreman start` or shorthand `foreman s` (it uses Procfile.dev as set in the `.foreman` file). Foreman also reads the contents from the `.env` file, which you can use for any environment variables.

## Modern front end
Sjabloon utilises a lean, but modern front end. Webpack as the Javascript bundler (bundled by default with Rails 6+), PostCss to add some magic to your Css, Tailwind as the utility-first CSS framework and Stimulus as the JS framework. These tools are proven to make sure you make powerful web applications, without overly complicating stuff. All powerful enough to get that important first version out of the door.

### [Webpack](https://webpack.js.org)
Webpack comes by default with every new Rails (6+) application using the [Webpacker gem](https://github.com/rails/webpacker). In development it's run as `./bin/webpack --watch --colors --progress` with [Foreman](https://github.com/ddollar/foreman).

### [PostCss](https://https://postcss.org)
Also PostCss comes as default with Rails 6+. It's a tool to transform your CSS with Javascript. As such it can do everything Scss/Sass does, and a lot more. A lot! It works by adding small plugins that do one thing well. Sjabloon comes with the following plugins installed for you:

- [postcss-import](https://github.com/postcss/postcss-import). See how this is used in `frontend/stylesheets/application.css`
- [postcss-preset-env](https://github.com/csstools/postcss-preset-env) A set of plugins to convert modern CSS into something browsers understand today.
- [postcss-nested](https://github.com/postcss/postcss-nested) This unwraps nested styles similar to Scss/Sass.

#### Hot Module Reloading
Rails 6 comes with Hot Module Reloading (HMR). For the purposes of loading the stylesheets properly with premailer (the tool that inlines your CSS), `extract_css` is set to `true` also in development environment (see: config/webpacker.yml).

### [Tailwind](https://tailwindcss.com)
Tailwind is a utility-first Css framework. It solely consist of one-off classes, like `.mb-4`, `.text-white` and `.text-base`. This lets you create UI's really quick as you only have to add some classes to build a component. And once you reuse a component, you can extract the class into its own Css selector with `@apply`. And then one of the Css files in `frontend/stylesheets/components`. [See here for some components examples](https://www.getsjabloon.com/features/ui-components). Note: you need to uncomment some files/imports in `frontend/stylesheets/components.css` to use these specfic components.

### [Stimulus](https://stimulusjs.org)
Stimulus is a nice and modest framework that allows you to add just enough JS to make your UI shine. No crazy new templating, but the HTML you already use.

### Images in your views
With Webpacker in Rails, images can be loaded with the helper <%= image_pack_tag 'name_of_image.jpg' %>. Images are added to `frontend/images` (or a subdirectory within).

Since this front end is not reliant on Sprockets (the previous used asset pipeline with Rails), all front end related code is in `/frontend` instead of `app/assets`. So, if you really need to include another JS framework, like React or Vue, this folder is the perfect place for it too. _Your `ERB` views can still be found in `/app/views` though._

## Authentication
Your app uses authentication with Devise (set up with a User model). Sjabloon tries to set it up as vanilla as possible, some notes though:
- all your views and emails are styled for you;
- all devise views default to the "devise" layout (app/views/layouts/devise.html.erb);
- the signup flow is using the Signup Form Object (app/forms/sjabloon/signup_form.rb) and the SignupsController (app/controllers/sjabloon/signups_controller.rb). This is done as most will need need 1-2 fields in the sign up process, a form object is the sanest way to go about this (do not try to use "nested attributes");
- the params for "registrations#edit" are set in app/controllers/application_controller.rb;
- there's a "admin" boolean field added that you can use to limit/scope certain features.

## Act as Person/masquerading
You can see and use your app as another user with the installed `devise_masquerade` gem. It only works if you are logged in and have `admin` on your record set to true.
Next you can go to http://localhost:3000/masquerade/{user_id}—where `user_id` is the user of choice. When logged in as a different user, you'll see a small banner at the bottom to notify you about this and a button to go back as your original user record.


## Transactional emails
“Transactional emails” are emails such as email confirmation, password reset link, etc.
In **development**, [letter_opener](https://github.com/ryanb/letter_opener) is included. It's an easy way to preview in real-time (instead of the default log output). Check `config/environments/development.rb` how this is set up.
You can also go to [http://localhost:5000/rails/mailers](http://localhost:5000/rails/mailers) to preview the emails in the browser. `reset_password_instructions` is defined here to preview the reset password email from Devise (be sure there is at least one User in the database).


### Email design
All styles for the emails can be found in `frontend/stylesheets/emails.scss`. These styles are automatically inlined using the [Premailer gem](https://github.com/premailer/premailer) ensuring emails look good in multiple email clients. It also creates a text variant of every email for you.

## FriendlyID
[FriendlyID](https://github.com/norman/friendly_id/) is the "Swiss Army bulldozer" of slugging and permalink plugins for Active Record. It basically allows you to have “pretty” links instead of rails default id's.
In your model (where `name` is a column in your `companies` table—don't forget to add a `slug` “string” column too):
```rb
class Company < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
end
```
In your controller:
```rb
def set_company
  @company = Company.friendly.find(params[:id])
end
```

Sjabloon also adds a `Friendlyable` (app/models/concerns/friendlyable.rb) concern for you. All it needs is a `hash_id` column in the model's database and include it on the model. Having a separate hash_id instead of the default id is good for security reasons.
```rb
class Download < ApplicationRecord
  include Friendlyable
end
```

## GDPR
GDPR is is a regulation in EU law on data protection and privacy for all individual citizens of the European Union and the European Economic Area. It also addresses the transfer of personal data outside the EU and EEA areas. As creators/owners of web applications it’s your responsibility to be careful with your user’s data. As a default you should strive to obtain as little data of your users as possible. Sjabloon helps you with a few of these things.

## Filter parameter logging
Rails built-in Filter Parameter Logging replaces sensitive parameter data from the request log. Sjabloon adds a few common parameters for you (only in production).

## Ask and track user consent
When a visitor creates an account on your app, they are prompted to give their consent for each policy (eg. privacy policy, terms of service, etc.) you add. This consent is then set for this user (in a Consent model). Whenever you make changes to any of these policies you need to ask the consent of your users again. With Sjabloon you can create and update different policies with ease and when your user visits your site, they get prompted to read and accept your new policies. Sjabloon comes also with a helper that checks if consent is given (which you can check against in your app, eg. controller, helper, service object, etc.). The modal that’s shown to user is easily customisable.

## Cookie notification for page analytics and other third-party services
When a Cookie Policy is available a small modal at the bottom of the page will show, notifying your visitors about the fact you use cookies. They can click to see your Cookie Policy and accept it. The design of the modal can also easily be modified.

### How to add policies?
From your rails console run:
```ruby
Sjabloon::Policy.create!(
policy_type: 'terms', # other options: 'privacy', 'cookies'
title: 'Terms of Service', # what is used at the top of the page, eg. /terms
mandatory: true, # or false. Used to show on sign up form or not
content: 'The actual policy' # The actualy contents of your policy. What they need to consent to
)
```
When you make changes to your policy you need to create a new policy (`Sjabloon::Policy`), you cannot update your existing policy as changes (to the consents given also) are not recorded.

## Anonymise IP addresses for Google Analytics
Sjabloon gives you a one-click option to install multiple page analytics tool like Google Analytics, Clicky and Simple Analytics. Both Clicky and Simple Analytics do not collect, but anonymise IP addresses by default, but Google Analytics does collect IP addresses. Sjabloon sets the `anonymize_ip` option to true by default.

## Other things to think about
No app is alike and as such it’s impossible to provide full coverage for GDPR out-of-the-box with Sjabloon. Things you might need to look into, dependending on your app:

- user data export option;
- full removal of user data (from your database ánd backups);
- write your own terms of service, privacy policy and cookies service.

Sjabloon has done as much as possible to set a good foundation to be GDPR compliant. It is however not a complete solution, and as such Sjabloon cannot held responsible for any issues coming from using the provided code. If you are unsure about any GDPR-issue, do reach out to a legal specialist.

## Custom generators for Form, Service, Presenter and Query Objects
Sjabloon comes packaged with multiple custom generators to create Form Objects, Service Objects, Presenter Objects and Query Objects. These will create boilerplate files for you to quickly write the fun stuff instead. See [this KB page](http://www.getsjabloon.com/kb/custom-generators) for more information.


## Production specific settings (eg. config/environments/production.rb)

- SSL is forced; good practice for your Users and search engines won't penalise for being unsafe
- adding `Rack::Deflater`; the the simplest thing to drastically reduce the size of your HTML / JSON controller responses







## Deploying your app
To have a smooth deploy, be sure to add the contents of `config/master.key` to your environment variables as `RAILS_MASTER_KEY`. It's really important to never share this `RAILS_MASTER_KEY` in any shared repository or public space! By default it's excluded from Git, through the `.gitignore` file.

Don't know where to deploy your app? I can highly recommend the combo [DigitalOcean](https://m.do.co/c/5ca1e8d17563) and [Hatchbox](https://hatchbox.io/?via=sjabloon). Other hosting services (that can be used with Hatchbox) are: Linode and Vultr. If you are planning to have just one app running [Render](https://render.com?via=getsjabloon.com) is a solid (fairly-new) choice. Another solid, but often more expensive, choice is still [Heroku](https://www.heroku.com).

Hello world!!!
