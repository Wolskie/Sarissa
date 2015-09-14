
class Settings
    class << self

        undef_method :new

        attr_accessor :config

        def load(file)
            $stdout.puts("Amber: (load): Loading configuration")

            begin
                @config = YAML::load(File.read(file))
            rescue
                @config = {}
            end

            if (not @config)
                @config = {}
            end

            write_defaults()
            save(file)

            $stdout.puts("Amber: (load): Running using configuration:")

            return true
        end

        def save(file)
            $stdout.puts("Amber: (save): Writing configuration.")
            File.open(file, 'w') do |f|
                f.write(@config.to_yaml)
            end
        end

        def all()
            @config
        end

        def [](k)
            @config[k]
        end

        def []=(k)
            @config[k] = v
        end

        private
        def write_defaults()
            @config['port']            = '9292'
            @config['ginger']  = 'D:\Home\Ginger'
            @config['bind_address']    = '127.0.0.1'
            @config['show_exceptions'] = 'true'
        end

    end
end

Settings.load("config/settings.yml")
