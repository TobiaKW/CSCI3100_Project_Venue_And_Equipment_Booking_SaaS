namespace :coverage do
  task :merge do
    require "simplecov"
    SimpleCov.collate Dir["coverage/*/.resultset.json"], "rails" do
      add_filter "test"
      coverage_dir "coverage/merged"
    end
  end
end
