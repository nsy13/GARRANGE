class NotificationsController < ApplicationController
  PAGENATE_NUMBER = 10

  def index
    invited_events_id = current_user.user_events.where(accepted: false).order(:created_at).map(&:event_id)
    notifications = []
    invited_events_id.each do |event_id|
      event = Event.find(event_id)
      organizer = User.find_by(id: event.organizer_id)
      notifications << { event: event, organizer: organizer }
    end
    @notifications = Kaminari.paginate_array(notifications).page(params[:page]).per(PAGENATE_NUMBER)
  end
end
