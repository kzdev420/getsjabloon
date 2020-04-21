module Previews
  class ApplicationMailerPreview < ActionMailer::Preview
    def reset_password_instructions
      user = User.first || User.new(email: "test@example.com", password: "1234")

      Devise::Mailer.reset_password_instructions(user, "faketoken", {})
    end
  end
end
