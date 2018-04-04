require_relative "../config/environment.rb"
require 'pry'

class Student
  attr_accessor :name, :grade, :id



  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
      SQL
      DB[:conn].execute(sql)
    end

    def self.drop_table
      DB[:conn].execute("DROP TABLE students")
    end

    def update
      sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    end

    def save
      if self.id
        self.update
      else
        sql = <<-SQL
          INSERT INTO students (name, grade)
          VALUES (?, ?)
          SQL
        DB[:conn].execute(sql, self.name, self.grade)
        self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      end
    end


  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
