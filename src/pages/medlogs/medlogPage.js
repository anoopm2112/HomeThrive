import React from 'react'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import MedLogsTable from '~/components/Tables/MedLogsTable'

function MedlogPage() {
  return (
    <AuthedLayout>
      <MedLogsTable />
    </AuthedLayout>
  )
}

export default MedlogPage
