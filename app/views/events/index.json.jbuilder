json.array! @events do |event|
  json.id event.id
  json.title event.title
  json.start event.start_time
  json.end event.end_time
  json.url '/events/' + event.id.to_s
  json.className event.include?(current_user) ? 'event-attend' : ''
end
