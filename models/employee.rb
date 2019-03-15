class Employee

	attr_reader :id, :image, :name, :email, :tel, :department

	def initialize(db_array)
		@id 		= db_array[0]
		@image 		= db_array[1]
		@name 		= db_array[2]
		@email 		= db_array[3]
		@tel	    = db_array[4]
		@department = db_array[-1]
	end

	def self.get(id)
		db = SQLite3::Database.new 'contacts.db'
		result = db.execute('SELECT * 
			                 FROM users 
			        		 JOIN departments
			        		 ON users.department_id = departments.id
			        		 WHERE users.id = ?', id).first
		Employee.new(result)
	end

	def self.all
		db = SQLite3::Database.new 'contacts.db'
		result = db.execute('SELECT * FROM users JOIN departments ON users.department_id = departments.id')
		result.map { |row| Employee.new(row) }
	end


end













