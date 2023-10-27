import React, { useState, useEffect, useContext } from 'react'
import { useQuery } from '@apollo/client'
import { GET_PROFILE } from '~/lib/queries/users'
import ProfileForm from '~/components/Forms/ProfileForm'
import Typography from '@material-ui/core/Typography'
import Paper from '@material-ui/core/Paper'
import Button from '@material-ui/core/Button'
import Grid from '@material-ui/core/Grid'
import CircularProgress from '@material-ui/core/CircularProgress'
import AccountCircleIcon from '@material-ui/icons/AccountCircle'
import Edit from '@material-ui/icons/Edit'
import T from '~/lib/text'
import useStyles from './Details.styles'

function ProfileDetails({ role }) {
  const [showDialog, setShowDialog] = useState(false)

  //   __     _      _    _             __                 _        _   _
  //  / _|___| |_ __| |_ (_)_ _  __ _  / _|___   _ __ _  _| |_ __ _| |_(_)___ _ _  ___
  // |  _/ -_)  _/ _| ' \| | ' \/ _` | > _|_ _| | '  \ || |  _/ _` |  _| / _ \ ' \(_-<
  // |_| \___|\__\__|_||_|_|_||_\__, | \_____|  |_|_|_\_,_|\__\__,_|\__|_\___/_||_/__/
  //                            |___/

  // gets profile for currently logged in user
  const {
    loading: profileLoading,
    data: profileData,
    error: profileError,
  } = useQuery(GET_PROFILE)

  const profile = profileData?.profile

  //  _ _    _
  // | (_)__| |_ ___ _ _  ___ _ _ ___
  // | | (_-<  _/ -_) ' \/ -_) '_(_-<
  // |_|_/__/\__\___|_||_\___|_| /__/
  //
  const error = profileError
  const loading = profileLoading

  useEffect(() => {
    if (error) {
      console.log(
        'FETCHING ERROR',
        error,
        Object.keys(error),
        error?.networkError?.result,
        error?.graphQLErrors
      )
    }
  }, [error])

  const classes = useStyles()

  return (
    <Paper className={classes.paper}>
      {loading ? (
        <CircularProgress />
      ) : (
        <div className="profile-details">
          <ProfileForm
            show={showDialog}
            handleClose={() => setShowDialog(false)}
            initialState={profile}
          />
          <Grid container spacing={2}>
            <Grid item xs={12} className={classes.header}>
              <Typography variant="h4">{T('AccountInformation')}</Typography>
              <Button color="secondary" onClick={() => setShowDialog(true)}>
                <Edit />
              </Button>
            </Grid>
            <Grid container spacing={1}>
              <Grid item xs={3}>
                <Paper className={classes.profilePic}>
                  <AccountCircleIcon fontSize="inherit" />
                </Paper>
              </Grid>
              <Grid container item xs={9} spacing={2}>
                <Grid item xs={9}>
                  <Typography className={classes.groupTitle} variant="body2">
                    {T('Name')}
                  </Typography>
                  <Typography variant="body1">
                    {profile?.firstName} {profile?.lastName}
                  </Typography>
                </Grid>
                <Grid item xs={9}>
                  <Typography className={classes.groupTitle} variant="body2">
                    {T('Email')}
                  </Typography>
                  <Typography variant="body1">{profile?.email}</Typography>
                </Grid>
                <Grid item xs={9}>
                  <Typography className={classes.groupTitle} variant="body2">
                    {T('Phone')}
                  </Typography>
                  <Typography variant="body1">
                    {profile?.phoneNumber}
                  </Typography>
                </Grid>
                <Grid item xs={9}>
                  <Typography className={classes.groupTitle} variant="body2">
                    {T('Role')}
                  </Typography>
                  <Typography variant="body1">
                    {T('RolesForDisplay')[role]}
                  </Typography>
                </Grid>
              </Grid>
            </Grid>
          </Grid>
        </div>
      )}
    </Paper>
  )
}

export default ProfileDetails
