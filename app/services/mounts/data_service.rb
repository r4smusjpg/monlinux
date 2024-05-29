module Mounts
  class DataService
    def self.call
      new.call
    end

    def call
      %x{ mount }.split("\n")
    end
  end
end
