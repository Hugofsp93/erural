class Video < ApplicationRecord
  belongs_to :room

  def as_json
    {
      id: id,
      name: name,
      url: url,
      description: description,
      room_id: room_id
    }
  end
end
