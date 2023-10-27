import React, { useState } from 'react'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import EventsTable from '~/components/Tables/EventsTable'

function EventsPage() {
  return (
    <AuthedLayout>
      <EventsTable />
    </AuthedLayout>
  )
}

export default EventsPage
