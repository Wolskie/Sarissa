module Sinatra
    module Authenticator
        # The main accessor to the warden middleware
        #
        def warden
            request.env['warden']
        end

        def self.fuck
            puts "FUCK FUCK FUCK FUCK" * 20
        end

        # Return session info
        #
        # @param [Symbol] the scope to retrieve session info for
        #
        def session_info(scope=nil)
            scope ? warden.session(scope) : scope
        end

        # Check the current session is authenticated to a given scope
        #
        def authenticated?(scope=nil)
            scope ? warden.authenticated?(scope) : warden.authenticated?
        end
        alias_method :logged_in?, :authenticated?

        # Authenticate a user against defined strategies
        #
        def authenticate(*args)
            warden.authenticate!(*args)
        end
        alias_method :login, :authenticate

        # Terminate the current session
        #
        # @param [Symbol] the session scope to terminate
        #
        def logout(scopes=nil)
            scopes ? warden.logout(scopes) : warden.logout(warden.config.default_scope)
        end

        # Access the user from the current session
        #
        # @param [Symbol] the scope for the logged in user
        #
        def user(scope=nil)
            scope ? warden.user(scope) : warden.user
        end
        alias_method :current_user, :user

        # Store the logged in user in the session
        #
        # @param [Object] the user you want to store in the session
        # @option opts [Symbol] :scope The scope to assign the user
        # @example Set John as the current user
        #   user = User.find_by_name('John')
        #
        def user=(new_user, opts={})
            warden.set_user(new_user, opts)
        end
        alias_method :current_user=, :user=

        # Require authorization for an action
        #
        # @param [String] path to redirect to if user is unauthenticated
        #
        def authorize!(failure_path=nil)
            unless authenticated?
                session[:return_to] = request.path if settings.auth_use_referrer
                redirect(failure_path ? failure_path : settings.auth_failure_path)
            end
        end
    end

    helpers Authenticator
end
