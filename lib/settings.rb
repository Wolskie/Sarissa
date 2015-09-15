class Settings
    class << self

        undef_method :new

        attr_accessor :config

        def load(file)

            begin
                @config = YAML::load(File.read(file))
            rescue
                @config = {}
            end

            if (not @config)
                @config = {}
            end

            return true
        end

        def save(file)
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
    end
end

Settings.load("config/settings.yml")
