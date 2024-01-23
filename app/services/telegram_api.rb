# app/services/telegram_api.rb
require 'net/http'
require 'uri'
require 'json'
require 'net/http/post/multipart'

class TelegramApi
  include ApplicationHelper

  def initialize(chat_id)
    @api_token = ENV['TELEGRAM_BOT_FOR_API_TOKEN']
    @chat_id = chat_id
    @url = URI.parse("https://api.telegram.org/bot#{@api_token}/sendMessage")
  end

  def send_web_app_button_message
    photo_path = Rails.root.join('app', 'assets', 'images', 'bstart.jpg').to_s
    photo = File.open(photo_path, 'rb')

    reply_markup = {
      inline_keyboard: [
        [
          {
            text: 'Сделать заявку',
            web_app: { url: "https://#{ENV['PROD_APP_URL']}" }
          }
        ]
      ]
    }

    url = URI.parse("https://api.telegram.org/bot#{@api_token}/sendPhoto")
    request = Net::HTTP::Post::Multipart.new(url.path,
      'chat_id' => @chat_id,
      'reply_markup' => reply_markup.to_json,
      'photo' => UploadIO.new(photo, 'image/png', 'gstart.jpg')
    )

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    response = http.request(request)
    response.body
  end
  def send_message_to_telegram(message, photo = nil, reply_markup = nil)
    @url = URI.parse("https://api.telegram.org/bot#{@api_token}/sendPhoto") if photo
    request = Net::HTTP::Post.new(@url.request_uri)

    params = [
      ['chat_id', @chat_id],
      ['text', message],
      ['parse_mode', 'markdown']
    ]

    params << ['photo', File.open(photo, 'rb')] if photo
    params << reply_marku if reply_markup

    request.set_form(params, 'multipart/form-data')

    http = Net::HTTP.new(@url.host, @url.port)
    http.use_ssl = true

    response = http.request(request)

    response.body
  end
end
