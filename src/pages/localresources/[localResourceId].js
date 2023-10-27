import React, { useState } from 'react'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import LocalResourceDetails from '~/components/Details/LocalResourceDetails'
import Grid from '@material-ui/core/Grid'
import { useRouter } from 'next/router'
import { useUser } from '~/lib/amplifyAuth'

function LocalResourceDetailsPage() {
  const router = useRouter()
  const user = useUser()
  const { query } = router
  const { localResourceId } = query
  const id = localResourceId || undefined
  const [resource, setResource] = useState()

  return (
    <AuthedLayout>
      <Grid container spacing={2}>
        <Grid item sm={12} lg={5} xl={4}>
          <LocalResourceDetails
            resourceId={id}
            onFetchCompleted={(d) => {
              setResource(d.resource)
            }}
          />
        </Grid>
      </Grid>
    </AuthedLayout>
  )
}

export default LocalResourceDetailsPage
