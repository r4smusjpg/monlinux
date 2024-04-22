module Memory
  class DataService
    def self.call(type)
      new.get_data(type)
    end

    def get_data(type)
      case type
      when 'disk'
        [
          %x{ inxi -d }.split("\n")
                       .drop(1),
          %x{ df -h }
        ]
      when 'ram'
        [
          %x{ inxi -m }.split("\n")
                       .drop(1),
          %x{ free -m }.split("\n")
        ]
      end
    end
  end
end
