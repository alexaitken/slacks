url = 'postgres://localhost/slack_development'

sql_event_store = SandthornDriverSequel.driver_from_url(url: url)
Sandthorn.configure do |c|
  c.event_store = sql_event_store
end
SandthornDriverSequel.migrate_db url: url
