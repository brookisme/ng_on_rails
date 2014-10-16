require "ng_on_rails/engine"
module NgOnRails
  mattr_accessor :config, :engine_path

  def self.set_engine engine
    self.engine_path = "#{engine.name.underscore}/"
  end
end