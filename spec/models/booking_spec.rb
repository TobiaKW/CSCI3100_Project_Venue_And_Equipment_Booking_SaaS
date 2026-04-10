require 'rails_helper'
require 'timecop'
require_relative 'shared_context.rb'

RSpec.describe Booking, type: :model do
  include_context "database"
  let (:freeze_date) { Time.zone.local(2026, 4, 10, 0, 0, 0) }
  let (:booking) do
    Booking.new({ 
      :user => users[:alice],
      :resource => resources[:shb924],
      :department => resources[:shb924].department # temporary fix
    })
  end
  context "correct usage" do
    it "validates" do
      Timecop.freeze(freeze_date) do
        booking.start_time = freeze_date + 7.day + 10.hour
        booking.end_time = freeze_date + 7.day + 11.hour
        expect(booking.valid?).to eq(true)
      end
    end
  end

  context "missing start time or end time" do
    it "invalidates" do
      Timecop.freeze(freeze_date) do
        booking.start_time = nil
        booking.end_time = freeze_date + 7.day + 11.hour
        expect(booking.valid?).to be(false)
        
        booking.start_time =  freeze_date + 7.day + 10.hour
        booking.end_time = nil
        expect(booking.valid?).to be(false)
      end
    end
  end

  context "end time before start time" do
    it "invalidates" do
      Timecop.freeze(freeze_date) do
        booking.start_time = freeze_date + 7.day + 11.hour
        booking.end_time = freeze_date + 7.day + 10.hour
        expect(booking.valid?).to be(false)
      end
    end
  end

  context "lasts less than an hour" do
    it "invalidates" do
      Timecop.freeze(freeze_date) do
        booking.start_time = freeze_date + 7.day + 10.hour
        booking.end_time = freeze_date + 7.day + 10.hour + 30.minute
        expect(booking.valid?).to be(false)
      end
    end
  end

  context "overlapping bookings for resource" do
    it "invalidates" do
      Timecop.freeze(freeze_date) do
        
        booking_alice_924 = Booking.new({ 
          :user => users[:alice],
          :resource => resources[:shb924],
          :department => resources[:shb924].department,
          :start_time => freeze_date + 7.day + 10.hour,
          :end_time => freeze_date + 7.day + 11.hour,
          :status => 'approved'
        })
        
        booking_bob_924 = Booking.new({ 
          :user => users[:bob],
          :resource => resources[:shb924],
          :department => resources[:shb924].department,
          :start_time => freeze_date + 7.day + 10.hour + 30.minute,
          :end_time => freeze_date + 7.day + 11.hour + 30.minute,
          :status => 'approved'
        })
        
        booking_bob_123 = Booking.new({ 
          :user => users[:bob],
          :resource => resources[:shb123],
          :department => resources[:shb123].department,
          :start_time => freeze_date + 7.day + 10.hour + 30.minute,
          :end_time => freeze_date + 7.day + 11.hour + 30.minute,
          :status => 'approved'
        })

        expect(booking_alice_924.save).to be(true) # Alice books SHB 924 from 10:00 to 11:00
        expect(booking_bob_924.save).to be(false) # Bob cannot book SHB 924 from 10:30 to 11:30
        expect(booking_bob_123.save).to be(true) # Bob books SHB 123 from 10:30 to 11:30
      end
    end
  end

  context "less than seven days in advance" do
    it "invalidates" do
      Timecop.freeze(freeze_date) do
        booking.start_time = freeze_date + 6.day + 10.hour
        booking.end_time = freeze_date + 6.day + 11.hour
        expect(booking.valid?).to be(false)
      end
    end
  end

  context "overnight booking of equipment" do
    it "validates" do
      Timecop.freeze(freeze_date) do
        booking.resource = resources[:computer]
        booking.start_time = freeze_date + 7.day + 10.hour
        booking.end_time = freeze_date + 8.day + 10.hour
        expect(booking.valid?).to be(true)
      end
    end
  end

  context "overnight booking of venue" do
    it "invalidates" do
      Timecop.freeze(freeze_date) do
        booking.resource = resources[:shb924]
        booking.start_time = freeze_date + 7.day + 23.hour
        booking.end_time = freeze_date + 8.day + 1.hour
        expect(booking.valid?).to be(false)
      end
    end
  end
end
