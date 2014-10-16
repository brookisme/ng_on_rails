module ConfigManager
  @@config = nil
  
  def self.load_config
    config_path = "config/ng_on_rails.yml"
    config = self.load_yaml(config_path) 
    unless config.blank? || config['test_app_path'].blank?
      config_path = "#{config['test_app_path']}/config/ng_on_rails.yml"
      config = self.load_yaml(config_path) 
    end
    config = YAML.load("empty: true") if config.blank?
    config
  end

  def self.load_yaml path
    unless path.blank?
      unless Rails.root.blank?
        path = File.join(Rails.root.to_s,path)
      end
      if File.exists?(path)
        YAML.load(File.read(path))
      end
    end
  end
end