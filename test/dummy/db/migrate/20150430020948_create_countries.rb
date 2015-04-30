class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.integer    :active, limit: 1
      t.string     :code
      t.string     :name
      t.timestamps null: false
    end
  end
end
