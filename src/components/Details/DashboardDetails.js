import React from 'react'

import { useUser } from '~/lib/amplifyAuth'

import {
  DashboardAdminRole,
  DashboardAgencyRole,
  DashboardAgentRole,
} from '~/components/Dashboard'

const DashboardNoRole = (props) => {
  return 'The dashboard is not currently available.'
}

const DashboardDetails = () => {
  const user = useUser()
  const role = user?.attributes
    ? parseInt(user?.attributes['custom:role'])
    : undefined

  let DashboardComponent = DashboardNoRole
  switch (role) {
    case 0:
      DashboardComponent = DashboardAdminRole
      break
    case 1:
      DashboardComponent = DashboardAgencyRole
      break
    case 2:
      DashboardComponent = DashboardAgentRole
      break
    default:
      DashboardComponent = DashboardNoRole
      break
  }
  return <DashboardComponent {...user} />
}

export default DashboardDetails
