class DevicesController < ApplicationController
  def show
    @type = params[:type]
    @data = ::Devices::DataService.call(@type)
  end
end
