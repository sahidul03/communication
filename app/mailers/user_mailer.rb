class UserMailer < ActionMailer::Base
  default from: "sendmail.example@gmail.com"

  def signup_confirmation(user)
    @user=user
    mail to: user.email, subject: "Signup confirmation Letter"
  end

end
