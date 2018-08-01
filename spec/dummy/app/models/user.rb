# frozen_string_literal: true

class User < ApplicationRecord
  include Hertz::Notifiable

  has_many :registration_ids
end
