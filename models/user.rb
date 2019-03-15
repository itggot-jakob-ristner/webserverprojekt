require_relative '../database/database.rb'
require_relative 'task'

class User
    attr_reader :first_name, :last_name, :email, :password, :id, :admin
    def initialize(db_hash)
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

    def self.get(identifier, value)
        User.new(Database.execute("SELECT * FROM users WHERE #{identifier} = ?", [value]).first)
    end

    def self.create(params)
        begin
            password = params['password']
            params['password'] = BCrypt::Password.create(password) 
            Database.execute('INSERT INTO users (first_name, last_name, email, password) VALUES (?, ?, ?, ?)', params.values)
            return get('email', params['email'])
        rescue
            
        end
    end

    def self.login(params)
        user = Database.execute('SELECT id, password 
                                FROM users WHERE email = ?', 
                                params['email']).first
        hashed_password = BCrypt::Password.new(user['password'])
        if hashed_password == params['password']
            return user['id']
        end
        return nil
    end

    def get_tasks()
        return Task.get_all_by_id(@id)    
    end

    def add_task(params)
        Database.execute('INSERT INTO tasks 
        (name, date_due, adding_user_id, completed)
                         VALUES (?, ?, ?, ?)', 
                         [params['name'], params['date_due'], @id, 0])
        task_id = Database.execute('SELECT id FROM tasks 
                                   ORDER BY id DESC')[0].values[0]
        Database.execute('INSERT INTO tasks_rel (user_id, task_id) 
                         VALUES (?, ?)', [@id, task_id])
    end
end











