class Room < ApplicationRecord
  belongs_to :user
  has_many :videos, dependent: :destroy
  before_create :generate_access_key

  private

  def generate_access_key
    self.access_code = SecureRandom.hex(6)
  end
end
