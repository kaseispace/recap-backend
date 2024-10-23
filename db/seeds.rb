require 'httparty'

url = ENV['SCHOOL_CODE_API_URL']
header = { Authorization: "Bearer #{ENV['SCHOOL_CODE_API_KEY']}", Accept: "application/json" }
response = HTTParty.get(url, headers: header)
data = JSON.parse(response.body)
school_data = data['schools']['data']
last_page = data['schools']['last_page']

school_data.each do |school|
  next if school['school_status'] == '廃校'

  model_params = {
    name: school['school_name'],
  }
  School.create!(model_params)
end

(2..last_page).each do |page|
  response = HTTParty.get("#{url}&page=#{page}", headers: header)
  data = JSON.parse(response.body)
  school_data = data['schools']['data']

  school_data.each do |school|
    next if school['school_status'] == '廃校'
    
    model_params = {
      name: school['school_name'],
    }
    School.create!(model_params)
  end
end