class ProcessStruct
  attr_reader :pid, :ppid, :uid, :username, :name

  def initialize(params)
    @pid = params[:pid].to_i
    @ppid = params[:ppid].to_i
    @uid = params[:uid].to_i
    @name = params[:name]
    @username = get_username
  end

  def get_username
    %x{ id -nu #{@uid} }.chomp
  end
end
