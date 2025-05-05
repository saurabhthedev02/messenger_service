# frozen_string_literal: true

class CreateMessageReceipts < ActiveRecord::Migration[7.0]
  def change
    create_table :message_receipts do |t|
      t.references :message, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :delivered, default: false
      t.boolean :read, default: false
      t.timestamps
    end
  end
end
