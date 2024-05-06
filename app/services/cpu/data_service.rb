module Cpu
  class DataService
    def self.call
      new.get_data
    end

    def get_data
      %x{ lscpu }.split("\n")
    end
  end
end
