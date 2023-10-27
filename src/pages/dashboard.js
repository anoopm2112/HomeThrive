import React from 'react'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import DashboardDetails from '~/components/Details/DashboardDetails'

function Dashboard() {
  return (
    <AuthedLayout>
      <DashboardDetails />
    </AuthedLayout>
  )
}

export default Dashboard
