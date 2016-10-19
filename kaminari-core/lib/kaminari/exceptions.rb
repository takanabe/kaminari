# frozen_string_literal: true
module Kaminari
  class ZeroPerPageOperation < ZeroDivisionError; end
  class MaxPageViolation < RuntimeError; end
end
