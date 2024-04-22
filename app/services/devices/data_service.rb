module Devices
  class DataService
    def self.call(type)
      new.get_data(type)
    end

    def get_data(type)
      case type
      when 'pci'
        %x{ lspci }.split("\n")
      when 'usb'
        %x{ lsusb }.split("\n")
      end
    end
  end
end
