class Admin::SensorsController < Admin::BaseController
  before_filter :authorize_admin, only: [:index, :new, :create]

  def index
    @sensors = Sensor.all
  end

  def new
    @sensor = Sensor.new
  end

  def create
    sensor = Sensor.new sensor_params
    if sensor.save!
      redirect_to admin_sensors_path
    else
      render :new
    end
  end

  def edit
    @sensor = Sensor.find params[:id]
    authorize_admin @sensor
  end

  def update
    sensor = Sensor.find params[:id]
    authorize_admin sensor
    if sensor.update_attributes! sensor_params
      redirect_to admin_sensors_path
    else
      render :edit
    end
  end

  private

  def sensor_params
    params.require(:sensor).permit(:name, :active, :lower_limit, :upper_limit, :fail_count_for_value_alert)
  end
end
