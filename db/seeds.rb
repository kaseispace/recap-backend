require 'httparty'

url = ENV['SCHOOL_CODE_API_URL']
header = { Authorization: "Bearer #{ENV['SCHOOL_CODE_API_KEY']}", Accept: "application/json" }
response = HTTParty.get(url, headers: header)
data = JSON.parse(response.body)
school_data = data['schools']['data']

school_data.each do |item|
    model_params = {
        name: item['school_name'],
      }
    School.create!(model_params)
end