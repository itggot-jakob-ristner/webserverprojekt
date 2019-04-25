require_relative '../database/database.rb'
require_relative 'table'
require_relative 'task'

class User < Table
    tablename 'users'
    column :first_name
    column :last_name
    column :email
    column :password
    column :id
    column :admin

    def initialize(db_hash)
        db_hash = db_hash.first
        @first_name = db_hash['first_name']
        @last_name  = db_hash['last_name']
        @password   = db_hash['password']
        @email      = db_hash['email']
        @id         = db_hash['id'] 
        @admin = false
        if db_hash['admin'].to_i == 1
            @admin = true
        end

    end

    def self.register(params)
        begin
            output = []
            if params['password'].length < 3
                output << :password_length
            end
            params['password'] = BCrypt::Password.create(params['password'])
            p params
            create params
            user = new(get email: params['email'])
            unless output.length == 0
                return output
            else
                return user
            end
        rescue SQLite3::ConstraintException
            output << :email_exists
            return output
        end
    end

    def self.login(params)
        begin
            user_hash = get email: params['email']
            error = ['incorrect email or password']
            user = new user_hash
            hashed_password= BCrypt::Password.new(user.password)
            if hashed_password == params['password']
                return user.id
            else
                return error
            end
        rescue
            return error
        end
            
    end

    def get_tasks()

        return Task.get_all_by_id(@id)    
    end

end











