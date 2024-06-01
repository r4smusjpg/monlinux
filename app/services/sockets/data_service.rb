module Sockets
  class DataService
    def self.call(pid)
      new(pid)
    end

    attr_reader :data

    private

    def initialize(pid)
      @pid = pid
      @data = get_data
    end

    def get_data
      %x{ lsof -p #{@pid} }.split("\n").map do |l|
        l = l.split(' ')
        size = l.size
        if size > 9
          glued_el = l[8..-1].join(' ')
          l[0..8].tap { |a| a[8] = glued_el }
        elsif size == 8
          l.insert(5, nil)
        else
          l
        end
      end
    end
  end
end
