module Mounts
  class DataService
    def self.call
      new
    end

    attr_reader :all, :block

    private

    def initialize
      @all = get_all_mounts
      @block = get_block_mounts
    end

    def get_all_mounts
      %x{ mount }.split("\n")
    end

    def get_block_mounts
      %x{ lsblk }.split("\n")
    end
  end
end
