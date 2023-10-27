import React from 'react'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import NotificationTable from '~/components/Tables/NotificationTable'

function NotificationsPage() {
  return (
    <AuthedLayout>
      <NotificationTable />
    </AuthedLayout>
  )
}

export default NotificationsPage
