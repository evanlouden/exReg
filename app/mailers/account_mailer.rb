class AccountMailer < ApplicationMailer
  default from: 'donotreply@exReg.com'

  def welcome_email(account, password)
    @account = account
    @password = password
    @url = "http://localhost:3000/accounts/sign_in"
    mail(
        to: @account.email,
        subject: "Your exReg #{@account.type} Account has been Created!"
        )
  end
end
