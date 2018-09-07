class TwilioIntegration
  require 'twilio-ruby'

  def initialize()

    account_sid = "ACdb451284214588a1d69c9a86d531116d"
    auth_token = "fd45aa967a2285ae29121babe5b4597a"

    @client = Twilio::REST::Client.new account_sid, auth_token
  end

  def make_call(number)
    @client.calls.create(
      url: 'https://call-lead.herokuapp.com/call',
      to: "+#{number}",
      from: '+16267102292'
    )
  end

end