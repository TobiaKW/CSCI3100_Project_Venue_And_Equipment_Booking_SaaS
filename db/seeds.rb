# data model
#
#   Department:{Art, Science etc} string
#
#   user: user.name, user.email, user.password
#
#   resource: resource.dept=Art;
#             resource.name;
#             resource.type:{room, equipment}
#             resource.capacity (integer, -1 for equipment)
#             resource.seat_type (string, 'N/A' for equipment)
#
#   booking: booking.user=person who booked
#            booking.resource=booked resource
#            booking.start_time, booking.end_time    date+time

# Run migrations first (in terminal): bin/rails db:migrate

Department_list = [
    'Engineering', 'Science', 'Physical Education Unit', 'Medicine',
    'Arts', 'Business Administration', 'Education', 'Law', 'Social Science',
    'New Asia College', 'United College', 'Shaw College', 'Chung Chi College',
    'Business', 'English', 'U-Wide'
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

# Create admin users for all other departments
admin_departments = Department_list.reject { |d| d == 'Engineering' }
admin_departments.each do |dept_name|
  dept_slug = dept_name.downcase.gsub(/[^a-z0-9]+/, '')
  User.find_or_create_by!(email: "admin#{dept_slug}@temp.edu") do |user|
    user.name = "#{dept_name} Admin"
    user.password = 'dev1234'
    user.role = 'admin'
    user.department = Department.find_by!(name: dept_name)
  end
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

# NOTE: Resource list is very large (238 classrooms + equipment)
# Placeholder - will be replaced with actual data
# Resources from CSV + old test data + equipment
Resource_list = [
    { name: 'NAH 11', rtype: 'room', capacity: 80, seat_type: 'Table & Chair', dept: 'New Asia College' },
    { name: 'NAH 12', rtype: 'room', capacity: 96, seat_type: 'Lecture Theatre', dept: 'New Asia College' },
    { name: 'NAH 114', rtype: 'room', capacity: 80, seat_type: 'Table & Chair', dept: 'New Asia College' },
    { name: 'NAH 115', rtype: 'room', capacity: 166, seat_type: 'Lecture Theatre', dept: 'New Asia College' },
    { name: 'NAH 213', rtype: 'room', capacity: 90, seat_type: 'Lecture Theatre', dept: 'New Asia College' },
    { name: 'SWC LT', rtype: 'room', capacity: 495, seat_type: 'Lecture Theatre', dept: 'Shaw College' },
    { name: 'UCA 102', rtype: 'room', capacity: 30, seat_type: 'Table & Chair', dept: 'United College' },
    { name: 'UCA 103', rtype: 'room', capacity: 45, seat_type: 'Table & Chair', dept: 'United College' },
    { name: 'UCA 104', rtype: 'room', capacity: 60, seat_type: 'Table & Chair', dept: 'United College' },
    { name: 'UCA 105', rtype: 'room', capacity: 30, seat_type: 'Table & Chair', dept: 'United College' },
    { name: 'UCA 111', rtype: 'room', capacity: 35, seat_type: 'Table & Chair', dept: 'United College' },
    { name: 'UCA 312', rtype: 'room', capacity: 59, seat_type: 'Chamber-type', dept: 'United College' },
    { name: 'UCC C1', rtype: 'room', capacity: 200, seat_type: 'Lecture Theatre', dept: 'United College' },
    { name: 'UCC C2', rtype: 'room', capacity: 89, seat_type: 'Lecture Theatre', dept: 'United College' },
    { name: 'UCC C3', rtype: 'room', capacity: 78, seat_type: 'Lecture Theatre', dept: 'United College' },
    { name: 'UCC C4', rtype: 'room', capacity: 75, seat_type: 'Table & Chair', dept: 'United College' },
    { name: 'UCC C5', rtype: 'room', capacity: 75, seat_type: 'Table & Chair', dept: 'United College' },
    { name: 'UCC 102', rtype: 'room', capacity: 20, seat_type: 'Armchair', dept: 'United College' },
    { name: 'UCC 103', rtype: 'room', capacity: 20, seat_type: 'Armchair', dept: 'United College' },
    { name: 'UCC 104', rtype: 'room', capacity: 20, seat_type: 'Armchair', dept: 'United College' },
    { name: 'UCC 105', rtype: 'room', capacity: 20, seat_type: 'Armchair', dept: 'United College' },
    { name: 'UCC 108', rtype: 'room', capacity: 25, seat_type: 'Table & Chair', dept: 'United College' },
    { name: 'UCC 109', rtype: 'room', capacity: 24, seat_type: 'Table & Chair', dept: 'United College' },
    { name: 'UCC 110', rtype: 'room', capacity: 45, seat_type: 'Table & Chair', dept: 'United College' },
    { name: 'UCC 111', rtype: 'room', capacity: 50, seat_type: 'Armchair', dept: 'United College' },
    { name: 'UCC 114', rtype: 'room', capacity: 45, seat_type: 'Table & Chair', dept: 'United College' },
    { name: 'UCC 201', rtype: 'room', capacity: 50, seat_type: 'Table & Chair', dept: 'United College' },
    { name: 'UCC 204', rtype: 'room', capacity: 20, seat_type: 'Armchair', dept: 'United College' },
    { name: 'UCC 205', rtype: 'room', capacity: 20, seat_type: 'Armchair', dept: 'United College' },
    { name: 'UCC 206', rtype: 'room', capacity: 30, seat_type: 'Table & Chair', dept: 'United College' },
    { name: 'UCC 207', rtype: 'room', capacity: 30, seat_type: 'Table & Chair', dept: 'United College' },
    { name: 'UCC 208', rtype: 'room', capacity: 30, seat_type: 'Table & Chair', dept: 'United College' },
    { name: 'WLS LG204', rtype: 'room', capacity: 80, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'BMS LT', rtype: 'room', capacity: 76, seat_type: 'Lecture Theatre', dept: 'Medicine' },
    { name: 'BMS 1', rtype: 'room', capacity: 45, seat_type: 'Armchair', dept: 'Medicine' },
    { name: 'BMS 2', rtype: 'room', capacity: 45, seat_type: 'Armchair', dept: 'Medicine' },
    { name: 'BMS G18', rtype: 'room', capacity: 166, seat_type: 'Lecture Theatre', dept: 'Medicine' },
    { name: 'SWH 1', rtype: 'room', capacity: 117, seat_type: 'Lecture Theatre', dept: 'Engineering' },
    { name: 'SWH 2', rtype: 'room', capacity: 117, seat_type: 'Lecture Theatre', dept: 'Engineering' },
    { name: 'ICS L1', rtype: 'room', capacity: 108, seat_type: 'Lecture Theatre', dept: 'Engineering' },
    { name: 'LSB C1', rtype: 'room', capacity: 80, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'LSB C2', rtype: 'room', capacity: 80, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'LSB C3', rtype: 'room', capacity: 80, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'LSB C4', rtype: 'room', capacity: 80, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'LSB LT1', rtype: 'room', capacity: 274, seat_type: 'Lecture Theatre', dept: 'Engineering' },
    { name: 'LSB LT2', rtype: 'room', capacity: 104, seat_type: 'Lecture Theatre', dept: 'Engineering' },
    { name: 'LSB LT3', rtype: 'room', capacity: 81, seat_type: 'Lecture Theatre', dept: 'Engineering' },
    { name: 'LSB LT4', rtype: 'room', capacity: 68, seat_type: 'Lecture Theatre', dept: 'Engineering' },
    { name: 'LSB LT6', rtype: 'room', capacity: 166, seat_type: 'Lecture Theatre', dept: 'Engineering' },
    { name: 'LPN LT', rtype: 'room', capacity: 70, seat_type: 'Lecture Theatre', dept: 'Engineering' },
    { name: 'LSK 201', rtype: 'room', capacity: 57, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'LSK 202', rtype: 'room', capacity: 30, seat_type: 'Armchair', dept: 'U-Wide' },
    { name: 'LSK 203', rtype: 'room', capacity: 20, seat_type: 'Armchair', dept: 'U-Wide' },
    { name: 'LSK 204', rtype: 'room', capacity: 30, seat_type: 'Armchair', dept: 'U-Wide' },
    { name: 'LSK 206', rtype: 'room', capacity: 50, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'LSK 208', rtype: 'room', capacity: 65, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'LSK 210', rtype: 'room', capacity: 65, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'LSK 212', rtype: 'room', capacity: 48, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'LSK 301', rtype: 'room', capacity: 55, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'LSK 302', rtype: 'room', capacity: 60, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'LSK 303', rtype: 'room', capacity: 12, seat_type: 'Armchair', dept: 'U-Wide' },
    { name: 'LSK 304', rtype: 'room', capacity: 65, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'LSK 306', rtype: 'room', capacity: 65, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'LSK 308', rtype: 'room', capacity: 65, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'LSK 401', rtype: 'room', capacity: 30, seat_type: 'Table & Chair', dept: 'English' },
    { name: 'LSK 404', rtype: 'room', capacity: 30, seat_type: 'Table & Chair', dept: 'English' },
    { name: 'LSK 408', rtype: 'room', capacity: 30, seat_type: 'Table & Chair', dept: 'English' },
    { name: 'LSK 410', rtype: 'room', capacity: 30, seat_type: 'Table & Chair', dept: 'English' },
    { name: 'LSK 416', rtype: 'room', capacity: 30, seat_type: 'Table & Chair', dept: 'English' },
    { name: 'LSK 514', rtype: 'room', capacity: 64, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'LSK 515', rtype: 'room', capacity: 64, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'LSK LT1', rtype: 'room', capacity: 150, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'LSK LT2', rtype: 'room', capacity: 150, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'LSK LT3', rtype: 'room', capacity: 150, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'LSK LT4', rtype: 'room', capacity: 150, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'LSK LT5', rtype: 'room', capacity: 350, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'LSK LT7', rtype: 'room', capacity: 260, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'KKB 101', rtype: 'room', capacity: 86, seat_type: 'Lecture Theatre', dept: 'Arts' },
    { name: 'LDS 214', rtype: 'room', capacity: 50, seat_type: 'Table & Chair', dept: 'Arts' },
    { name: 'LDS 218', rtype: 'room', capacity: 25, seat_type: 'Armchair', dept: 'Arts' },
    { name: 'MMW 702', rtype: 'room', capacity: 70, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'MMW 703', rtype: 'room', capacity: 90, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'MMW 704', rtype: 'room', capacity: 40, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'MMW 705', rtype: 'room', capacity: 55, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'MMW 706', rtype: 'room', capacity: 40, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'MMW 707', rtype: 'room', capacity: 60, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'MMW 710', rtype: 'room', capacity: 80, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'MMW 715', rtype: 'room', capacity: 45, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'MMW LT1', rtype: 'room', capacity: 224, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'MMW LT2', rtype: 'room', capacity: 143, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'SC 139', rtype: 'room', capacity: 25, seat_type: 'Table & Chair', dept: 'Science' },
    { name: 'SC L1', rtype: 'room', capacity: 214, seat_type: 'Lecture Theatre', dept: 'Science' },
    { name: 'SC L2', rtype: 'room', capacity: 117, seat_type: 'Lecture Theatre', dept: 'Science' },
    { name: 'SC L3', rtype: 'room', capacity: 86, seat_type: 'Lecture Theatre', dept: 'Science' },
    { name: 'SC L4', rtype: 'room', capacity: 117, seat_type: 'Lecture Theatre', dept: 'Science' },
    { name: 'SC L5', rtype: 'room', capacity: 86, seat_type: 'Lecture Theatre', dept: 'Science' },
    { name: 'SC LG23', rtype: 'room', capacity: 73, seat_type: 'Lecture Theatre', dept: 'Science' },
    { name: 'TYW LT', rtype: 'room', capacity: 272, seat_type: 'Lecture Theatre', dept: 'Engineering' },
    { name: 'ERB 401', rtype: 'room', capacity: 50, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'ERB 402', rtype: 'room', capacity: 30, seat_type: 'Armchair', dept: 'Engineering' },
    { name: 'ERB 404', rtype: 'room', capacity: 65, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'ERB 405', rtype: 'room', capacity: 45, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'ERB 406', rtype: 'room', capacity: 20, seat_type: 'Armchair', dept: 'Engineering' },
    { name: 'ERB 407', rtype: 'room', capacity: 100, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'ERB 408', rtype: 'room', capacity: 40, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'ERB 703', rtype: 'room', capacity: 55, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'ERB 706', rtype: 'room', capacity: 45, seat_type: 'Armchair', dept: 'Engineering' },
    { name: 'ERB 712', rtype: 'room', capacity: 55, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'ERB 713', rtype: 'room', capacity: 45, seat_type: 'Armchair', dept: 'Engineering' },
    { name: 'ERB 803', rtype: 'room', capacity: 80, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'ERB 804', rtype: 'room', capacity: 55, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'ERB LT', rtype: 'room', capacity: 241, seat_type: 'Lecture Theatre', dept: 'Engineering' },
    { name: 'LHC 101', rtype: 'room', capacity: 55, seat_type: 'Armchair', dept: 'New Asia College' },
    { name: 'LHC 103', rtype: 'room', capacity: 100, seat_type: 'Lecture Theatre', dept: 'New Asia College' },
    { name: 'LHC 104', rtype: 'room', capacity: 100, seat_type: 'Lecture Theatre', dept: 'New Asia College' },
    { name: 'LHC 106', rtype: 'room', capacity: 55, seat_type: 'Armchair', dept: 'New Asia College' },
    { name: 'LHC G01', rtype: 'room', capacity: 35, seat_type: 'Armchair', dept: 'New Asia College' },
    { name: 'LHC G03', rtype: 'room', capacity: 40, seat_type: 'Armchair', dept: 'New Asia College' },
    { name: 'LHC G04', rtype: 'room', capacity: 70, seat_type: 'Lecture Theatre', dept: 'New Asia College' },
    { name: 'LHC G06', rtype: 'room', capacity: 45, seat_type: 'Armchair', dept: 'New Asia College' },
    { name: 'CKB 108', rtype: 'room', capacity: 40, seat_type: 'Table & Chair', dept: 'Education' },
    { name: 'CKB 109', rtype: 'room', capacity: 70, seat_type: 'Table & Chair', dept: 'Education' },
    { name: 'CKB 122', rtype: 'room', capacity: 45, seat_type: 'Table & Chair', dept: 'Education' },
    { name: 'CKB 123', rtype: 'room', capacity: 40, seat_type: 'Table & Chair', dept: 'Education' },
    { name: 'CKB 706B', rtype: 'room', capacity: 40, seat_type: 'Armchair', dept: 'Education' },
    { name: 'CKB 706C', rtype: 'room', capacity: 40, seat_type: 'Armchair', dept: 'Education' },
    { name: 'CKB LT3', rtype: 'room', capacity: 135, seat_type: 'Lecture Theatre', dept: 'Education' },
    { name: 'CKB UG03', rtype: 'room', capacity: 55, seat_type: 'Table & Chair', dept: 'Education' },
    { name: 'CKB UG04', rtype: 'room', capacity: 60, seat_type: 'Table & Chair', dept: 'Education' },
    { name: 'CKB UG05', rtype: 'room', capacity: 55, seat_type: 'Table & Chair', dept: 'Education' },
    { name: 'CYT 201', rtype: 'room', capacity: 66, seat_type: 'Table & Chair', dept: 'Business' },
    { name: 'CYT 202', rtype: 'room', capacity: 70, seat_type: 'Table & Chair', dept: 'Business' },
    { name: 'CYT 203', rtype: 'room', capacity: 80, seat_type: 'Table & Chair', dept: 'Business' },
    { name: 'CYT 205', rtype: 'room', capacity: 8, seat_type: 'Table & Chair', dept: 'Business' },
    { name: 'CYT 206', rtype: 'room', capacity: 8, seat_type: 'Table & Chair', dept: 'Business' },
    { name: 'CYT 207', rtype: 'room', capacity: 8, seat_type: 'Table & Chair', dept: 'Business' },
    { name: 'CYT 208', rtype: 'room', capacity: 8, seat_type: 'Table & Chair', dept: 'Business' },
    { name: 'CYT 209A', rtype: 'room', capacity: 95, seat_type: 'Table & Chair', dept: 'Business' },
    { name: 'CYT 209B', rtype: 'room', capacity: 78, seat_type: 'Table & Chair', dept: 'Business' },
    { name: 'CYT 210', rtype: 'room', capacity: 4, seat_type: 'Table & Chair', dept: 'Business' },
    { name: 'CYT 211', rtype: 'room', capacity: 4, seat_type: 'Table & Chair', dept: 'Business' },
    { name: 'CYT 214', rtype: 'room', capacity: 47, seat_type: 'Table & Chair', dept: 'Business' },
    { name: 'CYT 215', rtype: 'room', capacity: 47, seat_type: 'Table & Chair', dept: 'Business' },
    { name: 'CYT LT4', rtype: 'room', capacity: 81, seat_type: 'Lecture Theatre', dept: 'Business' },
    { name: 'CYT LT5', rtype: 'room', capacity: 81, seat_type: 'Lecture Theatre', dept: 'Business' },
    { name: 'CK TSE', rtype: 'room', capacity: 147, seat_type: 'Lecture Theatre', dept: 'Engineering' },
    { name: 'ELB 202', rtype: 'room', capacity: 55, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'ELB 203', rtype: 'room', capacity: 70, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'ELB 204', rtype: 'room', capacity: 20, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'ELB 205', rtype: 'room', capacity: 50, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'ELB 206', rtype: 'room', capacity: 65, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'ELB 207', rtype: 'room', capacity: 50, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'ELB 302', rtype: 'room', capacity: 65, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'ELB 303', rtype: 'room', capacity: 65, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'ELB 304', rtype: 'room', capacity: 20, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'ELB 305', rtype: 'room', capacity: 28, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'ELB 306', rtype: 'room', capacity: 35, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'ELB 307', rtype: 'room', capacity: 65, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'ELB 308', rtype: 'room', capacity: 60, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'ELB 401', rtype: 'room', capacity: 70, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'ELB 403', rtype: 'room', capacity: 65, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'ELB 405', rtype: 'room', capacity: 80, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'ELB LT1', rtype: 'room', capacity: 244, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'ELB LT2', rtype: 'room', capacity: 154, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'ELB LT3', rtype: 'room', capacity: 154, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'ELB LT4', rtype: 'room', capacity: 154, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'HTB B6', rtype: 'room', capacity: 220, seat_type: 'Lecture Theatre', dept: 'Engineering' },
    { name: 'HYS 501', rtype: 'room', capacity: 40, seat_type: 'Armchair', dept: 'Engineering' },
    { name: 'HYS G01', rtype: 'room', capacity: 55, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'HYS G05', rtype: 'room', capacity: 70, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'LKC LT1', rtype: 'room', capacity: 229, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'SB 239', rtype: 'room', capacity: 45, seat_type: 'Armchair', dept: 'U-Wide' },
    { name: 'SB UG06', rtype: 'room', capacity: 72, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'FYB 105', rtype: 'room', capacity: 20, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'FYB 106', rtype: 'room', capacity: 30, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'FYB 107A', rtype: 'room', capacity: 20, seat_type: 'Armchair', dept: 'Engineering' },
    { name: 'FYB 107B', rtype: 'room', capacity: 20, seat_type: 'Armchair', dept: 'Engineering' },
    { name: 'FYB 401', rtype: 'room', capacity: 40, seat_type: 'Armchair', dept: 'Engineering' },
    { name: 'FYB 402', rtype: 'room', capacity: 20, seat_type: 'Armchair', dept: 'Engineering' },
    { name: 'FYB 405', rtype: 'room', capacity: 40, seat_type: 'Armchair/Table & Chair', dept: 'Engineering' },
    { name: 'FYB 603', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'Engineering' },
    { name: 'FYB LT4', rtype: 'room', capacity: 122, seat_type: 'Lecture Theatre', dept: 'Engineering' },
    { name: 'FYB UG01', rtype: 'room', capacity: 60, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'FYB UG02', rtype: 'room', capacity: 55, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'WMY 302', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 303', rtype: 'room', capacity: 64, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 304', rtype: 'room', capacity: 70, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 305', rtype: 'room', capacity: 70, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 306', rtype: 'room', capacity: 70, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 401', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 402', rtype: 'room', capacity: 50, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 403', rtype: 'room', capacity: 70, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 404', rtype: 'room', capacity: 40, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 405', rtype: 'room', capacity: 40, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 406', rtype: 'room', capacity: 70, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 407', rtype: 'room', capacity: 70, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 408', rtype: 'room', capacity: 70, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 501', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 502', rtype: 'room', capacity: 50, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 503', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 504', rtype: 'room', capacity: 40, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 505', rtype: 'room', capacity: 90, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 506', rtype: 'room', capacity: 70, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 507', rtype: 'room', capacity: 90, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'WMY 508', rtype: 'room', capacity: 70, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 201', rtype: 'room', capacity: 72, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 401', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 402', rtype: 'room', capacity: 52, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 403', rtype: 'room', capacity: 65, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 404', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 405', rtype: 'room', capacity: 80, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 406', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 407', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 408', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 409', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 410', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 411', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 501', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 502', rtype: 'room', capacity: 52, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 503', rtype: 'room', capacity: 65, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 504', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 505', rtype: 'room', capacity: 80, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 506', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 507', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 508', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 509', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 510', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 511', rtype: 'room', capacity: 30, seat_type: 'Armchair/Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 605', rtype: 'room', capacity: 30, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 607', rtype: 'room', capacity: 30, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'YIA 608', rtype: 'room', capacity: 30, seat_type: 'Table & Chair', dept: 'U-Wide' },
    { name: 'YIA LT3', rtype: 'room', capacity: 249, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'YIA LT4', rtype: 'room', capacity: 160, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'YIA LT5', rtype: 'room', capacity: 160, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'YIA LT6', rtype: 'room', capacity: 160, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'YIA LT7', rtype: 'room', capacity: 153, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'YIA LT8', rtype: 'room', capacity: 100, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'YIA LT9', rtype: 'room', capacity: 95, seat_type: 'Lecture Theatre', dept: 'U-Wide' },
    { name: 'SHB122', rtype: 'room', capacity: 50, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'ERB803', rtype: 'room', capacity: 80, seat_type: 'Table & Chair', dept: 'Engineering' },
    { name: 'T. Y. Wong Hall', rtype: 'room', capacity: 272, seat_type: 'Lecture Theatre', dept: 'Engineering' },
    { name: 'Science Centre LT1', rtype: 'room', capacity: 214, seat_type: 'Lecture Theatre', dept: 'Science' },
    { name: 'Science Centre LT2', rtype: 'room', capacity: 117, seat_type: 'Lecture Theatre', dept: 'Science' },
    { name: 'University Gym New Arc', rtype: 'room', capacity: 100, seat_type: 'Table & Chair', dept: 'Physical Education Unit' },
    { name: 'FPGA board', rtype: 'equipment', capacity: -1, seat_type: 'N/A', dept: 'Engineering' },
    { name: 'Badminton Bat', rtype: 'equipment', capacity: -1, seat_type: 'N/A', dept: 'Physical Education Unit' },
    { name: 'Basketball', rtype: 'equipment', capacity: -1, seat_type: 'N/A', dept: 'Physical Education Unit' },
    { name: 'Projector - Portable', rtype: 'equipment', capacity: -1, seat_type: 'N/A', dept: 'Engineering' },
    { name: 'Volleyball', rtype: 'equipment', capacity: -1, seat_type: 'N/A', dept: 'Physical Education Unit' },
    { name: 'Microscope', rtype: 'equipment', capacity: -1, seat_type: 'N/A', dept: 'Medicine' }
]

Resource_list.each do |attr|
    dept = Department.find_by!(name: attr[:dept])
    next unless dept

    Resource.find_or_create_by!(name: attr[:name], department: dept) do |resource|
      resource.rtype = attr[:rtype]
      resource.capacity = attr[:capacity]
      resource.seat_type = attr[:seat_type]
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

puts "Created #{Department.count} departments, #{Resource.count} resources (#{Resource.where(rtype: 'room').count} rooms, #{Resource.where(rtype: 'equipment').count} equipment), #{User.count} users and #{Booking.count} bookings"
