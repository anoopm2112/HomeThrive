import React, { useState } from 'react'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import MessagesTable from '~/components/Tables/MessagesTable'
import ScheduledMessagesTable from '~/components/Tables/MessagesTable/ScheduledMessagesTable'
import Grid from '@material-ui/core/Grid'

function MessagesPage() {
  return (
    <AuthedLayout>
      <Grid container spacing={2}>
        <Grid item sm={12} lg={6} xl={6}>
          <MessagesTable />
        </Grid>
        <Grid item sm={12} lg={6} xl={6}>
          <ScheduledMessagesTable />
        </Grid>
      </Grid>
    </AuthedLayout>
  )
}

export default MessagesPage
