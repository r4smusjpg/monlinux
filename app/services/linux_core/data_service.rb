module LinuxCore
  class DataService
    def self.call
      new
    end

    attr_reader :host, :loaded_modules

    private

    def initialize
      @host = get_host
      @loaded_modules = get_loaded_modules
    end

    def get_host
      %x{ hostnamectl }.split("\n").map(&:strip)
    end

    def get_loaded_modules
      %x{ lsmod }.split("\n").map { _1.gsub(/\s+/, ' ') }.drop(1)
    end
  end
end
