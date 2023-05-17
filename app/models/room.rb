class Room < ApplicationRecord
  belongs_to :user
  has_many :videos, dependent: :destroy
  before_create :generate_access_key

  def as_json
    {
      id: id,
      name: name,
      description: description,
      user_id: user_id,
      name_user: User.find(user_id).email, # TODO: implementar nome do usuário, pra não exibir o email de quem convidou
      access_code: access_code,
      open: self.open,
      videos: self.videos.first.as_json
    }
  end

  private

  def generate_access_key
    self.access_code = SecureRandom.hex(6)
  end
end
