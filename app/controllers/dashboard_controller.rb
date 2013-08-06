require 'blacklight/catalog'
class DashboardController < ApplicationController
  include Sufia::DashboardControllerBehavior
  layout 'sufia-two-column'
end
