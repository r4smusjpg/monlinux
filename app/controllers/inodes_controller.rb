class InodesController < ApplicationController
  def show
    inode = params[:inode]
    device_numbers = params[:device_numbers]

    service = ::Inodes::DataService.call(inode, device_numbers)

    @data = service.data
    @mount_name = service.mount_name
  end
end
