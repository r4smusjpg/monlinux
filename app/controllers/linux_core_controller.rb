class LinuxCoreController < ApplicationController
  def show
    service = ::LinuxCore::DataService.call

    @host = service.host
    @loaded_modules = service.loaded_modules
  end
end
