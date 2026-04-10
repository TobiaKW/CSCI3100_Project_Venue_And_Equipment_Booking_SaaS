namespace :db do
  desc "Reset production database (clear all data, then seed)"
  task reset_prod: :environment do
    # Delete all records in the correct order (respecting foreign keys)
    puts "Clearing all data..."

    Booking.delete_all
    Resource.delete_all
    User.delete_all
    Department.delete_all

    puts "Data cleared. Running seeds..."

    # Seed data
    Rake::Task["db:seed"].invoke

    puts "Database reset complete!"
  end
end
