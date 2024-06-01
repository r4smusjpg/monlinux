class SocketsController < ApplicationController
  def index
    @pid = params[:pid]
    service = ::Sockets::DataService.call(@pid)
    @data = service.data
  end
end
