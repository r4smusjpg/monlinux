module Inodes
  class DataService
    def self.call(inode, device_numbers)
      new(inode, device_numbers)
    end

    attr_reader :device_name, :data

    private

    def initialize(inode, device_numbers)
      @device_name = get_device_name(device_numbers)
      @data = get_data(inode)
    end

    def get_device_name(device_numbers)
      %x{ lsblk | grep #{device_numbers}}&.split(' ')[0]
                                         &.slice(/\w+/)
    end

    def get_data(inode)
      %x{ echo "stat <#{inode}>" | debugfs /dev/#{@device_name} }.split("\n")
                                                                 .reject { _1 =~ /debugfs/}
    end
  end
end
