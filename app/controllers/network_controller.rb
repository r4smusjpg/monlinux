class NetworkController < ApplicationController
  def show
    service = ::Network::DataService.call

    @interfaces_data = service.interfaces_data
    @routing_table = service.routing_table
  end
end
