require 'sqlite3'
require 'pp'
class Database
    @@db ||= SQLite3::Database.new('./database/user_data.db') 
    @@db.results_as_hash = true

    def self.execute(*args)
        @@db.execute(*args)
    end

    def self.db=(database)
        @@db = database
        @@db.results_as_hash = true
    end

    def self.clear()

        execute('DROP TABLE IF EXISTS users')
        execute('CREATE TABLE users 
	                    (id INTEGER PRIMARY KEY AUTOINCREMENT,
	                    first_name VARCHAR(255) NOT NULL,
	                    last_name VARCHAR(255) NOT NULL,
	                    email VARCHAR(255) NOT NULL UNIQUE,
	                    password VARCHAR(255) NOT NULL,
                        admin INTEGER)
	                    ')
        
        execute('DROP TABLE IF EXISTS tasks')
        execute('CREATE TABLE tasks 
	                    (id INTEGER PRIMARY KEY AUTOINCREMENT,
	                    name VARCHAR(255) NOT NULL,
                        completed INTEGER NOT NULL,
                        adding_user_id INTEGER NOT NULL, 
                        date_due VARCHAR(255) NOT NULL)')
        execute('DROP TABLE IF EXISTS tasks_rel')
        execute('CREATE TABLE tasks_rel
                        (user_id INTEGER,
                        task_id INTEGER,
                        FOREIGN KEY(user_id)
                        REFERENCES users(id),
                        FOREIGN KEY(task_id)
                        REFERENCES tasks(id))')
    end
end

