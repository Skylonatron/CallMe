class TwilioController < ApplicationController
  require 'twilio-ruby'


  def call

    response = Twilio::TwiML::VoiceResponse.new
    response.say(message: 'Hello How Are You Doing Today')
    render xml: response
  end
end