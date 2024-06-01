module Network
  class DataService
    def self.call
      new
    end

    attr_reader :interfaces_data, :routing_table

    private

    def initialize
      @interfaces_data = get_interfaces_data
      @routing_table = get_routing_table
    end

    def get_interfaces_data
      %x{ ip addr }.split("\n")
    end

    def get_routing_table
      %x{ ip route }.split("\n")
    end
  end
end
