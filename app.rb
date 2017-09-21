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
post '/update' do
    
       new_data = params[:new_data]
       old_data = params[:old_data]
       column = params[:table_column]
    
       case column
       when 'col_first_name'
           db.exec("UPDATE phone_book_data SET first_name = '#{new_data}' WHERE first_name = '#{old_data}' ");
       when 'col_last_name'
           db.exec("UPDATE phone_book_data SET last_name = '#{new_data}' WHERE last_name = '#{old_data}' ");
       when 'col_address'
           db.exec("UPDATE phone_book_data SET street_address = '#{new_data}' WHERE street_address = '#{old_data}' ");
       when 'col_city_state_zip'
           db.exec("UPDATE phone_book_data SET city_state_zip = '#{new_data}' WHERE city_state_zip = '#{old_data}' ");
       when 'col_cell'
           db.exec("UPDATE phone_book_data SET phone_number = '#{new_data}' WHERE phone = '#{old_data}' ");
       when 'col_home'
        db.exec("UPDATE phone_book_data SET email = '#{new_data}' WHERE email = '#{old_data}' ");
        end
       redirect '/'
    end