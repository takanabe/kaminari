# frozen_string_literal: true
require 'kaminari/activerecord/active_record_relation_methods'

module Kaminari
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    included do
      include Kaminari::ConfigurationMethods

      # Fetch the values at the specified page number
      #   Model.page(5)
      eval <<-RUBY, nil, __FILE__, __LINE__ + 1
        def self.#{Kaminari.config.page_method_name}(num = nil)
          if Kaminari.config.max_pages
            if num.to_i > Kaminari.config.max_pages && Kaminari.config.raise_on_max_page_violation
              raise MaxPageViolation
            end
          end
          limit(default_per_page).offset(default_per_page * ((num = num.to_i - 1) < 0 ? 0 : num)).extending do
            include Kaminari::ActiveRecordRelationMethods
            include Kaminari::PageScopeMethods
          end
        end
      RUBY
    end
  end
end
