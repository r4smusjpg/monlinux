class MountsController < ApplicationController
  def index
    service = ::Mounts::DataService.call

    @all = service.all
    @block = service.block
  end
end
