module Files
  module SharedLibs
    class DataService
      def self.call(shared_lib)
        new(shared_lib)
      end

      attr_reader :path, :package

      private

      def initialize(shared_lib)
        @shared_lib = shared_lib
        @path = get_path
        @package = get_package
      end

      def get_package
        %x{ pacman -Qo #{get_path} }.split('by')[1].strip
      end

      def get_path
        shared_lib_path = %x{ strings /etc/ld.so.cache | grep #{@shared_lib} }.split("\n")
                                                                              .first
        if shared_lib_path.blank?
          %x{ find / -name #{@shared_lib} }.split("\n").first
        else
          shared_lib_path
        end
      end
    end
  end
end
