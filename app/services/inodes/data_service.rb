module Inodes
  class DataService
    def self.call(inode, device_numbers)
      new(inode, device_numbers)
    end

    attr_reader :mount_name, :data

    private

    def initialize(inode, device_numbers)
      @mount_name = get_mount_name(device_numbers)
      @data = get_data(inode)
    end

    def get_mount_name(device_numbers)
      temp_name = %x{ lsblk | grep #{device_numbers}}&.split(' ')[0]
                                                     &.slice(/\w+/)
      %x{ df  | grep #{temp_name} }.split(' ')[0]
    end

    def get_data(inode)
      %x{ echo "stat <#{inode}>" | debugfs #{@mount_name} }.split("\n")
                                                           .reject { _1 =~ /debugfs/}
    end
  end
end
