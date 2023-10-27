import React, { useState } from 'react'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import MedlogDetails from '~/components/Details/MedlogDetails'
import MedLogEntriesTable from '~/components/Tables/MedLogEntriesTable/MedLogEntriesTable'
import MedicationList from '~/components/Tables/MedicationList/MedicationList'
import Grid from '@material-ui/core/Grid'
import { useRouter } from 'next/router'

function MedlogDetailsPage() {
  const router = useRouter()
  const { query } = router
  const { medlogId } = query
  const [medlog, setMedlog] = useState()

  return (
    <AuthedLayout>
      <Grid container spacing={2}>
        <Grid item sm={12} lg={5} xl={4}>
          <MedlogDetails
            medlogId={medlogId}
            onFetchCompleted={(d) => {
              setMedlog(d.medlog)
            }}
          />
          <MedicationList medlogId={medlogId} />
        </Grid>
        <Grid item sm={12} lg={7} xl={8}>
          <MedLogEntriesTable medlogId={medlogId} />
        </Grid>
      </Grid>
    </AuthedLayout>
  )
}

export default MedlogDetailsPage
