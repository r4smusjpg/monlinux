module Inodes
  class DataService
    def self.call(inode, device_numbers)
      new.get_data(inode, device_numbers)
    end

    def get_data(inode, device_numbers)
      mount_name = %x{ lsblk | grep #{device_numbers}}&.split(' ')[0]
                                                      &.slice(/\w+/)
      %x{ echo "stat <#{inode}>" | debugfs /dev/#{mount_name} }.split("\n")
                                                               .reject { _1 =~ /debugfs/}
    end
  end
end
