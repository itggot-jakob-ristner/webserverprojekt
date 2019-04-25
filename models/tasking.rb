require_relative '../database/database'
require_relative 'table'

class Tasking < Table
    tablename 'tasking'

    column :users_id
    column :tasks_id 
end
