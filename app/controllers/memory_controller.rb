class MemoryController < ApplicationController
  def show
    @type = params[:type]
    @data = ::Memory::DataService.call(@type)
  end
end
