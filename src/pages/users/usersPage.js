import React from 'react'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import UserTable from '~/components/Tables/UserTable'

function UserPage() {
  return (
    <AuthedLayout>
      <UserTable />
    </AuthedLayout>
  )
}

export default UserPage
