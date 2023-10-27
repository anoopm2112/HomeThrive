import React from 'react'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import ChildTable from '~/components/Tables/ChildTable'

function ChildPage() {
  return (
    <AuthedLayout>
      <ChildTable />
    </AuthedLayout>
  )
}

export default ChildPage
