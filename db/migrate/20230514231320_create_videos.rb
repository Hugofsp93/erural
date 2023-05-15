class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.text :description, null: false
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
