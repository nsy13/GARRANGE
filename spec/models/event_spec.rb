require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { create(:event) }

  it "is valid with a title, start_date, end_date" do
    expect(event).to be_valid
  end
  it "is invalid without a title" do
    event.title = nil
    event.valid?
    expect(event.errors[:title]).to include("を入力してください")
  end
  it "is invalid without a start_date" do
    event.start_date = nil
    event.valid?
    expect(event.errors[:start_date]).to include("を入力してください")
  end
  it "is invalid without a end_date" do
    event.end_date = nil
    event.valid?
    expect(event.errors[:end_date]).to include("を入力してください")
  end
  it "is invalid with over 300 letters description" do
    event.description = "a" * 301
    event.valid?
    expect(event.errors[:description]).to include("は300文字以内で入力してください")
  end
  it "is invalid with earlier end_date than start_date" do
    event.end_date = event.start_date - 1.day
    event.valid?
    expect(event.errors[:end_date]).to include("の日付を正しく記入してください")
  end
end
