# Loads our erb template
# in views
#
get '/' do 
    erb :index
end

# /json provides us with json
#
get '/json', :provides => 'application/json' do
    format_response({
        :hello_world => 'Greetings'
    })
end
