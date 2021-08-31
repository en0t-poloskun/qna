# frozen_string_literal: true

class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.string :name, null: false
      t.references :question, null: false, foreign_key: true
      t.belongs_to :owner, class_name: 'User'

      t.timestamps
    end
  end
end
