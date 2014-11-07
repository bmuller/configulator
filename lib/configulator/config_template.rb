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
    def initialize(conf, environment = nil, extra_opts={})
      if environment.nil?
        @binding = make_binding conf
      else
        raise "No such environment: #{environment}" unless conf.has_key? environment
        env = conf[environment]
        env = env.merge(extra_opts)
        env = conf['default'].merge(env) if conf.has_key? 'default'
        env['environment_name'] = environment
        @binding = make_binding env
      end
    end

    def convert_file(infile, out_path=nil)
      # retuns a StringIO if out_path is not given
      begin
        out = out_path.nil? ? StringIO.new : File.open(out_path, 'w')
        e = ERB.new(File.open(infile).read)
        out.write(e.result(@binding))
        out.seek 0
        return out
      ensure
        out.close if out.is_a? File
      end
    end

    def get(name)
      eval name.to_s, @binding
    end

    def [](name)
      get(name) rescue nil
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
          # do not eval non-strings, it's the final value already
          v.is_a?(String) && v =~ /^=\s*(.*)/ ? eval($1, k.get_binding) : v
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
