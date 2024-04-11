class ProcessesController < ApplicationController
  def index
    @processes = ::Processes::TreeHashService.call
  end

  def show
    pid = params[:pid]

    @data = %x{ cat /proc/#{pid}/status }.split("\n")
  end
end
