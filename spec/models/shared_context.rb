RSpec.configure do |rspec|
  rspec.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context "database", :shared_context => :metadata do
  let(:departments) do
    {
      :nil => Department.create!( name: 'Nil' ),
      :maths => Department.create!( name: 'Mathematics' ),
      :cs => Department.create!( name: 'Computer Science' )
    }
  end

  let(:users) do
    {
      :admin => User.create!( name: 'admin', email: 'admin@example.com', password: '123456', role: 'admin', department: departments[:nil] ),
      :alice => User.create!( name: 'alice', email: 'alice@example.com', password: '123456', role: 'student', department: departments[:cs] ),
      :bob => User.create!( name: 'bob', email: 'bob@example.com', password: '123456', role: 'student', department: departments[:maths] )
    }
  end

  let(:resources) do
    {
      :computer => Resource.create!( name: 'Computer', rtype: 'equipment', department: departments[:cs] ),
      :shb123 => Resource.create!( name: 'SHB 123', rtype: 'room', department: departments[:cs] ),
      :shb924 => Resource.create!( name: 'SHB 924', rtype: 'room', department: departments[:cs] )
    }
  end
end

RSpec.configure do |rspec|
  rspec.include_context "database", :include_shared => true
end