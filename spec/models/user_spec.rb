require 'rails_helper'
require_relative '../shared_context.rb'

def new_user(name, email)
  User.new({
    name: name,
    email: email,
    password: '123456',
    role: 'student',
    department: departments[:engine]
  })
end

RSpec.describe User, type: :model do
  include_context :database

  context "normal usage" do
    it "validates" do
      alice = new_user('alice', 'alice@example.com')
      expect(alice.valid?).to eq(true)
    end
  end

  context "same username or email" do
    it "invalidates" do
      alice = new_user('alice', 'alice@example.com')
      expect(alice.valid?).to eq(true)
      alice.save

      alice_2 = new_user('alice', 'alice2@example.com')
      expect(alice_2.valid?).to eq(false)

      alice_2 = new_user('Alice', 'alice2@example.com')
      expect(alice_2.valid?).to eq(false)

      alice_2 = new_user('alice2', 'alice@example.com')
      expect(alice_2.valid?).to eq(false)
    end
  end
end
