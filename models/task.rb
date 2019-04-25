require_relative '../database/database.rb'
require_relative 'tasking'



class Task < Table
    tablename 'tasks'
    column :name
    column :completed
    column :adding_user_id
    column :date_due
    column :id
    def initialize(db_hash) 
        db_hash = db_hash
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
        task_hashes = get({users_id: user_id}) { {join: "users", through: "tasking"} }
        task_hashes.each do |task|
            task_objs << new(task)
        end
        return task_objs
    end

    def self.delete(id)
        remove id: id
        Tasking.remove tasks_id: id
    end

    def self.complete(id) 
        update({id: id}, {completed: 1})
    end

    def self.invite(params)
        begin
            user = User.new(User.get email: params['email'])
            Tasking.create({users_id: user.id, tasks_id: params['id']})
        end
    end

    def self.add(hash)
        p latest(:id)
        task_hash = {name: hash['name'], completed: 0, 
        adding_user_id: hash['user_id'], date_due: hash['date_due']}
        Task.create(task_hash)
        tasking_hash = {users_id: hash['user_id'], tasks_id: latest(:id)['id']}
        Tasking.create(tasking_hash)
        
    end
end
