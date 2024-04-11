module Processes
  class TreeHashService
    ATTRIBUTES = %w[Pid PPid Uid Name].freeze
    PIDS = Dir.new('/proc/').children.select { _1 =~ /\d/ }.freeze
    ROOT = ::ProcessStruct.new(pid: 0, ppid: 0, uid: 0, name: 'linux-core')

    def self.call
      self.new.tree
    end

    attr_reader :tree

    private

    def initialize
      parse
      build_ppid_children_hash

      @tree = build_tree(0)
    end

    def parse
      @procs = []

      PIDS.each do |pid|
        begin
          data = File.read("/proc/#{pid}/status")
        rescue StandardError
          next
        end

        proc = ::ProcessStruct.new(prepare_data(data))
        @procs << proc
      end
    end

    def build_ppid_children_hash
      @parent_children_hash = {}

      @procs.each do |p|
        if @parent_children_hash.key?(p.ppid)
          @parent_children_hash[p.ppid] = @parent_children_hash[p.ppid] << p
        else
          @parent_children_hash[p.ppid] = [p]
        end
      end
    end

    def build_tree(ppid, parent = ROOT)
      return parent if @parent_children_hash[ppid].nil?

      tmp_tree = {}

      @parent_children_hash[ppid].each do |p|
        if tmp_tree.key?(parent)
          tmp_tree[parent] = tmp_tree[parent] << build_tree(p.pid, p)
        else
          tmp_tree[parent] = [build_tree(p.pid, p)]
        end
      end

      tmp_tree
    end

    def prepare_data(data)
      data = data.gsub("\t", ' ')
                 .split("\n")
                 .select { ATTRIBUTES.include?(_1.split(':').first) }
                 .map { [_1.split(': ').first.downcase, _1.split(': ').last.strip] }
                 .to_h
                 .tap { |h| h["uid"] = h["uid"].split(' ').first }
                 .symbolize_keys
    end
  end
end
