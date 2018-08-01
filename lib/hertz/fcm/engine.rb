# frozen_string_literal: true

module Hertz
  module Fcm
    class Engine < ::Rails::Engine
      isolate_namespace Hertz::Fcm
    end
  end
end
