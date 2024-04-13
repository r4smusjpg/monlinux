class FilesController < ApplicationController
  def show
    path = URI.decode_uri_component(params[:path].gsub('*', '.'))
    @data = get_data(path)
  end

  def get_data(path)
    %x{ stat #{path} }.gsub(/ +/, ' ')
                      .split(/[\n\t]/)
                      .map(&:strip)
  end
end
