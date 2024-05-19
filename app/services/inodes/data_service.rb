module Inodes
  class DataService
    def self.call(inode)
      new.get_data(inode)
    end

    def get_data(inode)
      mount_name = %x{ df }.split("\n")[4].split(' ')[0]
      %x{ echo "stat <#{inode}>" | debugfs #{mount_name} }.split("\n")
                                                          .reject { _1 =~ /debugfs/}
    end
  end
end
