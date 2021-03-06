# encoding: utf-8

require 'test_helper'

module Adapi
  class ConfigTest < Test::Unit::TestCase

    context "Loading adapi.yml" do
      should "load the configuration" do
        Adapi::Config.dir             = 'test/fixtures'
        Adapi::Config.filename        = 'adapi.yml'
        @settings                     = Adapi::Config.settings(true)

        assert_equal '555-666-7777', @settings[:default][:authentication][:client_customer_id]
        assert_instance_of Hash, @settings[:default][:authentication][:oauth2_token]
      end
    end

  end
end
