require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "#index without logged in" do
    context "when user not signed-in" do
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "#index when user not logged in" do
    let(:user1) { create(:user, id: 1) }
    let(:user2) { create(:user, id: 2) }
    let(:calendars) { create_list(:calendar, 3) }
    let(:event1) { create(:event, organizer_id: 1) }
    let(:event2) { create(:event, organizer_id: 1) }
    let(:event3) { create(:event, organizer_id: 2) }

    login_user

    before do
      user1.user_calendars.create(calendar_id: calendars[0].id, owner: true)
      user1.user_calendars.create(calendar_id: calendars[1].id, owner: true)
      user1.user_calendars.create(calendar_id: calendars[2].id, owner: false)
      user2.user_calendars.create(calendar_id: calendars[2].id, owner: true)
      user2.user_calendars.create(calendar_id: calendars[0].id, owner: false)
      user2.user_calendars.create(calendar_id: calendars[1].id, owner: false)
      user1.user_events.create(event_id: event1.id, accepted: true)
      user1.user_events.create(event_id: event2.id, accepted: true)
      user2.user_events.create(event_id: event3.id, accepted: true)
      CalendarEvent.create(calendar_id: calendars[0].id, event_id: event1.id)
      CalendarEvent.create(calendar_id: calendars[1].id, event_id: event2.id)
      CalendarEvent.create(calendar_id: calendars[2].id, event_id: event3.id)
    end

    context "when visit my home page" do
      before do
        get :index
      end

      it "have a current_user" do
        expect(subject.current_user).to eq user1
      end
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "assigns @user" do
        expect(assigns(:user)).to eq user1
      end
      it "assigns @my_calendars" do
        expect(assigns(:my_calendars)).to eq calendars[0..1]
      end
      it "assigns @others_calendars" do
        expect(assigns(:others_calendars)).to eq [calendars[2]]
      end
      it "assigns @display_events" do
        expect(assigns(:display_events)).to eq [event1]
      end
      it "render correct template" do
        expect(response).to render_template(:index)
      end
    end

    context "when visit others home page" do
      before do
        get :index, params: { user_id: 2 }
      end

      it "have a current_user" do
        expect(subject.current_user).to eq user1
      end
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "assigns @user" do
        expect(assigns(:user)).to eq user2
      end
      it "assigns @my_calendars" do
        expect(assigns(:my_calendars)).to eq [calendars[2]]
      end
      it "assigns @others_calendars" do
        expect(assigns(:others_calendars)).to eq calendars[0..1]
      end
      it "assigns @display_events" do
        expect(assigns(:display_events)).to eq [event3]
      end
      it "render correct template" do
        expect(response).to render_template(:index)
      end
    end
  end
end
