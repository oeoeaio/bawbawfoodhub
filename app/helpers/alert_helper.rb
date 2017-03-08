module AlertHelper
  def status_for(alert)
    case alert.status
    when 'sleeping'
      'Sleeping Until'
    else
      alert.status.capitalize
    end
  end

  def when_for(alert)
    case alert.status
    when 'sleeping'
      alert.sleep_until.strftime("%d/%m/%Y %H:%M:%S")
    when 'resolved'
      alert.resolved_at.strftime("%d/%m/%Y %H:%M:%S")
    else
      alert.updated_at.strftime("%d/%m/%Y %H:%M:%S")
    end
  end
end
