RSpec.configure do |rspec|
  rspec.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context :database, :shared_context => :metadata do
  let (:freeze_date) do
    Time.zone.local(2026, 4, 10, 0, 0, 0)
  end

  let(:departments) do
    {
      :nil => Department.create!( name: 'Nil' ),
      :maths => Department.create!( name: 'Mathematics' ),
      :engine => Department.create!( name: 'Engineering' )
    }
  end

  let(:users) do
    {
      :admin => User.create!( name: 'admin', email: 'admin@example.com', password: '123456', role: 'admin', department: departments[:engine] ),
      :alice => User.create!( name: 'alice', email: 'alice@example.com', password: '123456', role: 'student', department: departments[:engine] ),
      :bob => User.create!( name: 'bob', email: 'bob@example.com', password: '123456', role: 'student', department: departments[:maths] )
    }
  end

  let(:resources) do
    {
      :computer => Resource.create!( name: 'Computer', rtype: 'equipment', department: departments[:engine] ),
      :shb123 => Resource.create!( name: 'SHB 123', rtype: 'room', department: departments[:engine] ),
      :shb924 => Resource.create!( name: 'SHB 924', rtype: 'room', department: departments[:engine] )
    }
  end

  let(:bookings) do
    {
      :alice_924 => Booking.create!({ 
        :user => users[:alice],
        :resource => resources[:shb924],
        :department => resources[:shb924].department,
        :start_time => freeze_date + 7.day + 10.hour,
        :end_time => freeze_date + 7.day + 11.hour,
        :status => 'pending'
      }),
      :bob_924 => Booking.create!({ 
        :user => users[:bob],
        :resource => resources[:shb924],
        :department => resources[:shb924].department,
        :start_time => freeze_date + 7.day + 10.hour + 30.minute,
        :end_time => freeze_date + 7.day + 11.hour + 30.minute,
        :status => 'pending'
      }),
      :bob_123 => Booking.create!({ 
        :user => users[:bob],
        :resource => resources[:shb123],
        :department => resources[:shb123].department,
        :start_time => freeze_date + 7.day + 10.hour + 30.minute,
        :end_time => freeze_date + 7.day + 11.hour + 30.minute,
        :status => 'pending'
      })
    }
  end
end

RSpec.configure do |rspec|
  rspec.include_context :database, :include_shared => true
end