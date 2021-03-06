class Alert < ActiveRecord::Base
  belongs_to :sensor

  scope :current, -> { where(resolved_at: nil) }

  def sleeping?
    sleep_until.present? && sleep_until > Time.now
  end

  def resolved?
    resolved_at.present?
  end

  def recent_or_sleeping?
    (created_at > 3.hours.ago) || sleeping?
  end

  def status
    return 'resolved' if resolved?
    return 'sleeping' if sleeping?
    'active'
  end
end
