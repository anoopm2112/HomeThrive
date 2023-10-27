import React, { useState, useContext, useEffect } from 'react'
import { useRouter } from 'next/router'
import Grid from '@material-ui/core/Grid'
import Typography from '@material-ui/core/Typography'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button'
import Alert from '@material-ui/lab/Alert'
import CircularProgress from '@material-ui/core/CircularProgress'
import { AuthContext } from '~/components/Contexts/AuthContext'
import { NotificationContext } from '~/components/Contexts/NotificationContext'
import useStyles from './Login.styles'
import clsx from 'clsx'
import T from '~/lib/text'
import {
  sendAccessCodeToVerifyEmail,
  verifyEmailWithAccessCode,
} from '~/lib/amplifyAuth'

function LoginAccessCode() {
  // state of controlled components in the form
  const [accessCode, setAccessCode] = useState('')
  const [sentEmail, setSentEmail] = useState(false)
  // parent authentication state that is passed through the entire app
  const authState = useContext(AuthContext)
  const notificationState = useContext(NotificationContext)
  const router = useRouter()

  // state of the form submitting
  const [submissionState, setSubmissionState] = useState({
    done: false,
    loading: false,
    error: false,
  })
  const { loading, error, done } = submissionState

  //  _                 _ _
  // | |_  __ _ _ _  __| | |___ _ _ ___
  // | ' \/ _` | ' \/ _` | / -_) '_(_-<
  // |_||_\__,_|_||_\__,_|_\___|_| /__/
  //
  // handles the change of the components as they are typed in
  function handleChange(e) {
    setAccessCode(e.target.value)
  }

  // submits the form
  async function handleSubmit(e) {
    e.preventDefault()
    try {
      setSubmissionState({ ...submissionState, loading: true })
      const r = await verifyEmailWithAccessCode(accessCode.trim())
      // console.log('R', r)
      if (r === 'SUCCESS') {
        notificationState.set({
          open: true,
          message: T('SuccessfulVerify'),
        })
        router.push('/dashboard')
      }
      setSubmissionState({ ...setSubmissionState, done: true })
    } catch (err) {
      setSubmissionState({
        ...submissionState,
        error: err,
        loading: false,
      })
    }
  }

  // const userEmail = authState?.user?.idToken?.payload?.email

  //  _ _    _
  // | (_)__| |_ ___ _ _  ___ _ _ ___
  // | | (_-<  _/ -_) ' \/ -_) '_(_-<
  // |_|_/__/\__\___|_||_\___|_| /__/
  //

  useEffect(() => {
    const send = async () => {
      // console.log('sending email')
      const r = await sendAccessCodeToVerifyEmail()
      setSentEmail(true)
    }

    if (!sentEmail) send()
  }, [sentEmail])

  const classes = useStyles()
  return (
    <div className="verify-email">
      <Grid container>
        <Grid item xs={12}>
          <Typography variant="h2">{T('Heading')}</Typography>
          <Typography variant="body1">{T('SubHeading')}</Typography>
          {!!error && <Alert severity="error">{error?.message}</Alert>}
        </Grid>
        <form
          className={classes.root}
          autoComplete="off"
          onSubmit={handleSubmit}
        >
          <Grid item xs={12} sm={8}>
            <TextField
              id="accessCode"
              className={classes.field}
              variant="outlined"
              label={T('AccessCodeLabel')}
              size="small"
              required
              value={accessCode}
              onChange={handleChange}
              disabled={loading}
            />
          </Grid>
          <Grid item className={classes.field}>
            <Button
              variant="contained"
              onClick={() => setSentEmail(false)}
              disabled={loading || done}
              endIcon={
                loading && (
                  <CircularProgress style={{ color: 'white' }} size={12} />
                )
              }
            >
              {T('ResendEmail')}
            </Button>
            <Button
              className={classes.spaceOut}
              color="primary"
              variant="contained"
              type="submit"
              disabled={loading || done}
              endIcon={
                loading && (
                  <CircularProgress style={{ color: 'white' }} size={12} />
                )
              }
            >
              {T('Submit')}
            </Button>
          </Grid>
        </form>
      </Grid>
    </div>
  )
}

export default LoginAccessCode
