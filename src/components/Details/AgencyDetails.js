import React, { useState, useEffect } from 'react'
import { useQuery } from '@apollo/client'
import { GET_AGENCY_PROFILE, GET_AGENCY } from '~/lib/queries/agencies'
import AgencyForm from '~/components/Forms/AgencyForm'
import Divider from '@material-ui/core/Divider'
import Typography from '@material-ui/core/Typography'
import Button from '@material-ui/core/Button'
import Paper from '@material-ui/core/Paper'
import Grid from '@material-ui/core/Grid'
import Edit from '@material-ui/icons/Edit'
import CircularProgress from '@material-ui/core/CircularProgress'
import T from '~/lib/text'
import useStyles from './Details.styles'

function AgencyDetails({ role, agencyId }) {
  const [showDialog, setShowDialog] = useState(false)
  // gets currently logged in user
  const canEdit = role < 2
  //    __     _      _    _             __                 _        _   _
  //   / _|___| |_ __| |_ (_)_ _  __ _  / _|___   _ __ _  _| |_ __ _| |_(_)___ _ _
  //  |  _/ -_)  _/ _| ' \| | ' \/ _` | > _|_ _| | '  \ || |  _/ _` |  _| / _ \ ' \
  //  |_| \___|\__\__|_||_|_|_||_\__, | \_____|  |_|_|_\_,_|\__\__,_|\__|_\___/_||_|
  //

  const {
    loading: fetchLoading,
    data: fetchData,
    error: fetchError,
  } = useQuery(agencyId ? GET_AGENCY : GET_AGENCY_PROFILE, {
    skip: role === undefined,
    ...(agencyId
      ? {
          variables: {
            id: agencyId,
          },
        }
      : {}),
  })

  const agency = agencyId ? fetchData?.agency : fetchData?.agencyProfile
  const poc = agency?.poc

  // console.log('AGENCY', agency)

  //     _      _
  //  __| |__ _| |_ __ _   _ __ _ _ ___ _ __
  // / _` / _` |  _/ _` | | '_ \ '_/ -_) '_ \
  // \__,_\__,_|\__\__,_| | .__/_| \___| .__/
  //                      |_|          |_|

  let initialEditState
  if (agency) {
    initialEditState = {
      id: agency.id,
      name: agency?.name,
      address: agency?.address,
      city: agency?.city,
      state: agency?.state,
      zip: agency?.zipCode,
      license: agency?.licenseNumber,
      calendarLink: agency?.agencyCalendarUrl,
      pocFirstName: agency?.poc?.firstName,
      pocLastName: agency?.poc?.lastName,
      pocEmail: agency?.poc?.email,
      pocTitle: agency?.poc?.title,
      pocPhone: agency?.poc?.phoneNumber,
    }
  }

  //  _ _    _
  // | (_)__| |_ ___ _ _  ___ _ _ ___
  // | | (_-<  _/ -_) ' \/ -_) '_(_-<
  // |_|_/__/\__\___|_||_\___|_| /__/
  //

  useEffect(() => {
    if (fetchError) {
      console.log(
        'ERROR',
        fetchError,
        Object.keys(fetchError),
        fetchError?.networkError?.result,
        fetchError?.graphQLErrors
      )
    }
  }, [fetchError])

  const classes = useStyles()
  return (
    <Paper className={classes.paper}>
      {fetchLoading ? (
        <CircularProgress />
      ) : (
        <div className="agency-details">
          <AgencyForm
            show={showDialog}
            handleClose={() => setShowDialog(false)}
            initialState={initialEditState}
            role={role}
            agencyId={agencyId}
          />
          <Grid container spacing={2}>
            <Grid item xs={12} className={classes.header}>
              <Typography className={classes.detailsTitle} variant="h4">
                {T('AgencyDetailsHeader')}
              </Typography>
              {canEdit && (
                <Button color="secondary" onClick={() => setShowDialog(true)}>
                  <Edit />
                </Button>
              )}
            </Grid>
            <Grid item xs={12}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('AgencyName')}
              </Typography>
              <Typography variant="h3">{agency?.name}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Address')}
              </Typography>
              <Typography variant="body1">{agency?.address}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('City')}
              </Typography>
              <Typography variant="body1">{agency?.city}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('State')}
              </Typography>
              <Typography variant="body1">{agency?.state}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Zip')}
              </Typography>
              <Typography variant="body1">{agency?.zipCode}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('AgencyLicense')}
              </Typography>
              <Typography variant="body1">{agency?.licenseNumber}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('NumFamilies')}:
              </Typography>
              <Typography variant="body1">
                {agency?.familiesCount || 0}
              </Typography>
            </Grid>
            <Grid item xs={12}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('AgencyCalendarUrl')}:
              </Typography>
              <Typography variant="body1" className={classes.email}>{agency?.agencyCalendarUrl || '-'}</Typography>
              {agency?.agencyCalendarUrl ?
              <a
                className={classes.link}
                href={agency?.agencyCalendarUrl}
                target="_blank"
                rel="noreferrer"
              >
                <Button variant="contained" color="primary">
                  {T('Preview')}
                </Button>
              </a> : <></> }
            </Grid>
          </Grid>
          <Divider className={classes.divider} />
          <Grid container spacing={2}>
            <Grid item xs={12}>
              <Typography className={classes.detailsTitle} variant="h4">
                {T('POC')}
              </Typography>
            </Grid>
            <Grid item xs={12}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Name')}
              </Typography>
              <Typography variant="h3">
                {poc?.firstName} {poc?.lastName}
              </Typography>
            </Grid>

            <Grid item xs={12}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Email')}
              </Typography>
              <Typography variant="body1" color="primary">
                {poc?.email}
              </Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Title')}
              </Typography>
              <Typography variant="body1">{poc?.title}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Phone')}
              </Typography>
              <Typography variant="body1">{poc?.phoneNumber}</Typography>
            </Grid>
          </Grid>
        </div>
      )}
    </Paper>
  )
}

export default AgencyDetails
