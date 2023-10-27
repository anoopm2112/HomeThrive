import React, { useState } from 'react'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import ResourceDetails from '~/components/Details/ResourceDetails'
import ResourceDetailsContent from '~/components/Details/ResourceDetailsContent'
import Grid from '@material-ui/core/Grid'
import { useRouter } from 'next/router'
import { useUser } from '~/lib/amplifyAuth'

function ResourceDetailsPage() {
  const router = useRouter()
  const user = useUser()
  const { query } = router
  const { resourceId } = query
  const id = parseInt(resourceId) || undefined
  const [resource, setResource] = useState()

  return (
    <AuthedLayout>
      <Grid container spacing={2}>
        <Grid item sm={12} lg={5} xl={4}>
          <ResourceDetails
            resourceId={id}
            onFetchCompleted={(d) => {
              setResource(d.resource)
            }}
          />
        </Grid>
        <Grid item sm={12} lg={7} xl={8}>
          <ResourceDetailsContent resource={resource} />
        </Grid>
      </Grid>
    </AuthedLayout>
  )
}

export default ResourceDetailsPage
