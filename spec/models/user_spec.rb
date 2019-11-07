require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { build(:user) }

  it "is valid with a name, email and password" do
    expect(user2).to be_valid
  end
  it "is invalid without a name" do
    user2.name = nil
    user2.valid?
    expect(user2.errors[:name]).to include("を入力してください")
  end
  it "is invalid with over 50 letters name" do
    user2.name = "a" * 51
    user2.valid?
    expect(user2.errors[:name]).to include("は50文字以内で入力してください")
  end
  it "is invalid without a email" do
    user2.email = nil
    user2.valid?
    expect(user2.errors[:email]).to include("を入力してください")
  end
  it "is invalid without a password" do
    user2.password = nil
    user2.valid?
    expect(user2.errors[:password]).to include("を入力してください")
  end
  it "is invalid with duplicate email" do
    user2.email = user1.email
    user2.valid?
    expect(user2.errors[:email]).to include("はすでに存在します")
  end
end
