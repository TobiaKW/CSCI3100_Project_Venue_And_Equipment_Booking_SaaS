import consumer from "channels/consumer"

consumer.subscriptions.create({ channel: "BookingsChannel" }, {
  received(data) {
    if (data.type === "booking_status_changed") {
      this.updateBookingStatus(data)
      return
    }

    if (data.type === "new_booking_created") {
      this.prependAdminBookingRow(data)
    }
  },

  updateBookingStatus(data) {
    const row = document.querySelector(`[data-booking-id="${data.booking_id}"]`)
    if (!row) return

    const statusCell = row.querySelector("[data-booking-status]")
    if (statusCell) statusCell.textContent = data.status
  },

  prependAdminBookingRow(data) {
    const list = document.querySelector("[data-bookings-list]")
    if (!list || !data.html) return

    const exists = list.querySelector(`[data-booking-id="${data.booking_id}"]`)
    if (exists) return

    list.insertAdjacentHTML("afterbegin", data.html)
  }
})
