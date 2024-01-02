require 'telegram/bot'
require 'logger'
require_relative 'config/environment'

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

#change to options file
CURRENT_EVENT = 'event1'
DISPLAYED_EVENT_NAME = "Новогодий розыгрыш 🎁"

Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_TOKEN'], logger: logger) do |bot|
  bot.listen do |message|
    begin
      case message
      when Telegram::Bot::Types::Message
        if message.from && !message.from.is_bot
          case message.text
          when '/draw'
            user_ids = Event.where(name: CURRENT_EVENT, status: 'Подтвержден').pluck(:user_id)
            orders = Order.where(user_id: user_ids)
            order_names = orders.pluck(:name)
            bot.api.send_message(chat_id: message.chat.id, text: "Участники: #{order_names.join(', ')}")
          else
            caption = <<~HTML
              <b>🚌 Бордер раны от официальной 🇹🇭 Таиской компании!</b>

              30 дней —  3️⃣6️⃣0️⃣0️⃣ бат | 90 дней —  4️⃣6️⃣0️⃣0️⃣ бат.

              🇹🇭 оформление студенческих виз (Education Visa) - 12 мес. для граждан всех стран 6️⃣0️⃣ 0️⃣0️⃣0️⃣ бат.

              <b>Услуги:</b>
              - Официальные бордеры неограниченное количество раз (получение штампа в Майлазии и еще одного на обратном въезде в Таиланда).
                  🇷🇺 РФ: без ограничений.
                  🇺🇦 Украина и 🇰🇿 Казахстан: до 2 штампов в год.
              - Помощь в решении любых вопрос в том числе: продлении визы или пребывания, проблемы с въездом. Сообщите нам заранее, решаем любые проблемы, включая депортацию!
              - Встреча в ✈️ аэропорту и помощь с любыми вопросами и проблемами (Сообщите в заявке или менеджеру предварительно)

              <b>Почему мы?</b>
              - Онлайн заявка за пару кликов.
              - Доверие туристов и локалов.
              - Онлайн менеджер 24/7
              - Онлайн сопровождение всю дорогу.
              - Инструкции, фото, видео отчеты внутри приложения ⬇️

              <a href="https://t.me/Phuket_Border_Run_Malaysia">Остались вопросы? 🗣 Связаться с нами</a>
            HTML

            photo_path = Rails.root.join('app', 'assets', 'images', 'bstart.png').to_s
            photo = File.open(photo_path, 'rb')

            chat_id = message.chat.id
            nickname = message.from.username

            kb = [
              [
                Telegram::Bot::Types::InlineKeyboardButton.new(
                  text: '🚌 Онлайн заявка',
                  web_app: { url: "#{ENV['PROD_APP_URL']}?telegram_id=#{chat_id}&nickname=#{nickname}" }
                )
              ]
            ]

            markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)

            sent_message = bot.api.send_photo(
              chat_id: chat_id,
              photo: UploadIO.new(photo, 'image/png', 'bstart.png'),
              caption: caption,
              reply_markup: markup,
              parse_mode: 'HTML'
            )

            message_id_to_delete = sent_message['result']['message_id']
            message_text = message.text || message.caption

            TelegramMessage.create!(telegram_id: chat_id, message_id: message.message_id, text: message_text.to_s)
            TelegramMessage.create!(telegram_id: chat_id, message_id: message_id_to_delete)
            #perform later cherez 2 chasa udalit
          end
        end
      end
    rescue => e
      logger.error "Произошла ошибка: #{e.message}"
    end
  end
end
