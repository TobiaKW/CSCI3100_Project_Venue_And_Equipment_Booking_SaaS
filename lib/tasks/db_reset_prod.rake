namespace :db do
  desc "Reset production database (truncate tables, load schema, seed)"
  task reset_prod: :environment do
    conn = ActiveRecord::Base.connection

    # Disable foreign key checks temporarily
    conn.execute("SET session_replication_role = 'replica';")

    # Truncate all tables except migrations
    conn.tables.each do |table|
      next if table == 'schema_migrations' || table == 'ar_internal_metadata'
      conn.execute("TRUNCATE TABLE #{table} CASCADE")
    end

    # Re-enable foreign key checks
    conn.execute("SET session_replication_role = 'origin';")

    # Seed data
    Rake::Task['db:seed'].invoke

    puts "Database reset complete!"
  end
end
