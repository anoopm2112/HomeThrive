import React from 'react'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import ResourceTable from '~/components/Tables/ResourceTable'

function ResourcePage() {
  return (
    <AuthedLayout>
      <ResourceTable />
    </AuthedLayout>
  )
}

export default ResourcePage
