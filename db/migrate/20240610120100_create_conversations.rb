# frozen_string_literal: true

class CreateConversations < ActiveRecord::Migration[7.0]
  def change
    create_table :conversations do |t|
      t.string :name
      t.boolean :is_group, default: false
      t.timestamps
    end
  end
end
