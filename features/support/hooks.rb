
Before do
  Timecop.freeze(Time.local(2026, 4, 13, 0, 0, 0))
  departments = {
    nil: Department.create!(name: 'Nil'),
    maths: Department.create!(name: 'Mathematics'),
    engine: Department.create!(name: 'Engineering')
  }
  resources = {
    computer: Resource.create!(name: 'Computer', rtype: 'equipment', department: departments[:engine]),
    shb123: Resource.create!(name: 'SHB 123', rtype: 'room', department: departments[:engine]),
    lsbc1: Resource.create!(name: 'LSB C1', rtype: 'room', department: departments[:maths]),
    shb924: Resource.create!(name: 'SHB 924', rtype: 'room', department: departments[:engine])
  }
  users = {
    admin: User.create!(name: 'admin', email: 'admin@example.com', password: '123456', role: 'admin', department: departments[:engine]),
    admin2: User.create!(name: 'admin2', email: 'admin2@example.com', password: '123456', role: 'admin', department: departments[:maths]),
    alice: User.create!(name: 'alice', email: 'alice@example.com', password: '123456', role: 'student', department: departments[:engine]),
    bob: User.create!(name: 'bob', email: 'bob@example.com', password: '123456', role: 'student', department: departments[:maths])
  }
end
