module SubscriptionHelper
  def get_subscriptions(season)
    %w(large standard small).map do |size|
      text_for scope_for( season, size ), size
    end.reject(&:empty?).join(", ")
  end

  private

  def scope_for(season,size)
    @subscriptions.where(season: season, box_size: size)
  end

  def text_for( scope, size )
    box_name = Subscription::SIZES[size][:name]
    # If we are going to be joining multiple strings
    # Or if more than one subscription exists for this size
    if @subscriptions.count > 1 || scope.count > 1
      "#{scope.count} #{box_name.pluralize}"
    elsif scope.count > 0
      box_name
    else
      ""
    end
  end

  def subscription_total_with_discount
    pack_count = @season.packs_after(@subscription.created_at).count
    value = Subscription::SIZES[@subscription.box_size][:value]
    (pack_count * value * 0.95).round 2
  end
end