class ProcessesController < ApplicationController
  def index
    @processes = ::Processes::TreeHashService.call
  end

  def show
    pid = params[:pid]

    service = ::Processes::DataService.call(pid)
    @data = service.data
    @executable_file = service.executable_file
    @fd = service.fd
    @memory_map = service.memory_map
  end
end
