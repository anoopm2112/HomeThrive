import React from 'react'
import { useRouter } from 'next/router'
import AgentDetails from '~/components/Details/AgentDetails'
import FamilyTable from '~/components/Tables/FamilyTable'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import Grid from '@material-ui/core/Grid'

function AgentDetailsPage() {
  const router = useRouter()
  const { agent_id } = router.query

  return (
    <AuthedLayout>
      <Grid container spacing={2}>
        <Grid item md={6} lg={4} xl={3}>
          <AgentDetails agentId={agent_id} />
        </Grid>
        <Grid item md={12} lg={8} xl={9}>
          <FamilyTable agentId={agent_id} />
        </Grid>
      </Grid>
    </AuthedLayout>
  )
}

export default AgentDetailsPage
