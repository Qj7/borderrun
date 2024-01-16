class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  private
  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def guest_email_authentication_key(key)
    key &&= nil unless key.to_s.match(/^guest/)
    key ||= "guest_" + 9.times.map { SecureRandom.rand(0..9) }.join
  end
end
