module ConfigManager
  @@config = nil
  
  def self.load_config
    config_path = "config/ng_on_rails.yml"
    config = self.load_yaml(config_path)
    unless config.blank? || config['test_app'].blank?
      namespace = config['test_app']['namespace']
      unless config['test_app']['config_file'].blank?
        config_path = "config/#{config['test_app']['config_file']}.yml"
      end
      config = self.load_yaml("#{config['test_app']['root']}/#{config_path}")
    end
    unless config.blank? || namespace.blank?
      config = config[namespace]
    end
    if config.blank?
      config = YAML.load("empty: true")
    end
    config
  end

  def self.load_yaml path
    unless path.blank?
      mounted_path = File.join(NgOnRails.mounted_engine_root.to_s,path)
      if File.exists?(mounted_path)
        YAML.load(File.read(mounted_path))
      end
    end
  end
end