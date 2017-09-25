load './local_env.rb' if File.exists?('./local_env.rb')
require "pg"

db_params = {
    host: ENV['host'],
    port: ENV['port'],
    dbname: ENV['db_name'],
    user: ENV['user'],
    password: ENV['password']
}
$db = PG::Connection.new(db_params)

def prep_query(info_hash)
	# INPUTS FROM SEARCH FORM
	first_name = info_hash[:first_name] # FIRST NAME
	phone = info_hash[:phone]           # PHONE NUMBER

  # If they enter a first name and lastname- SEARCH WITH BOTH
	if first_name != '' && phone != ''
        print("SELECT * FROM phone_book_data WHERE first_name='#{first_name}' AND phone_number='#{phone}'")
        "SELECT * FROM phone_book_data WHERE first_name='#{first_name}' AND phone_number='#{phone}'"
	# OR ELSE IF IT WAS JUST THE FIRST NAME- SEARCH WITH JUST THE FIRST NAME
    elsif first_name != ''
        print("SELECT * FROM phone_book_data WHERE first_name='#{first_name}'")
		"SELECT * FROM phone_book_data WHERE first_name='#{first_name}'"
  # OR ELSE IF it WAS JUST THE SEARCH WITH JUST THE PHONE NUMBER, SEARCH WITH JUST THE PHONE NUMBER
	elsif phone != ''
        print("SELECT * FROM phone_book_data WHERE phone_number='#{phone}'")
        "SELECT * FROM phone_book_data WHERE phone_number='#{phone}'"
	# IF NOT BOTH NOR EITHER ONE PROMT THE USER OF THIS
    else
        print("SELECT * FROM phone_book_data")
		"SELECT * FROM phone_book_data"
	end
end

def response_obj(query)
	$db.exec(query)
end

def prep_html(response_obj)
	html = ''
	html << "<table>
	<tr>
	    <td>First Name</td>
	    <td>Last Name</td>
	    <td>Street Address</td>
	    <td>City/State/Zip</td>
		<td>Phone Number</td>
		<td>Email Address</td>
	  </tr>"

	# GENERATE ROW
  response_obj.each do |row|
		html << "\t<tr>"
		row.each {|cell| html << "\t\t<td>#{cell[1]}</td>\n"}
		html << "\t</tr>"
	end
	# END TABLE
	html << "</table>"
	# RETURN FINAL STRING
	html
end

# TIE THEM ALL TOGETHER
def full_search_table_render(form_input_hash)
	prep_html(response_obj(prep_query(form_input_hash)))
end

print prep_html(response_obj(prep_query({"first_name"=>"Victoria", "phone"=>""})))
#print full_search_table_render({"first_name"=>"Victoria", "phone"=>""})

#print response_obj(prep_html({"first_name"=>"Victoria", "phone"=>""}))

#print prep_html(response_obj("SELECT * FROM phone_book_data"))

#print prep_html(response_obj(prep_query({"first_name"=>"Victoria", "phone"=>""})))