class ReadingsController < ApplicationController
  protect_from_forgery except: :create
  before_action :verify_request, only: :create
  before_action :load_sensor, only: :create

  respond_to :json

  def create
    Reading.create(sensor: @sensor, value: params[:value], recorded_at: Time.now)
    head :ok
  end

  private

  def verify_request
    pass = Rails.application.secrets.sensor_key
    digest = Digest::SHA1.hexdigest("#{pass}#{params[:salt]}")
    # Don't run the action unless the hash checks out
    head :ok unless params[:hash] == digest
  end

  def load_sensor
    @sensor = Sensor.find_by_identifier(params[:sensor_id]) if params[:sensor_id]
    @sensor ||= Sensor.find_by_name(params[:sensor_name])

    return head :ok unless @sensor.present?
  end
end
