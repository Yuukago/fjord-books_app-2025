# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def after_sign_in_path_for(_resource_or_scope)
    '/books'
  end

  def after_sign_out_path_for(_resource_or_scope)
    '/users/sign_in'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[postal_code address introduction])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[postal_code address introduction])
  end
end
