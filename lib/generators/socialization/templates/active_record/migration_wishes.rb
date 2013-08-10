class CreateWishes < ActiveRecord::Migration
  def change
    create_table :wishes do |t|
      t.string  :wisher_type
      t.integer :wisher_id
      t.string  :wishable_type
      t.integer :wishable_id
      t.datetime :created_at
    end

    add_index :wishes, ["wisher_id", "wisher_type"],       :name => "fk_wishes"
    add_index :wishes, ["wishable_id", "wishable_type"], :name => "fk_wishables"
  end
end




