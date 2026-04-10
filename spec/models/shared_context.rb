RSpec.configure do |rspec|
  rspec.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context "database", :shared_context => :metadata do
  let(:users) do
    {
      :admin => User.new( name: 'admin', role: 'admin' ),
      :alice => User.new( name: 'alice', role: 'student' ),
      :bob => User.new( name: 'bob', role: 'student' )
    }
  end

  let (:departments) do
    {
      :maths => Department.new( name: 'Mathematics' ),
      :cs => Department.new( name: 'Computer Science' )
    }
  end

  let (:resources) do
    {
      :room => Resource.new( department: departments[:maths] )
    }
  end
end

RSpec.configure do |rspec|
  rspec.include_context "database", :include_shared => true
end