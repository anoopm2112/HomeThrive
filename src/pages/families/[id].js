import React from 'react'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import FamilyDetails from '~/components/Details/FamilyDetails'
import UploadedImages from './UploadedImages'
import Grid from '@material-ui/core/Grid'
import ChildrenLogsTable from '~/components/Tables/LogsTable/ChildrenLogsTable'
import MedLogsTable from '~/components/Tables/MedLogsTable/MedLogsTable'
import RecreationLogsTable from '~/components/Tables/RecreationLogsTable/RecreationLogsTable'
import { useRouter } from 'next/router'
import LogDetails from '~/components/Details/LogDetails'
import RecreationLogDetails from '~/components/Details/RecreationLogDetails'
import MessagesList from '~/components/Tables/MessagesTable/MessagesList'
import { useUser } from '~/lib/amplifyAuth'

function FamilyDetailsPage() {
  const router = useRouter()
  const user = useUser()
  const { query } = router
  const { id } = query
  const familyId = parseInt(id) || undefined

  return (
    <AuthedLayout>
      <FamilyDetailsContent user={user} familyId={familyId} />
    </AuthedLayout>
  )
}

function FamilyDetailsContent({ user, familyId }) {
  const role = parseInt(user?.attributes['custom:role'])
  return (
    <Grid container spacing={2}>
      <Grid item sm={12} lg={5} xl={5}>
        <FamilyDetails familyId={familyId} role={role} />
        {role === 2 ?
          <>
            <UploadedImages familyId={familyId} role={role} />
          </>
        : <></>}
        <MedLogsTable familyId={familyId} />
      </Grid>
      {role != 0 ?
        <Grid item sm={12} lg={7} xl={7}>
          <LogDetails />
          <RecreationLogDetails />
          <MessagesList familyId={familyId} />
          <ChildrenLogsTable familyId={familyId} />
          <RecreationLogsTable familyId={familyId} />
        </Grid>
      : <></> }
    </Grid>
  )
}

export default FamilyDetailsPage
