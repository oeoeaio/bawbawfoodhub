class Admin::ReadingsController < Admin::BaseController
  before_filter :authorize_admin
  before_filter :load_sensor

  def index
    @readings = @sensor.readings.where('recorded_at > ?', 1.month.ago).order(recorded_at: :desc)
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
