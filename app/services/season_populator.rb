class SeasonPopulator
  attr_reader :message

  def initialize(season:)
    @season = season
    @message = ''
  end

  def run
    return @message = 'Season already has pack days' if season.pack_days.any?
    return @message = 'Season does not start on a Tuesday' if season.starts_on.wday != 2
    (season.starts_on..season.ends_on).step(7).each do |date|
      season.pack_days.create(pack_date: date)
    end
    @message = "Added #{season.pack_days.count} pack days to #{season.name}"
  end

  private

  attr_reader :season
end
