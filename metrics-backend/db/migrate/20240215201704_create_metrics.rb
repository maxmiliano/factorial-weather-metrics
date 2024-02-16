# frozen_string_literal: true

class CreateMetrics < ActiveRecord::Migration[7.1]
  def change
    create_table :metrics do |t|
      t.datetime :timestamp
      t.string :name
      t.decimal :value
      t.string :metric_type
      t.string :unit

      t.timestamps
    end

    add_index :metrics, :timestamp
    add_index :metrics, %i[name metric_type]
  end
end
