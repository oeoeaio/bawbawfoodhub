class Admin::ReadingsController < Admin::BaseController
  before_action :authorize_admin
  before_action :load_sensor

  def index
    @since = Time.parse(params[:since]) rescue 1.month.ago
    @readings = @sensor.readings.where(recorded_at: @since..).order(recorded_at: :desc)
  end

  private

  def load_sensor
    @sensor = Sensor.find params[:sensor_id]
    if @sensor.nil?
      flash[:error] = "Sensor not found"
      redirect_to admin_root_path
    end
  end
end
