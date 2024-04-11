class FilesController < ApplicationController
  def show
    path = URI.decode_uri_component(params[:path].gsub('*', '.'))
    @data = prepare_data(%x{ stat #{path} })
  end

  def prepare_data(data)
    data.gsub(/ +/, ' ').split(/[\n\t]/).map(&:strip)
  end
end
