import React, { useState, useEffect } from 'react'
import { useQuery } from '@apollo/client'
import { GET_CHILD } from '~/lib/queries/children'
import ChildForm from '~/components/Forms/ChildForm'
import Typography from '@material-ui/core/Typography'
import Button from '@material-ui/core/Button'
import Divider from '@material-ui/core/Divider'
import Paper from '@material-ui/core/Paper'
import Grid from '@material-ui/core/Grid'
import Edit from '@material-ui/icons/Edit'
import CircularProgress from '@material-ui/core/CircularProgress'
import T from '~/lib/text'
import useStyles from './Details.styles'

function ChildDetails({ childId, role }) {
  const [showDialog, setShowDialog] = useState(false)
  // gets currently logged in user

  //    __     _      _    _             __                 _        _   _
  //   / _|___| |_ __| |_ (_)_ _  __ _  / _|___   _ __ _  _| |_ __ _| |_(_)___ _ _
  //  |  _/ -_)  _/ _| ' \| | ' \/ _` | > _|_ _| | '  \ || |  _/ _` |  _| / _ \ ' \
  //  |_| \___|\__\__|_||_|_|_||_\__, | \_____|  |_|_|_\_,_|\__\__,_|\__|_\___/_||_|
  //

  const {
    loading: fetchLoading,
    data: fetchData,
    error: fetchError,
  } = useQuery(GET_CHILD, {
    skip: !childId,
    variables: { input: { id: childId } },
  })

  const child = fetchData?.child

  //     _      _
  //  __| |__ _| |_ __ _   _ __ _ _ ___ _ __
  // / _` / _` |  _/ _` | | '_ \ '_/ -_) '_ \
  // \__,_\__,_|\__\__,_| | .__/_| \___| .__/
  //                      |_|          |_|

  let initialEditState
  if (child) {
    initialEditState = {
      id: childId,
      firstName: child?.firstName,
      lastName: child?.lastName,
      agentId: child?.agentId,
      agentName: child?.agentName,
      dateOfBirth: child?.dateOfBirth ? child?.dateOfBirth.split('T')[0] : '',
      fosterCareStartDate: child?.fosterCareStartDate
        ? child?.fosterCareStartDate.split('T')[0]
        : '',
      placementId: child?.placementId,
      medicaidNumber: child?.medicaidNumber,
      notes: child?.notes,
      parent: child?.parent,
      parentId: child?.parent?.id
    }
  }

  const name = child?.lastName ? child?.firstName + ' ' + child?.lastName : '--'

  const birthDate = new Date(child?.dateOfBirth.slice(0, -1))
  const ageInDays =
    (Date.now() - new Date(birthDate).getTime()) / (1000 * 60 * 60 * 24)
  const ageInYears = ageInDays / 365
  const ageInMonths = ageInDays / 30
  const ageToShow =
    ageInYears < 2
      ? `${ageInMonths.toFixed(1)} ${T('Months')}`
      : `${Math.floor(ageInYears)} ${T('Years')}`
  const birthDateToShow = birthDate.toLocaleDateString()

  const timeInFoster = new Date(child?.fosterCareStartDate)
  const timeInDays =
    (Date.now() - new Date(timeInFoster).getTime()) / (1000 * 60 * 60 * 24)
  const timeInMonths = timeInDays / 30
  const timeInYears = timeInDays / 365
  const timeToShow =
    timeInYears < 2
      ? `${timeInMonths.toFixed(1)} ${T('Months')}`
      : `${Math.floor(timeInYears)} ${T('Years')}`

  const parent1 = child?.parent
  const parent2 = parent1?.secondaryParents
    ? parent1?.secondaryParents[0]
    : undefined
  const family = parent1
    ? `${parent1.firstName} ${parent2 ? `& ${parent2.firstName} ` : ''}${
        parent1.lastName
      }`
    : '--'
  const agencyId = child?.agencyId
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
        <div className="child-details">
          {role <= 2 && (
            <ChildForm
              show={showDialog}
              handleClose={() => setShowDialog(false)}
              initialState={initialEditState}
              agencyId={role == 0 ? agencyId : null}
            />
          )}
          <Grid container spacing={2}>
            <Grid item xs={12} className={classes.header}>
              <Typography className={classes.detailsTitle} variant="h4">
                {T('ChildDetailsHeader')}
              </Typography>
              {role <= 2 && (
                <Button color="secondary" onClick={() => setShowDialog(true)}>
                  <Edit />
                </Button>
              )}
            </Grid>
            <Grid item xs={12}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Name')}
              </Typography>
              <Typography variant="h3">{name}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Age')}
              </Typography>
              <Typography variant="body1">{ageToShow}</Typography>
            </Grid>

            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('BirthDate')}
              </Typography>
              <Typography variant="body1">{birthDateToShow}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Family')}
              </Typography>
              <Typography variant="body1">{family}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Agent')}
              </Typography>
              <Typography variant="body1">{child?.agentName}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('MedicaidNumber')}
              </Typography>
              <Typography variant="body1">{child?.parent ? child?.medicaidNumber : '--'}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('ChildLevel')}
              </Typography>
              <Typography variant="body1">{child?.parent ? child?.level : '--'}</Typography>
            </Grid>
          </Grid>
          {child?.parent ?
          <>
          <Divider className={classes.divider} />
          <Grid container spacing={2}>
            <Grid item xs={12} className={classes.header}>
              <Typography className={classes.detailsTitle} variant="h4">
                {T('PlacementInformation')}
              </Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('PID')}
              </Typography>
              <Typography variant="body1">{child?.placementId}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('TimeInFoster')}
              </Typography>
              <Typography variant="body1">{timeToShow}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('AgencyName')}
              </Typography>
              <Typography variant="body1">{child?.agencyName}</Typography>
            </Grid>
            <Grid item xs={12}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Notes')}
              </Typography>
              <Typography variant="body1">{child?.notes}</Typography>
            </Grid>
          </Grid>
          </>
          : <></> }
        </div>
      )}
    </Paper>
  )
}

export default ChildDetails
