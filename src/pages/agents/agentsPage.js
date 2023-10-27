import React from 'react'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import AgentTable from '~/components/Tables/AgentTable'

function AgentPage() {
  return (
    <AuthedLayout>
      <AgentTable />
    </AuthedLayout>
  )
}

export default AgentPage
