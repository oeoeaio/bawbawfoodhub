class ReadingsController < ApplicationController
  protect_from_forgery except: :create
  before_action :verify_request, only: :create

  respond_to :json

  def create
    sensor = Sensor.find_by_name(params[:sensor_name])
    return render nothing: true unless sensor.present?
    Reading.create(sensor: sensor, value: params[:value], recorded_at: Time.now)
    render nothing: true
  end

  private

  def verify_request
    pass = Rails.application.secrets.sensor_key
    digest = Digest::SHA1.hexdigest("#{pass}#{params[:salt]}")
    # Don't run the action unless the hash checks out
    render nothing: true unless params[:hash] == digest
  end
end
