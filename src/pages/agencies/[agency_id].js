import React, { useState, useEffect, useContext } from 'react'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import AgencyForm from '~/components/Forms/AgencyForm'
import { useQuery, useMutation } from '@apollo/client'
import { useRouter } from 'next/router'
import { GET_AGENCY, UPDATE_AGENCY } from '~/lib/queries/agencies'
import AgencyDetails from '~/components/Details/AgencyDetails'
import Grid from '@material-ui/core/Grid'
import { NotificationContext } from '~/components/Contexts/NotificationContext'
import { formatPhoneNumber } from '~/lib/utils'
import useStyles from '~/styles/agencyPage.styles'

function AgencyDetailPage() {
  // set state and grab id from query
  const [dialogOpen, setDialogOpen] = useState(false)
  const router = useRouter()
  const { query } = router
  const { agency_id } = query

  return (
    <AuthedLayout>
      <AgencyDetailsContent agencyId={agency_id} />
    </AuthedLayout>
  )
}

function AgencyDetailsContent({ user, agencyId }) {
  const role = user?.attributes['custom:role']
  return (
    <div className="agency-details-page">
      <Grid container spacing={2}>
        <Grid item xs={12} sm={8} md={6}>
          <AgencyDetails agencyId={agencyId} role={parseInt(role)} />
        </Grid>
      </Grid>
    </div>
  )
}

export default AgencyDetailPage
