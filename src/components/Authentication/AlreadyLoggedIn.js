import React from 'react'
import useStyles from './Login.styles'
import Grid from '@material-ui/core/Grid'
import Typography from '@material-ui/core/Typography'
import Button from '@material-ui/core/Button'
import T from '~/lib/text'

function AlreadyLoggedIn({ userEmail, router, authState }) {
  const classes = useStyles()
  return (
    <Grid item xs={12}>
      <Typography variant="body1">
        {T('AlreadyLoggedIn')} {userEmail}
      </Typography>
      <Button
        className={classes.loggedInButton}
        variant="contained"
        color="primary"
        onClick={() => router.push('/dashboard')}
      >
        {T('ToDashboard')}
      </Button>
      <Button
        className={classes.loggedInButton}
        variant="contained"
        color="secondary"
        onClick={authState.logout}
      >
        {T('ReLogin')}
      </Button>
    </Grid>
  )
}

export default AlreadyLoggedIn
