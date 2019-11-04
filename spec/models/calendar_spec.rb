require 'rails_helper'

RSpec.describe Calendar, type: :model do
  let(:calendar) { create(:calendar) }

  it "is valid with a name, color" do
    expect(calendar).to be_valid
  end
  it "is invalid without a name" do
    calendar.name = nil
    calendar.valid?
    expect(calendar.errors[:name]).to include("を入力してください")
  end
  it "is invalid with over 50 letters name" do
    calendar.name = "a" * 51
    calendar.valid?
    expect(calendar.errors[:name]).to include("は50文字以内で入力してください")
  end
end
