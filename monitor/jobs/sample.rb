require 'mongo'

current_valuation = 0
current_karma = 0

client = Mongo::Connection.new # defaults to localhost:27017
db     = client['monitor']
coll   = db['monitor']

SCHEDULER.every '2s' do

  all_vse =  coll.find_one('name' => 'monga')
  temp = all_vse['temp']
  hum = all_vse['hum']
  if (temp >= 33) and (hum >= 60) 
    w_title = 'ERROR'
    w_text = all_vse['error_title']
  elsif (temp >= 30) or (hum >= 40)
    w_title = 'WARNING'
    w_text = all_vse['warning_title']
  else
    w_title = 'INFO'
    w_text = all_vse['info_title']
  end


  send_event('temperature',   { value: temp })
  send_event('humidity',   { value: hum })
  send_event('welcome',   { title: w_title, text: w_text })
end
