module FileHelper
  def get_package_url(package)
    %x{ pacman -Qi #{package} | grep URL }.split(':').last.strip
  end
end
