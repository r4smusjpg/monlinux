module Inodes
  class DataService
    def self.call(inode)
      new.get_data(inode)
    end

    def get_data(inode)
      %x{ echo "stat <#{inode}>" | debugfs /dev/nvme1n1p2 }.split("\n")
                                                           .reject { _1 =~ /debugfs/}
    end
  end
end
