class Dog
  attr_accessor :name, :breed, :id
  def initialize(attributes)
    attributes.each{|k,v| self.send(("#{k}="),v)}
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs(
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE dogs
    SQL
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else

      sql = <<-SQL
      INSERT INTO dogs(name, breed)
      VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      self
    end
  end

  def self.create(attrs)
    obj = self.new(attrs)
    obj.save
  end


end
