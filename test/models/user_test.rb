# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#name_or_email_exists' do
    user1 = users(:alice)
    user2 = users(:carol)
    assert_equal(user1.name_or_email, user1.email)
    assert_equal(user2.name_or_email, user2.name)
  end
end
