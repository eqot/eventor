namespace :schema do
  env    = ENV['RAILS_ENV'] || 'development'
  config = Rails.root.join('config', 'database.yml')
  schema = Rails.root.join('db', 'schema', 'Schemafile')

  desc 'Show current schema on DB'
  task(:show) do
    puts `bundle exec ridgepole -E #{env} -c #{config} --export`
  end

  desc 'Show diff between current schema on DB and Schemafile'
  task(:diff) do
    puts `bundle exec ridgepole -E #{env} --diff #{config} #{schema}`
  end
end
