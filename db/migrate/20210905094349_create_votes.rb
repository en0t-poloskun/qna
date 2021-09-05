# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :value, null: false
      t.belongs_to :votable, polymorphic: true
      t.references :voter, null: false, foreign_key: { to_table: :users }
      t.index %i[voter_id votable_type votable_id], unique: true

      t.timestamps
    end
  end
end
