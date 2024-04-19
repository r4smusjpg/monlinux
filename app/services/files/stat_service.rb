require 'inline'

module Files
  class StatService
    class StatCStruct
      FIELDS = %i[
        st_dev st_ino st_mode st_nlink st_uid st_gid st_rdev
        st_size st_blksize st_blocks st_atime st_mtime st_ctime
      ].freeze

      def initialize(params)
        params.each do |k, v|
          public_send(:"#{k}=", v)
        end
      end

      attr_accessor *FIELDS
    end

    def self.call(path, fields = nil)
      %x{ ruby ./stat_service.rb }
      new(path, fields).build_stat
    end

    def build_stat
      params_hash = {}
      @fields.each { |f| params_hash[f] = public_send(:"get_#{f}", @path) }
      StatCStruct.new(params_hash)
    end

    private

    def initialize(path, fields = nil)
      @path = path
      @fields = fields.nil? ? StatCStruct::FIELDS : fields
    end

    inline(:C) do |builder|
      builder.include('<sys/stat.h>')
      builder.include('<sys/sysmacros.h>')
      builder.include('<sys/types.h>')
      builder.include('<bsd/string.h>')
      builder.include('<pwd.h>')
      builder.include('<grp.h>')
      builder.include('<time.h>')
      builder.c <<~C
        char *get_st_dev(const char *path)
        {
          struct stat statbuf;
          stat(path, &statbuf);

          char res[30];

          dev_t dev = statbuf.st_dev;
          int devMajor = major(dev);
          int devMinor = minor(dev);
          sprintf(res, "%d,%d", devMajor, devMinor);

          return res;
        }
      C
      builder.c <<~C
        char *get_st_ino(const char *path)
        {
          struct stat statbuf;
          stat(path, &statbuf);

          char res[30];

          ino_t ino = statbuf.st_ino;
          sprintf(res, "%lu", ino);

          return res;
        }
      C
      builder.c <<~C
        char *get_st_mode(const char *path)
        {
          struct stat statbuf;
          stat(path, &statbuf);

          char res[30];

          mode_t mode = statbuf.st_mode;
          sprintf(res, "%d", mode);

          return res;
        }
      C
      builder.c <<~C
        char *get_st_nlink(const char *path)
        {
          struct stat statbuf;
          stat(path, &statbuf);

          char res[30];

          nlink_t nlinks = statbuf.st_nlink;
          sprintf(res, "%lu", nlinks);

          return res;
        }
      C
      builder.c <<~C
        char *get_st_uid(const char *path)
        {
          struct stat statbuf;
          stat(path, &statbuf);

          char res[30];

          uid_t uid = statbuf.st_uid;
          struct passwd *passwdbuf;
          passwdbuf = getpwuid(uid);
          sprintf(res, "%d/%s", uid, passwdbuf->pw_name);

          return res;
        }
      C
      builder.c <<~C
        char *get_st_gid(const char *path)
        {
          struct stat statbuf;
          stat(path, &statbuf);

          char res[30];

          gid_t gid = statbuf.st_gid;
          struct group *grp;
          grp = getgrgid(gid);
          sprintf(res, "%d/%s", gid, grp->gr_name);

          return res;
        }
      C
      builder.c <<~C
        char *get_st_rdev(const char *path)
        {
          struct stat statbuf;
          stat(path, &statbuf);

          char res[30];

          dev_t rdev = statbuf.st_rdev;
          sprintf(res, "%lu", rdev);

          return res;
        }
      C
      builder.c <<~C
        char *get_st_size(const char *path)
        {
          struct stat statbuf;
          stat(path, &statbuf);

          char res[30];

          off_t size = statbuf.st_size;
          sprintf(res, "%lu", size);

          return res;
        }
      C
      builder.c <<~C
        char *get_st_blksize(const char *path)
        {
          struct stat statbuf;
          stat(path, &statbuf);

          char res[30];

          blksize_t blksize = statbuf.st_blksize;
          sprintf(res, "%lu", blksize);

          return res;
        }
      C
      builder.c <<~C
        char *get_st_blocks(const char *path)
        {
          struct stat statbuf;
          stat(path, &statbuf);

          char res[30];

          blkcnt_t blocks = statbuf.st_blocks;
          sprintf(res, "%lu", blocks);

          return res;
        }
      C
      builder.c <<~C
        char *get_st_atime(const char *path)
        {
          struct stat statbuf;
          stat(path, &statbuf);


          char res[30];

          time_t atime = statbuf.st_atime;
          strftime(res, 30,"%X - %x", localtime(&atime));

          return res;
        }
      C
      builder.c <<~C
        char *get_st_mtime(const char *path)
        {
          struct stat statbuf;
          stat(path, &statbuf);

          char res[30];

          time_t mtime = statbuf.st_mtime;
          strftime(res, 30,"%X - %x", localtime(&mtime));

          return res;
        }
      C
      builder.c <<~C
        char *get_st_ctime(const char *path)
        {
          struct stat statbuf;
          stat(path, &statbuf);

          char res[30];

          time_t chtime = statbuf.st_ctime;
          strftime(res, 30,"%X - %x", localtime(&chtime));

          return res;
        }
      C
    end
  end
end
