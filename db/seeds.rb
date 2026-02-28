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

# initialization
bin/rails g model Department name:string
bin/rails g model User email:string role:string department:references
bin/rails g model Resource name:string resource_type:string department:references
bin/rails g model Booking user:references resource:references start_time:datetime end_time:datetime status:string department:references
bin/rails db:migrate


Department_list = [
    'Enginnering', 'Science', 'Physical Education Unit'
]

Department_list.each do |deaprtment_attr|#pends checking
    Department.find_or_create_by(name: department_attr) do |department_attr|
    end
end

## create admin
User.find_or_create_by(email: 'admin@booking.cuhk.edu.hk') do |user|
    user.name = 'Admin User'
    user.password = '123456'
end
## create user "Kevin"
User.find_or_create_by(email: 'kevin@link.cuhk.edu.hk') do |user|
    user.name = 'Kevin'
    user.password = '654321'
end


#resources for test
Resource_list = [
    {name: 'SHB122', type: 'room', dept: 'Engineering'},
    {name: 'ERB803', type: 'room', dept: 'Engineering'},
    {name: 'T. Y. Wong Hall', type: 'room', dept: 'Engineering'},
    {name: 'FPGA board', type: 'equipment', dept: 'Engineering'}
    {name: 'Science Centre LT1', type: 'Room', dept: 'Science'}
    {name: 'Science Centre LT2', type: 'Room', dept: 'Science'}
    {name: 'Badminton Bat', type: 'equipment', dept: 'Physical Education Unit'},
    {name: 'Basketball', type: 'equipment', dept: 'Physical Education Unit'},
    {name: 'University Gym New Arc', type: 'room', dept: 'Physical Education Unit'},
]

Resource_list.each do |resource_attr|
    Resource.find_or_create_by(name: resource_attr[:name]) do |resource|
        resource.type = resource_attr[:type]
        resource.department = resource_attr[:dept]
    end
end

Booking_list = [
    {user: 'Kevin', resource: 'SHB122', start_time: '2026/3/1 14:00', start_time: '2026/3/1 16:00', dept = 'Engineering'}
]

Booking_list.each do |booking_list_attr|
    Booking.find_or_create_by(user: booking_attr[:user]) do |booking|
        booking.resource = resource_attr[:resource]
        booking.start_time = resource_attr[:start_time]
        booking.end_time = resource_attr[:end_time]
        booking.department = resource_attr[:dept]
    end
end

puts "Created #{Department.count} departments, #{Resource.count} room/equipment, #{User.count} users and #{Booking.count} bookings"
