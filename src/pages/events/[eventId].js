import React from 'react'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import EventDetails from '~/components/Details/EventDetails'
import Grid from '@material-ui/core/Grid'
import { useRouter } from 'next/router'
import EventParticipantsTable from '~/components/Tables/EventsTable/EventParticipantsTable'

function EventDetailsPage() {
  const router = useRouter()
  const { query } = router
  const { eventId } = query

  return (
    <AuthedLayout>
      <Grid container spacing={2}>
        <Grid item sm={12} lg={5} xl={4}>
          <EventDetails eventId={eventId} />
        </Grid>
        <Grid item sm={12} lg={7} xl={8}>
          <EventParticipantsTable eventId={eventId} />
        </Grid>
      </Grid>
    </AuthedLayout>
  )
}

export default EventDetailsPage
