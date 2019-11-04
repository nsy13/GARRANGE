require 'rails_helper'

RSpec.describe CalendarsController, type: :controller do
  let(:user1) { create(:user, id: 1) }
  let(:my_calendars) { create_list(:calendar, 2) }
  let(:others_calendar) { create(:calendar) }

  login_user

  before do
    user1.user_calendars.create(calendar_id: my_calendars[0].id, owner: true)
    user1.user_calendars.create(calendar_id: my_calendars[1].id, owner: true)
    user1.user_calendars.create(calendar_id: others_calendar.id, owner: false)
  end

  describe "#setting" do
    before do
      get :setting
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns @my_calendars" do
      expect(assigns(:my_calendars)).to eq my_calendars
    end
    it "is no other_calendars in @my_calendars" do
      expect(assigns(:my_calendars)).not_to include others_calendar
    end
    it "assigns @calendar" do
      expect(assigns(:calendar)).to eq my_calendars[0]
    end
    it "render correct template" do
      expect(response).to render_template(:setting)
    end
  end
end
