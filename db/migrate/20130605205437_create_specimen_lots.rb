class CreateSpecimenLots < ActiveRecord::Migration[4.2]
  def change
    create_table :specimen_lots do |t|

      t.timestamps
    end
  end
end
