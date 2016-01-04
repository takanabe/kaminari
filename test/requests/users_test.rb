# encoding: UTF-8
require 'test_helper'

class PaginationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  def setup
    100.times {|i| User.create! :name => "user#{'%03d' % i}" }
  end

  def test_navigating_by_pagination_links
    visit '/users'

    within 'nav.pagination' do
      within 'span.page.current' do
        assert_text '1'
      end
      within 'span.next' do
        click_link 'Next ›'
      end
    end

    within 'nav.pagination' do
      within 'span.page.current' do
        assert_text '2'
      end
      within 'span.last' do
        click_link 'Last »'
      end
    end

    within 'nav.pagination' do
      within 'span.page.current' do
        assert_text '4'
      end
      within 'span.prev' do
        click_link '‹ Prev'
      end
    end

    within 'nav.pagination' do
      within 'span.page.current' do
        assert_text '3'
      end
      within 'span.first' do
        click_link '« First'
      end
    end

    within 'nav.pagination' do
      within 'span.page.current' do
        assert_text '1'
      end
    end
  end
end
