module Files
  module SharedLibs
    class PathService
      def self.call(shared_lib)
        new.get_path(shared_lib)
      end

      def get_path(shared_lib)
        shared_lib_path = %x{ strings /etc/ld.so.cache | grep #{shared_lib} }.first
        return shared_lib_path unless shared_lib_path.blank?
        File.exist?("/usr/lib/#{shared_lib}") ? "/usr/lib/#{shared_lib}" : "/usr/lib32/#{shared_lib}"
      end
    end
  end
end
