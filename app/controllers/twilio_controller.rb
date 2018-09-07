class TwilioController < ApplicationController
  require 'twilio-ruby'


  def call

    response = Twilio::TwiML::VoiceResponse.new
    gather = Twilio::TwiML::Gather.new(num_digits: '1', action: forward_path)

    gather.say(message: 'Hello this is Oran with blah blah. If you are interested press 1 to call me directly.', loop: 2)
    response.append(gather)

    render xml: response
  end

  def forward

    response = Twilio::TwiML::VoiceResponse.new
    response.dial do |dial|
      dial.number('+16267102292')
                  # status_callback_event: 'initiated ringing answered completed',
                  # status_callback: 'https://myapp.com/calls/events',
                  # status_callback_method: 'POST')
    end

    render xml: response

  end
end