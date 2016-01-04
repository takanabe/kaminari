require 'test_helper'

class ConfigurationMethodTest < Minitest::Test
  alias assert_not_respond_to refute_respond_to

  def model; User end

  def setup; end

  def teardown
    Kaminari.configure do |c|
      c.default_per_page = 25
      c.max_per_page     = nil
      c.max_pages        = nil
    end

    model.paginates_per     nil
    model.max_paginates_per nil
  end

  def test_AR_Base_does_not_respond_to_any_configuration_methods
    assert_not_respond_to ActiveRecord::Base, :paginates_per
    assert_not_respond_to ActiveRecord::Base, :max_pages_per
    assert_not_respond_to ActiveRecord::Base, :max_paginates_per
  end

  def test_default_per_page_by_default
    assert_equal model.page(1).limit_value, 25
  end

  def test_default_per_page_when_configuring_both_on_global_and_model_level
    Kaminari.configure {|c| c.default_per_page = 50 }
    model.paginates_per 100

    assert_equal model.page(1).limit_value, 100
  end

  def test_default_per_page_when_configuring_multiple_times
    Kaminari.configure {|c| c.default_per_page = 10 }
    Kaminari.configure {|c| c.default_per_page = 20 }
    model.paginates_per nil

    assert_equal model.page(1).limit_value, 20
  end

  def test_max_per_page_by_default
    assert_equal model.page(1).per(1000).limit_value, 1000
  end

  def test_max_per_page_when_configuring_both_on_global_and_model_level
    Kaminari.configure {|c| c.max_per_page = 50 }
    model.max_paginates_per 100

    assert_equal model.page(1).per(1000).limit_value, 100
  end

  def test_max_per_page_when_configuring_multiple_times
    Kaminari.configure {|c| c.max_per_page = 10 }
    Kaminari.configure {|c| c.max_per_page = 20 }

    assert_equal model.page(1).per(1000).limit_value, 20
  end

  def test_max_pages_by_default
    create_users!

    assert_equal model.page(1).per(5).total_pages, 20
  end

  def test_max_pages_when_configuring_both_on_global_and_model_level
    create_users!

    Kaminari.configure {|c| c.max_pages = 10 }
    model.max_pages_per 15

    assert_equal model.page(1).per(5).total_pages, 15
  end

  def test_max_pages_when_configuring_multiple_times
    create_users!

    Kaminari.configure {|c| c.max_pages = 10 }
    Kaminari.configure {|c| c.max_pages = 15 }

    assert_equal model.page(1).per(5).total_pages, 15
  end

  private

  def create_users!
    100.times {|count| model.create!(:name => "User#{count}") }
  end
end

