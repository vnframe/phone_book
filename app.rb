require "sinatra"
require "pg"
require "bcrypt"
require_relative "functions.rb"
enable "sessions"
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
    login = db.exec("Select * From login_info")
    erb :login, locals: {login: login}
end
post "/register" do
    user = params[:new_user]
    password = params[:new_password]
    secure_password = BCrypt::Password.create "#{password}"
    db.exec("INSERT INTO login_info(username, password) VALUES('#{user}', '#{secure_password}')");
redirect "/"
end
 post "/log_in" do 
    user_name = params[:username]
    user_pass = params[:user_password]

    correct = db.exec("SELECT * FROM login_info WHERE username = '#{user_name}'")
    login_data = correct.values.flatten
    if login_data.include?(user_pass)
    redirect "/index"
    else 
        redirect "/"
    end
    
 end
get "/index" do 
    info = db.exec("Select * From login_info")
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
    search_answer = params[:search_answer]
    db.exec("INSERT INTO phone_book_data(first_name, last_name, street_address, city_state_zip, phone_number, email) VALUES('#{fname}', '#{lname}', '#{street_address}', '#{place}', '#{phone_num}', '#{email}')");
    redirect '/'
end
# post "/search" do
# end
get "/search" do

    erb :search
end

# Input is not comong from the form
# Inputing data for a nonexistant user 

post "/search" do
    @params = params
    print(@params)
    #column = params[:table_column]
    #search_answer = params[:search_answer]
    #db = PG::Connection.new(db_params)
    session[:search_table] = full_search_table_render(@params)
    print(session[:search_table])
    redirect :search
 end
	

# redirect "/"
# end
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
    post "/delete" do
        deleted = params[:data_to_delete]
        column = params[:table_column]
        case column
    when 'col_first_name'
        db.exec("DELETE FROM phone_book_data WHERE first_name = '#{deleted}'")
    when 'col_last_name'
        db.exec("DELETE FROM phone_book_data WHERE last_name = '#{deleted}'");
    when 'col_address'
        db.exec("DELETE FROM phone_book_data WHERE street_address = '#{deleted}'");
    when 'col_city_state_zip'
        db.exec("DELETE FROM phone_book_data WHERE city_state_zip = '#{deleted}'");
    when 'col_phone_num'
        db.exec("DELETE FROM phone_book_data WHERE phone_number = '#{deleted}'");
    when 'col_email'
     db.exec("DELETE FROM phone_book_data WHERE email = '#{deleted}'");
     end
     redirect '/'
    end

    