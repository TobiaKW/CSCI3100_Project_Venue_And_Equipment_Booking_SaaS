# data model
#
#   Department:{Art, Science etc} string
#
#   user: user.name, user.email, user.password
#
#   resource: resource.dept=Art;
#             resource.name;
#             resource.type:{room, equipment}
#
#   booking: booking.user=person who booked
#            booking.resource=booked resource
#            booking.start_time, booking.end_time    date+time
# can add more attr such as room capacity etc for more info

# Run migrations first (in terminal): bin/rails db:migrate

Department_list = [
    'Engineering', 'Science', 'Physical Education Unit', 'Medicine'
]

Department_list.each do |dept_name|
  Department.find_or_create_by!(name: dept_name)
end

# Create admin (add has_secure_password + bcrypt when you add auth)
User.find_or_create_by!(email: 'kevinwong391@gmail.com') do |user|
  user.name = 'Admin User'
  user.password = 'dev1234'
  user.role = 'admin'
  user.department = Department.find_by!(name: 'Engineering')
end
# Create user "Kevin"
User.find_or_create_by!(email: 'kerubintobia@gmail.com') do |user|
  user.name = 'Kevin'
  user.password = 'dev12345'
  user.role = 'student'
  user.department = Department.find_by!(name: 'Engineering')
end
# Create user "Eason23"
User.find_or_create_by!(email: 'easonng23@gmail.com') do |user|
  user.name = 'Eason23'
  user.password = 'dev54321'
  user.role = 'student'
  user.department = Department.find_by!(name: 'Medicine')
end

# resources for test
Resource_list = [
    { name: 'SHB122', rtype: 'room', dept: 'Engineering' },
    { name: 'ERB803', rtype: 'room', dept: 'Engineering' },
    { name: 'T. Y. Wong Hall', rtype: 'room', dept: 'Engineering' },
    { name: 'FPGA board', rtype: 'equipment', dept: 'Engineering' },
    { name: 'Science Centre LT1', rtype: 'room', dept: 'Science' },
    { name: 'Science Centre LT2', rtype: 'room', dept: 'Science' },
    { name: 'Badminton Bat', rtype: 'equipment', dept: 'Physical Education Unit' },
    { name: 'Basketball', rtype: 'equipment', dept: 'Physical Education Unit' },
    { name: 'University Gym New Arc', rtype: 'room', dept: 'Physical Education Unit' },
    { name: 'BMSB LT1', rtype: 'room', dept: 'Medicine' },
    { name: 'BMSB LT2', rtype: 'room', dept: 'Medicine' }
]

Resource_list.each do |attr|
    dept = Department.find_by!(name: attr[:dept])
    Resource.find_or_create_by!(name: attr[:name], department: dept) do |resource|
      resource.rtype = attr[:rtype]
    end
end

Booking_list = [
    {
      user: 'Kevin',
      resource: 'SHB122',
      start_time: '2026-05-01 14:00',
      end_time:   '2026-05-01 16:00',
      dept:       'Engineering'
    },
    {
      user: 'Eason23',
      resource: 'BMSB LT1',
      start_time: '2026-04-15 10:00',
      end_time:   '2026-04-15 12:00',
      dept:       'Medicine'
    }
]

Booking_list.each do |attr|
    user = User.find_by!(name: attr[:user])
    dept = Department.find_by!(name: attr[:dept])
    resource = Resource.find_by!(name: attr[:resource], department: dept)
    start_at = Time.zone.parse(attr[:start_time])
    end_at = Time.zone.parse(attr[:end_time])

    next if Booking.exists?(user: user, resource: resource, start_time: start_at)

    Booking.find_or_create_by!(user: user, resource: resource, start_time: start_at) do |b|
        b.end_time = end_at
        b.status = 'approved'
        b.department = dept
    end
end

puts "Created #{Department.count} departments, #{Resource.count} room/equipment, #{User.count} users and #{Booking.count} bookings"
