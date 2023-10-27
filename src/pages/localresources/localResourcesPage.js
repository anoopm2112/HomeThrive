import React from 'react'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import LocalResourceTable from '~/components/Tables/LocalResourceTable'

function LocalResourcePage() {
  return (
    <AuthedLayout>
      <LocalResourceTable />
    </AuthedLayout>
  )
}

export default LocalResourcePage
