class CreateBeens < ActiveRecord::Migration
  def change
    create_table :beens do |t|
      t.string  :beener_type
      t.integer :beener_id
      t.string  :beenable_type
      t.integer :beenable_id
      t.datetime :created_at
    end

    add_index :beens, ["liker_id", "beener_type"],       :name => "fk_beens"
    add_index :beens, ["likeable_id", "beenable_type"], :name => "fk_beenables"
  end
end
