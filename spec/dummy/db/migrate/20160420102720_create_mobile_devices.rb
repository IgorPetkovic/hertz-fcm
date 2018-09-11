# frozen_string_literal: true

class CreateMobileDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :mobile_devices do |t|
      t.string :token
      t.references :user
    end
  end
end
