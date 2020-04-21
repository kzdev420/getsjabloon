require "sjabloon/stripe/fetch"

namespace :stripe do
  desc "Fetch plans from Stripe"
  task "fetch:plans" => "environment" do
    Sjabloon::Stripe::Plans.fetch!
  end

  desc "Fetch coupons from Stripe"
  task "fetch:coupons" => "environment" do
    Sjabloon::Stripe::Coupons.fetch!
  end

  desc "Fetch plans coupons from Stripe"
  task "fetch:all" => "environment" do
    Sjabloon::Stripe::Plans.fetch!
    Sjabloon::Stripe::Coupons.fetch!
  end
end

