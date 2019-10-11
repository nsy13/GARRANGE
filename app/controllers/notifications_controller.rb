class NotificationsController < ApplicationController
  def index
    invited_events_id = current_user.user_events.where(accepted: false).map(&:event_id)
    @invited_events = []
    invited_events_id.each do |event_id|
      @invited_events << Event.find(event_id)
    end
  end
end
