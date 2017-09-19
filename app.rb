require "sinatra"
require "pg"
load './local_env.rb' if File.exists?('./local_env.rb')
db_params = {
    host: ENV['host'],
    port: ENV['port'],
    dbname: ENV['db_name'],
    user: ENV['user'],
    password: ENV['password']
}

db = PG::Connection.new(db_params)
get "/" do 
    info = db.exec("Select * From phone_book_data")
    #info_array = info.values
    erb :index, locals: {info: info}
end
post "/index" do 
    phone_num = params[:phone_number]
    fname = params[:first_name]
    lname = params[:last_name]
    street_address = params[:street]
    place = params[:city_state_zip]
    email = params[:user_email]
    db.exec("INSERT INTO phone_book_data(first_name, last_name, street_address, city_state_zip, phone_number, email) VALUES('#{fname}', '#{lname}', '#{street_address}', '#{place}', '#{phone_num}', '#{email}')");
end