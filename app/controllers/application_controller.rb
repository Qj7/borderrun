class ApplicationController < ActionController::Base

  private

  def guest_email_authentication_key(key)
    key &&= nil unless key.to_s.match(/^guest/)
    key ||= "guest_" + 9.times.map { SecureRandom.rand(0..9) }.join
  end
end
