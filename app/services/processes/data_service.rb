module Processes
  class DataService
    def self.call(pid)
      new(pid)
    end

    attr_reader :data, :fd, :memory_map

    private

    def initialize(pid)
      @pid = pid

      @data = get_data
      @fd = get_fd
      @memory_map = get_memory_map
    end

    def get_data
      %x{ cat /proc/#{@pid}/status }.split("\n")
    end

    def get_fd
      %x{ echo 123 | ls -l /proc/#{@pid}/fd }.split("\n")
                                             .drop(1)
                                             .map { _1.split('->') }
                                             .map { [_1[0].split(' ').last, _1[1].strip] }
                                             .to_h
    end

    def get_memory_map
      %x{ pmap #{@pid} }.split("\n")
                        .drop(1)
    end
  end
end
