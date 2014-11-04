require 'yaml'
require 'json'
require 'erb'
 
module Configulator
  class ConfStruct < Struct
    def get_binding
      binding
    end
  end

  class ConfigTemplate
    def initialize(conf, environment = nil)
      if environment.nil?
        @binding = make_binding conf
      else
        raise "No such environment: #{environment}" unless conf.has_key? environment
        env = conf[environment]
        env = conf['default'].merge(env) if conf.has_key? 'default'
        env['environment_name'] = environment
        @binding = make_binding env
      end
    end

    def convert_file(infile)
      ERB.new(File.read(infile)).result(@binding)
    end
    
    def get(name)
      eval name.to_s, @binding
    end
    
    def method_missing(name, *args, &block)
      get name
    end
    
    private
    def make_binding(env)
      klass = ConfStruct.new *env.keys.map(&:intern)
      k = klass.new *env.values
      # support up to 5 levels of embedding
      5.times do
        values = env.values.map do |v|
          v.is_a?(String) ? ERB.new(v).result(k.get_binding) : v
        end
        k = klass.new *values
      end
      k.get_binding
    end
  end

  class JSONConfigTemplate < ConfigTemplate
    def initialize(config, environment = nil)
      super JSON.parse(config), environment
    end    
  end

  class YAMLConfigTemplate < ConfigTemplate
    def initialize(config, environment = nil)
      super YAML.load(config), environment
    end
  end
end
