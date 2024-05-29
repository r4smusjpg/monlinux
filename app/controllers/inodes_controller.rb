class InodesController < ApplicationController
  def show
    inode = params[:inode]
    device_numbers = params[:device_numbers]
    @data = ::Inodes::DataService.call(inode, device_numbers)
  end
end
