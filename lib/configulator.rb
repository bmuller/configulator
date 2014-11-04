require "configulator/version"
require "configulator/config_template"

module Configulator
  def self.from_json(conf, environment = nil)
    JSONConfigTemplate.new conf, environment
  end

  def self.from_json_file(fname, environment = nil)
    from_json File.read(fname), environment
  end

  def self.from_yaml(fname, environment = nil)
    YAMLConfigTemplate.new fname, environment
  end

  def self.from_yaml_file(fname, environment = nil)
    from_yaml File.read(fname), environment
  end
end
