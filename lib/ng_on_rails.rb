require "ng_on_rails/engine"
module NgOnRails
  mattr_accessor :config, :mounted_engine_root, :engine_path

  def self.set_engine engine
    self.mounted_engine_root = engine::Engine.root
    self.engine_path = "#{engine.name.underscore}/"
  end
end