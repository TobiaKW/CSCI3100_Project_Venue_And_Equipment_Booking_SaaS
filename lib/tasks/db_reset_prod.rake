namespace :db do
  desc "Reset production database (drop tables, load schema, seed)"
  task reset_prod: :environment do
    # Drop all tables
    ActiveRecord::Base.connection.tables.each do |table|
      next if table == 'schema_migrations' || table == 'ar_internal_metadata'
      ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS #{table} CASCADE")
    end

    # Load schema
    Rake::Task['db:schema:load'].invoke

    # Seed data
    Rake::Task['db:seed'].invoke
  end
end
