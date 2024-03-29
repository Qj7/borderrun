class MainController < ApplicationController
  #change to options file
  CURRENT_EVENT = 'event1'
  DISPLAYED_EVENT_NAME = "Новогодий розыгрыш 🎁"
  def index
    @current_locale = I18n.locale.to_s
    @ask_telegram = true unless params[:nickname]
    #@show_ad = true unless current_or_guest_user.events.where(name: CURRENT_EVENT).any?
    @show_ad = false

    current_or_guest_user.update!(
      telegram_nickname: params[:nickname],
      telegram_id: params[:telegram_id]
    ) if current_or_guest_user.telegram_id.nil?
  end

  def ad
    puts 'AD sended'
    message = "Переход c phuketborder.run тг ник: #{current_or_guest_user.telegram_nickname}"
    TelegramApi.new('207243283').send_message_to_telegram(message)
    redirect_to "https://t.me/phuket_football", target: "_blank", allow_other_host: true
  end

  def create_order
    current_or_guest_user.update!(telegram_nickname: params[:nickname].gsub!('@', '')) if params[:nickname]
    order = Order.create(
      name: params[:name],
      description: params[:description],
      trip_date: params[:trip_date],
      duration: params[:duration],
      user_id: current_or_guest_user.id
    )

    event = Event.create(
      name: CURRENT_EVENT,
      displayed_name: DISPLAYED_EVENT_NAME,
      status: 'ожидает подтверждения',
      user_id: current_or_guest_user.id
    ) unless Event.where(user_id: current_or_guest_user.id, name: CURRENT_EVENT).any?

    message = <<-MESSAGE
    📅 Создана: #{order.created_at.strftime("%d.%m %H:%M")}
    ~•~•~•~•~•~•~•~•~•~•~•~•~•~•~
    👤  Имя для обращения: #{order.name} | Связаться: https://t.me/#{current_or_guest_user.telegram_nickname}
    🚌  Дата поездки #{order.trip_date}
    🗣 Комментарий: #{order.description}
    🔢 Количество дней: #{order.duration}
    #{'Участие в конкурсе: ' + event.displayed_name + ' | статус: ' + event.status if event.present?}
    ~•~•~•~•~•~•~•~•~•~•~•~•~•~•~
    MESSAGE

    TelegramApi.new(ENV['WORKING_CHAT_ID']).send_message_to_telegram(message)

    render json: {}, status: :ok
  end
end
