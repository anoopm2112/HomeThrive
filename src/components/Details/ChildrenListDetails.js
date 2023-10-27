import React from 'react'
import { useQuery } from '@apollo/client'
import { GET_FAMILY } from '~/lib/queries/families'
import Paper from '@material-ui/core/Paper'
import Edit from '@material-ui/icons/Edit'
import Typography from '@material-ui/core/Typography'
import Button from '@material-ui/core/Button'
import CircularProgress from '@material-ui/core/CircularProgress'
import Grid from '@material-ui/core/Grid'
import T from '~/lib/text'
import useStyles from './Details.styles'
/**
 *
 *
 *
 *         _
 * __ __ _(_)_ __
 * \ V  V / | '_ \
 *  \_/\_/|_| .__/
 *          |_|
 *
 * meant to show the children of a family and then provide a simple link to the child page, but
 * the endpoint doesnt exist.
 * setting aside for now 4/27/21
 * @param {*} param0
 * @returns
 */

function ChildListDetails({ familyId }) {
  const id = parseInt(familyId) || undefined

  //   __     _      _    _
  //  / _|___| |_ __| |_ (_)_ _  __ _
  // |  _/ -_)  _/ _| ' \| | ' \/ _` |
  // |_| \___|\__\__|_||_|_|_||_\__, |
  //                            |___/

  const {
    loading: fetchLoading,
    data: fetchData,
    error: fetchError,
  } = useQuery(GET_FAMILY, {
    skip: !id,
    variables: {
      input: { id: id },
    },
    notifyOnNetworkStatusChange: true,
  })

  //     _      _
  //  __| |__ _| |_ __ _   _ __ _ _ ___ _ __
  // / _` / _` |  _/ _` | | '_ \ '_/ -_) '_ \
  // \__,_\__,_|\__\__,_| | .__/_| \___| .__/
  //

  const family = fetchData?.family
  // console.log('FAMILY', family)
  const parent1Name =
    family?.firstName && family?.lastName
      ? `${family.firstName} ${family.lastName}`
      : '--'
  const parent2 =
    family?.secondaryParents.length > 0 ? family?.secondaryParents[0] : []
  const parent2Name =
    parent2?.firstName && parent2?.lastName
      ? `${parent2.firstName} ${parent2.lastName}`
      : '--'

  const location =
    family?.city && family?.state ? family.city + ', ' + family?.state : '--'

  // format initial edit state
  let initialEditState
  if (family) {
    const parent2 = family?.secondaryParents.length
      ? family?.secondaryParents[0]
      : {}
    initialEditState = {
      id: id,
      firstName: family?.firstName,
      lastName: family?.lastName,
      agentId: family?.agentId,
      agentName: family?.agentName,
      occupation: family?.occupation,
      parent2FirstName: parent2?.firstName,
      parent2LastName: parent2?.lastName,
      parent2Email: parent2?.email,
      parent2PhoneNumber: parent2?.phoneNumber,
      parent2Occupation: parent2?.occupation,
      licenseNumber: family?.licenseNumber,
      city: family?.city,
      state: family?.state,
      zipCode: family?.zipCode,
      primaryLanguage: family?.primaryLanguage,
      address: family?.address,
      email: family?.email,
      phoneNumber: family?.phoneNumber,
    }
  }

  const classes = useStyles()
  return (
    <Paper className={classes.paper}>
      {fetchLoading ? (
        <CircularProgress />
      ) : (
        <div className="agency-details">
          <Grid container spacing={2}>
            <Grid item xs={12} className={classes.header}>
              <Typography className={classes.detailsTitle} variant="h4">
                {T('DetailsHeader')}
              </Typography>
            </Grid>
            <Grid item xs={12}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Name1')}
              </Typography>
              <Typography variant="h3">{parent1Name}</Typography>
            </Grid>
            <Grid item xs={12}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Name2')}
              </Typography>
              <Typography variant="h3">{parent2Name}</Typography>
            </Grid>
            <Grid item xs={12} md={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Email')}
              </Typography>
              <Typography variant="body1">{family?.email}</Typography>
            </Grid>
            <Grid item xs={12} md={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Location')}
              </Typography>
              <Typography variant="body1">{location}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Phone')}
              </Typography>
              <Typography variant="body1">{family?.phoneNumber}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('NumChildren')}
              </Typography>
              <Typography variant="body1">{family?.childrenCount}</Typography>
            </Grid>
          </Grid>
        </div>
      )}
    </Paper>
  )
}

export default ChildListDetails
