class Admin::AlertsController < Admin::BaseController
  before_action :authorize_admin
  before_action :load_sensor, only: [:index]

  def index
    @alerts = @sensor.alerts.order(created_at: :desc)
  end

  def sleep
    alert = Alert.find_by_id(params[:id])
    alert.update(sleep_until: Time.now + 3.hours)
    redirect_to admin_sensor_alerts_path(alert.sensor)
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
