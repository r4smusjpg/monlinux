class InodesController < ApplicationController
  def show
    inode = params[:inode]
    @data = Inodes::DataService.call(inode)
  end
end
