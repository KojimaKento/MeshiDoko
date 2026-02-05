class CreateRestaurants < ActiveRecord::Migration[8.1]
  def change
    create_table :restaurants do |t|
      t.string :external_id
      t.string :name
      t.string :genre
      t.string :address
      t.decimal :latitude
      t.decimal :longitude
      t.integer :budget_lunch
      t.integer :budget_dinner
      t.decimal :rating
      t.boolean :is_open
      t.jsonb :opening_hours
      t.string :sns_instagram
      t.string :sns_twitter
      t.string :sns_facebook
      t.string :reservation_url
      t.string :source

      t.timestamps
    end
  end
end
