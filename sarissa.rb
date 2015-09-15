require 'json'
require 'yaml'
require 'bcrypt'
require 'sinatra/base'
require 'warden'
require 'data_mapper'


class Sarissa < Sinatra::Base

    set :root, File.join(File.dirname(__FILE__), "app")
    set :public_folder, File.join(File.dirname(__FILE__), "public")

    use Warden::Manager do |config|

        # Tell Warden to store the User info
        # as a session object that takes strings only.
        #
        config.serialize_into_session do |user|
            user.id
        end

        # Tell Warden how to take what we've store in the
        # session and return a user from it.
        #
        config.serialize_from_session do |id|
            User.get(id)
        end

        # When the user fails the challenge redirect to the
        # 'auth/unauthenticated' route
        #
        config.scope_defaults :default,
            strategies: [:password, :basic],
            action: 'auth/unauthenticated'

        # Which app to direct the failure.
        #
        config.failure_app = self

    end

    Warden::Manager.before_failure do |env, opts|
        env['REQUEST_METHOD'] = 'POST'
    end

    # Authentication via password.
    # This is for when the user is using the webservice.
    #
    Warden::Strategies.add(:password) do

        # Checks to see if the paramaters contain
        # a valid username and password combination in the
        # request params.
        #
        def valid?
            params['username'] && params['password']
        end

        # Authenticates the user, first checks if the user exists in the
        # database if so then call the _user_.authenticate method.
        #
        def authenticate!
            user = User.first(username: params['username'])

            if user.nil? then
                fail!("Incorrect username or password")
            elsif user.authenticate(params['password'])
                success!(user)
            else
                fail!("Incorrect username or password")
            end
        end
    end

    # Use HTTP basic auth for the webservices.
    #
    Warden::Strategies.add(:basic) do

        def auth
            @auth ||= Rack::Auth::Basic::Request.new(env)
        end

        def valid?
            auth.provided? && auth.basic? && auth.credentials
        end

        def authenticate!
            user = User.first(username: auth.credentials.first)

            if user.nil? then
                fail!("Incorrect username or password")
            elsif user.authenticate(auth.credentials.last)
                success!(user)
            else
                fail!("Incorrect username or password")
            end
        end

        def store?
            false
        end

        # Return headers for 401, unauthorized.
        #
        def unauthorized
            [401,
             {
                'Content-Type' => 'text/plain',
                'Content-Length' => '0',
                'WWW-Authenticate' => %(Basic realm="Sarissa")
            }, [] ]
        end
    end

    require_relative 'lib/settings'
    require_relative 'lib/models'
    require_relative 'app/helpers/init'
    require_relative 'app/routes/init'

    run! if app_file == $0

end
