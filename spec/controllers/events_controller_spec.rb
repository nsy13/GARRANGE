require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user1) { create(:user, id: 1) }
  let(:user2) { create(:user, id: 2) }
  let(:user3) { create(:user, id: 3) }
  let(:calendar) { create(:calendar) }
  let(:event) { create(:event, id: 1, organizer_id: 1) }

  login_user

  before do
    user1.user_calendars.create(calendar_id: calendar.id, owner: true)
    user1.user_events.create(event_id: event.id, accepted: true)
    user2.user_events.create(event_id: event.id, accepted: true)
    user3.user_events.create(event_id: event.id, accepted: false)
    CalendarEvent.create(calendar_id: calendar.id, event_id: event.id)
  end

  describe "#show" do
    before do
      get :show, xhr: true, params: { id: 1 }
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns @event" do
      expect(assigns(:event)).to eq event
    end
    it "assigns @organizer" do
      expect(assigns(:organizer)).to eq user1
    end
    it "assigns @participants" do
      expect(assigns(:participants)).to eq [user1, user2]
    end
    it "assigns @inviting_users" do
      expect(assigns(:inviting_users)).to eq [user3]
    end
    it "assigns @calendars" do
      expect(assigns(:calendars)).to eq [calendar]
    end
    it "render correct template" do
      expect(response).to render_template(:show)
    end
  end
end
