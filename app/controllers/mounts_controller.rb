class MountsController < ApplicationController
  def index
    @data = ::Mounts::DataService.call
  end
end
