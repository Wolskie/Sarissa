class Sarissa

    helpers Sinatra::Authenticator

    before do
        headers 'X-Powered-By'    => 'Sarissa'
        headers 'X-UA-Compatible' => 'IE=edge,chrome=1';
        headers 'Cache-Control'   => 'private, max-age=0, no-cache, no-store, must-revalidate'
        headers 'Pragma'          => 'no-cache'
        headers 'Expires'         => '0'
    end

    post '/auth/unauthenticated' do
        "Access Denied"
    end

    before '/api/*' do
        login(:basic, :password)
        "test"
    end

    # Loads our erb template
    # in views
    #
    get '/' do
        erb :index
    end

    get '/auth/login' do

    end
end
