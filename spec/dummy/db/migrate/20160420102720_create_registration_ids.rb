# frozen_string_literal: true

class CreateRegistrationIds < ActiveRecord::Migration[5.2]
  def change
    create_table :registration_ids do |t|
      t.string :token
      t.references :user
    end
  end
end
