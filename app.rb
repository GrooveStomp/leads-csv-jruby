require 'sinatra'
require 'jdbc/mysql'
require 'java'

Java::com.mysql.jdbc.Driver

class Database
  def initialize(db, host, username, password)
    url = "jdbc:mysql://#{host}/#{db}"
    @connection = java.sql.DriverManager.get_connection(url, username, password)
  end

  def query(string)
    statement = @connection.create_statement
    db_statement.execute_query(string)
  end
end

def leads_from_database(page_id)
  db = Database.new('lp_webapp', 'localhost', 'root', 'password')
  result_set = db.query("SELECT * from form_submissions where page_uuid = #{page_id}")

  while result_set.next do
    obj = Hash.new
    obj['db_column'] = result_set.getObject('db_column')
  end

end


get '/page/:page_id' do
  "Hi there fella.<br/>You specified page: #{params[:page_id]}."
end
