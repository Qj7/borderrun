class MainController < ApplicationController
  def index
    current_or_guest_user.update!(telegram_nickname: params[:nickname], telegram_id: params[:telegram_id]) if current_or_guest_user.telegram_id.nil?
  end

  def create_order
    order = Order.create(name: params[:name],
                description: params[:description],
                trip_date: params[:trip_date],
                user_id: current_or_guest_user.id)

    message = <<-MESSAGE
    📅 Создана: #{order.created_at.strftime("%d.%m %H:%M")}
    ~•~•~•~•~•~•~•~•~•~•~•~•~•~•~
    👤 Имя для обращения: #{order.name} | Связаться: https://t.me/#{current_or_guest_user.telegram_nickname}
    🚌 Дата поездки #{order.trip_date}
    🗣 Комментарий: #{order.description}
    ~•~•~•~•~•~•~•~•~•~•~•~•~•~•~
    MESSAGE

    TelegramApi.new('-1002075081823').send_message_to_telegram(message)

    render json: {}, status: :ok
  end
end
