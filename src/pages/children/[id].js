import React from 'react'
import { useRouter } from 'next/router'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import ChildDetails from '~/components/Details/ChildDetails'
import Grid from '@material-ui/core/Grid'
import ChildLogsTable from '~/components/Tables/LogsTable/ChildLogsTable'
import ChildMedLogsTable from '~/components/Tables/ChildMedLogsTable/ChildMedLogsTable'
import ChildRecreationLogsTable from '~/components/Tables/ChildRecreationLogsTable/ChildRecreationLogsTable'
import LogDetails from '~/components/Details/LogDetails'
import RecreationLogDetails from '~/components/Details/RecreationLogDetails'
import { useUser } from '~/lib/amplifyAuth'

function Children() {
  const router = useRouter()
  const { id } = router.query
  const user = useUser()

  return (
    <AuthedLayout>
      <ChildDetailsContent user={user} childId={id} />
    </AuthedLayout>
  )
}

function ChildDetailsContent({ user, childId }) {
  const role = user?.attributes ? user?.attributes['custom:role'] : undefined
  return (
    <Grid container spacing={2}>
      <Grid item xs={12} sm={12} md={12} lg={5}>
        <ChildDetails childId={childId} role={role} />
        <ChildMedLogsTable childId={childId} />
      </Grid>
      {role != 0 ?
        <Grid item xs={12} sm={12} md={12} lg={7}>
          <LogDetails />
          <RecreationLogDetails />
          {childId ? 
            <>
              <ChildLogsTable childId={childId} />
              <ChildRecreationLogsTable childId={childId} />
            </> : <></> }
        </Grid>
      : <></> }
    </Grid>
  )
}

export default Children
