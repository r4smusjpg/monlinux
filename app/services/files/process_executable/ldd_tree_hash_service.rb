module Files
  module ProcessExecutable
    class LddTreeHashService
      def self.call(process_executable)
        new(process_executable).call
      end

      def call
        self
      end

      attr_reader :tree

      private

      def initialize(process_executable)
        @process_executable = process_executable
        @tree = {process_executable => build_tree(process_executable)}
      end

      def build_tree(file)
        temp = []
        ldd = %x{ ldd #{file} }.delete("\t")

        ldd.split("\n").each do |l|
          if l.include?('=>')
            dep = l.split('=>')[0]
            file = l.split('=>')[1].split(' ')[0]

            unless l.include?('not found')
              temp << { dep => build_tree(file) }
            else
              temp << { dep => 'not found' }
            end
          elsif l == 'statically linked'
            temp << l
          else
            temp << l.split(' ')[0]
          end
        end

        temp
      end
    end
  end
end
