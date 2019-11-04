require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  let(:user1) { create(:user, id: 1) }
  let(:user2) { create(:user, id: 2) }
  let(:my_calendar) { create(:calendar) }
  let(:other_calendar) { create(:calendar) }
  let(:event1) { create(:event, organizer_id: 1) }
  let(:event2) { create(:event, organizer_id: 2) }
  let(:event3) { create(:event, organizer_id: 2) }

  login_user

  before do
    user1.user_calendars.create(calendar_id: my_calendar.id, owner: true)
    user2.user_calendars.create(calendar_id: other_calendar.id, owner: true)
    user1.user_events.create(event_id: event1.id, accepted: true)
    user1.user_events.create(event_id: event2.id, accepted: true)
    user1.user_events.create(event_id: event3.id, accepted: false)
    user2.user_events.create(event_id: event2.id, accepted: true)
    user2.user_events.create(event_id: event3.id, accepted: true)
    CalendarEvent.create(calendar_id: my_calendar.id, event_id: event1.id)
    CalendarEvent.create(calendar_id: my_calendar.id, event_id: event2.id)
    CalendarEvent.create(calendar_id: other_calendar.id, event_id: event2.id)
    CalendarEvent.create(calendar_id: other_calendar.id, event_id: event3.id)
  end

  describe "GET #index" do
    before do
      get :index
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns @notifications" do
      expect(assigns(:notifications)).to eq [{ event: event3, organizer: user2 }]
    end
    it "doesn't contain accepted events in @notifications" do
      expect(assigns(:notifications)).not_to include event2
    end
  end
end
