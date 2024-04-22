class CpuController < ApplicationController
  def show
    @data = ::Cpu::DataService.call
  end
end
