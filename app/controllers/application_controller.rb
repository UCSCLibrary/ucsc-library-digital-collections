class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior

  # Adds Hyrax behaviors into the application controller 
  include Hyrax::Controller

  include Hyrax::ThemedLayoutController

  before_action :set_image_token

  with_themed_layout '1_column'

  protect_from_forgery with: :exception
  skip_after_action :discard_flash_if_xhr

  private

  def set_image_token
    return if cookies[:ucsc_imgsrv_token].present?
    domain = ["production", "staging","sandbox"].include?(Rails.env) ? '.library.ucsc.edu' : :all
    expires = Time.now + 86400
    value = Digest::SHA256.hexdigest(expires.to_i.to_s + ENV['image_token_secret'])
    cookies[:ucsc_imgsrv_token] ||= {value: "#{expires.to_i.to_s}-#{value}",
                                     expires: expires,
                                     domain: domain}
  end
end
