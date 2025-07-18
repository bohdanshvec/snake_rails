class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  include Internationalization

  # before_action :set_locale

  helper_method :current_user, :user_signed_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end


  # I am saving it for educational purposes
  # def default_url_options
  #   { locale: I18n.locale }
  # end

  # private

  # def set_locale
  #   locale = params[:locale] || cookies[:locale] || I18n.default_locale
  #   I18n.locale = locale
  #   cookies[:locale] = { value: I18n.locale, expires: 1.year.from_now }
  # end
end
