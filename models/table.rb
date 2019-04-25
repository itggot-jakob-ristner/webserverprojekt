require_relative '../database/database'

class Table
    def self.tablename(name)
        @tablename = name
    end

    def self.column(name)
        @columns ||= []
        @columns << name
        attr_reader name.to_sym
    end

    def self.create(hash)
        query = "INSERT INTO #{@tablename} 
        (#{@columns.join(",")}) 
        VALUES 
        (#{(@columns.map do |q| "?" end).join(",")})"
        p query

        Database.execute(query, hash.values)
    end

    def self.get(hash, &block)
        if block_given?
            block_hash = block.call
            if block_hash[:join] && block_hash[:through]
                query = "SELECT * FROM #{block_hash[:through]}
                INNER JOIN #{@tablename} ON 
                #{block_hash[:through]}.#{@tablename}_id = #{@tablename}.id
                WHERE #{block_hash[:through]}.#{block_hash[:join]}_id
                = #{hash.values[0]}"
                return Database.execute(query)
            elsif block_hash[:join]
                ## normal join
            else 
                ##invalid block
            end
        else
            query = "SELECT * FROM #{@tablename} 
            WHERE #{hash.keys[0]} = ?"
            Database.execute(query, hash.values)
        end

    end

    def get_inner_join(values, table1, table2, table2id)
        query = "SELECT #{values.join(",")}  FROM #{@tablename} INNER JOIN #{table1} ON #{@tablname}.#{table1}_id = #{table1}.id WHERE #{@tablename}.#{table2}_id = #{table2id}"
    end

    def self.remove(hash)
        query = "DELETE FROM #{@tablename} WHERE #{hash.keys[0]} = ?"
        Database.execute(query, hash.values[0])
    end

    def self.update(hash_id, hash_update)
        query = "UPDATE #{@tablename} SET #{hash_update.keys[0]} = 
        #{hash_update.values[0]} WHERE #{hash_id.keys[0]} = ?"
        p query 
        Database.execute(query, hash_id.values[0])
    end

    def self.latest(orderby)
        query = "SELECT * FROM #{@tablename} ORDER BY #{orderby} DESC"
        Database.execute(query)[0]

    end
end
