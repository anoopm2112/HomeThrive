import React from 'react'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import AgencyTable from '~/components/Tables/AgencyTable'

function AgencyPage() {
  return (
    <AuthedLayout>
      <AgencyTable />
    </AuthedLayout>
  )
}

export default AgencyPage
