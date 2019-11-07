class User < ApplicationRecord
  has_many :user_events, dependent: :destroy
  has_many :events, through: :user_events
  has_many :user_calendars, dependent: :destroy
  has_many :calendars, through: :user_calendars
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i(facebook google_oauth2)
  validates :name, presence: true, length: { maximum: 50 }

  def self.find_oauth(auth)
    uid = auth.uid
    provider = auth.provider
    snscredential = SnsCredential.where(uid: uid, provider: provider).first
    if snscredential.present?
      user = User.where(id: snscredential.user_id).first
    else
      user = User.where(email: auth.info.email).first
      if user.present?
        SnsCredential.create(
          uid: uid,
          provider: provider,
          user_id: user.id
        )
      else
        user = User.create(
          name: auth.info.name,
          email:    auth.info.email,
          password: Devise.friendly_token[0, 20],
        )
        SnsCredential.create(
          uid: uid,
          provider: provider,
          user_id: user.id
        )
      end
    end
    user
  end
end
