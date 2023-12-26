require 'telegram/bot'
require 'logger'
require_relative 'config/environment'

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_TOKEN'], logger: logger) do |bot|
  bot.listen do |message|
    case message
    when Telegram::Bot::Types::Message
      if message.from && !message.from.is_bot
        chat_id = message.chat.id
        nickname = message.from.username

        caption = <<~HTML
          <b>🚌 Бордер раны от официальной 🇹🇭 Таиской компании!</b>

          30 дней —  3️⃣6️⃣0️⃣0️⃣ бат | 90 дней —  4️⃣6️⃣0️⃣0️⃣ бат.
          
          🇹🇭 оформление студенческих виз (Education Visa) - 12 мес. для граждан всех стран 6️⃣0️⃣ 0️⃣0️⃣0️⃣ бат.

          <b>Услуги:</b>
          - Официальные бордеры неограниченное количество раз (получение штампа в Майлазии и еще одного на обратном въезде в Таиланда).
              🇷🇺 РФ: без ограничений.
              🇺🇦 Украина и 🇰🇿 Казахстан: до 2 штампов в год.
          - Любы вопросы о продлении визы или пребывания, сообщите нам заранее, решаем любые проблемы, включая депортацию! (Нужно сообщить предварительно)
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
        message_text = sent_message['result']['caption']
        message = TelegramMessage.create(telegram_id: chat_id, message_id: message_id_to_delete, text: message_text)
        #perform later cherez 2 chasa udalit
      end
    end
  end
end
