require_relative '../database/database.rb'



class Task
    attr_reader :id, :name, :completed, :adding_user_id, :date_due
    def initialize(db_hash) 
        @id             = db_hash['id']
        @name           = db_hash['name']
        @date_due       = db_hash['date_due']
        @adding_user_id = db_hash['adding_user_id']
        @completed = true
        if db_hash['completed'].to_i == 0
            @completed = false
        end
    end

    def self.get_all_by_id(user_id)
        tasks = Database.execute('SELECT task_id FROM tasks_rel i
                                   WHERE user_id = ?', user_id)
        task_objs = []
        tasks.each do |task|
            hash = Database.execute('SELECT * FROM tasks WHERE id = ?', task['task_id']).first

            task_objs << Task.new(hash)
        end
        return task_objs
    end

    def self.remove(id)
        Database.execute('DELETE FROM tasks WHERE id = ?', id)
        Database.execute('DELETE FROM tasks_rel WHERE task_id = ?', id)
    end

    def self.complete(id) 
        Database.execute('UPDATE tasks SET completed = 1 WHERE id = ?', id)
    end

    def self.invite(params)
        begin
            user_id = Database.execute('SELECT id FROM users WHERE email = ?', params['email']).first.values[0]
            Database.execute('INSERT INTO tasks_rel (user_id, task_id) VALUES(?, ?)', [user_id, params['id']])
        end
    end
end
