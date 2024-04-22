module Cpu
  class DataService
    def self.call
      new.parse_lscpu
    end

    def parse_lscpu
      %x{ lscpu }.split("\n")
    end
  end
end
