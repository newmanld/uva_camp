require 'blacklight/catalog'
class DashboardController < ApplicationController
  include Sufia::DashboardControllerBehavior
  include Hydra::Collections::SelectsCollections
  layout 'sufia-two-column'
  
  before_filter :find_collections, :only=>:index  
  
  helper :collections
  
end
