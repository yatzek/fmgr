# heroku mailer settings, copied from: https://devcenter.heroku.com/articles/mailgun
ActionMailer::Base.smtp_settings = {
    :port           => ENV['MAILGUN_SMTP_PORT'],
    :address        => ENV['MAILGUN_SMTP_SERVER'],
    :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
    :password       => ENV['MAILGUN_SMTP_PASSWORD'],
    :domain         => 'tfmgr.heroku.com',
    :authentication => :plain,
}
ActionMailer::Base.delivery_method = :smtp

class PlayerMailer < ActionMailer::Base
  default from: "noreply@tfmgr.heroku.com"


  def notification_email(player)
    #@player = player
    @url  = "http://tfmgr.herokuapp.com/play/#{player.id}" # TODO: click action
    mail(:to => player.email, :subject => "Want to play 5-a-side on Tuesday?")
  end

end
