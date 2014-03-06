require 'sinatra'
require 'jdbc/mysql'
require 'java'
require 'json'
require 'csv'

Java::com.mysql.jdbc.Driver

class Database
  def initialize(db, host, username, password)
    url = "jdbc:mysql://#{host}/#{db}"
    @connection = java.sql.DriverManager.get_connection(url, username, password)
  end

  def query(string)
    statement = @connection.create_statement
    statement.execute_query(string)
  end
end

def leads_from_database(page_id)
  db = Database.new('lp_webapp', 'localhost', 'root', 'password')
  result_set = db.query("SELECT * from form_submissions where page_uuid = '#{page_id}'")

  leads = []

  while result_set.next do
    lead = {}
    lead[:variant] = result_set.getObject('variant_id')
    lead[:ip_address] = result_set.getObject('submitter_ip')
    lead[:page_uuid] = result_set.getObject('page_uuid')
    lead[:date_submitted] = '' # result_set.getObject('date_submitted')
    lead[:time_submitted] = '' # result_set.getObject('time_submitted')

    form_data = JSON.parse(result_set.getObject('form_data'))
    form_data.each { |k,v| lead[k.to_sym] = v }

    leads.push(lead)
  end

  leads
end

def leads_headers(leads)
  header_mess = leads.collect { |lead| lead.keys }.flatten.uniq
  [:page_uuid, :date_submitted, :time_submitted, :variant, :ip_address].concat(header_mess).uniq
end

def lead_data_in_order(headers, lead)
  lead.values_at(*headers)
end

def leads_as_csv_arrays(leads)
  headers = leads_headers(leads)
  leads_with_data_ordered = leads.collect { |lead| lead_data_in_order(headers, lead) }

  [headers, *leads_with_data_ordered]
end

def page_leads_as_csv(page_id)
  leads = leads_from_database(page_id)
  csv_data = leads_as_csv_arrays(leads)
  CSV.generate do |csv|
    csv_data.each { |row| csv << row }
  end
end

get '/page/:page_id' do
  content_type 'text/csv'
  page_leads_as_csv(params[:page_id])
end
