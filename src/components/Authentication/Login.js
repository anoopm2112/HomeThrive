import React, { useState, useContext } from 'react'
import { useRouter } from 'next/router'
import Grid from '@material-ui/core/Grid'
import Container from '@material-ui/core/Container'
import Hidden from '@material-ui/core/Hidden'
import Typography from '@material-ui/core/Typography'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button'
import Visibility from '@material-ui/icons/Visibility'
import VisibilityOff from '@material-ui/icons/VisibilityOff'
import Alert from '@material-ui/lab/Alert'
import CircularProgress from '@material-ui/core/CircularProgress'
import { AuthContext } from '~/components/Contexts/AuthContext'
import { NotificationContext } from '~/components/Contexts/NotificationContext'
import { trimStringsInObject } from '~/lib/utils'
import AlreadyLoggedIn from './AlreadyLoggedIn'
import useStyles from './Login.styles'
import T from '~/lib/text'

const emptyFormState = {
  email: '',
  password: '',
  confirmPassword: '',
  remember: false,
  showPassword: false,
  validation: {},
}

function Login() {
  // state of controlled components in the form
  const [formState, setFormState] = useState(emptyFormState)

  // state of the form submitting
  const [submissionState, setSubmissionState] = useState({
    needsEmailVerification: false,
    needsNewPassword: false,
    user: null,
    loading: false,
    error: false,
  })

  // router
  const router = useRouter()

  // parent authentication state that is passed through the entire app
  const authState = useContext(AuthContext)
  const notificationState = useContext(NotificationContext)

  // sets the visibility of the password
  function toggleVisibility() {
    setFormState({ ...formState, showPassword: !formState.showPassword })
  }

  // handles the change of the components as they are typed in
  function handleChange(e) {
    setFormState({
      ...formState,
      [e.target.id]:
        e.target.id === 'remember' ? e.target.checked : e.target.value,
    })
  }

  // validates the inputs in the fields
  function validate() {
    const result = {}
    if (!formState.email) {
      result.email = T('EmailIsRequired')
    }
    if (!formState.password) {
      result.password = T('PasswordRequired')
    }
    if (
      submissionState.needsNewPassword &&
      formState.password !== formState.confirmPassword
    ) {
      result.confirmPassword = T('PasswordsDontMatch')
    }
    setFormState({ ...formState, validation: result })
    return Object.keys(result).length === 0
  }

  // submits the form
  async function handleSubmit(e) {
    e.preventDefault()
    const isValid = validate()
    try {
      if (isValid) {
        setSubmissionState({
          ...submissionState,
          loading: true,
          needsNewPassword: false,
        })
        const { email, password } = trimStringsInObject(formState)
        const { user, needsNewPassword } = submissionState

        // set local-storage and context
        const r = await authState.login(email, password, needsNewPassword, user)
        const { success, message, data } = r

        // if they are a parent
        if (data && data.attributes && data.attributes['custom:role'] === '3') {
          // log them out, and raise error
          await authState.logout()
          notificationState.set({
            open: true,
            message: T('NotAllowed'),
          })
          setFormState(emptyFormState)
          setSubmissionState({ ...submissionState, loading: false })
          return
        }
        // checks to see if they need to reset password
        else if (!success && message === 'NEW_PASSWORD_REQUIRED') {
          setFormState({ ...formState, password: '' })
          return setSubmissionState({
            ...submissionState,
            user: data,
            loading: false,
            needsNewPassword: true,
          })
        } else if (!success && message !== 'NEW_PASSWORD_REQUIRED') {
          setFormState({ ...formState, password: '' })
          notificationState.set({
            open: true,
            message: message,
          })
          setSubmissionState({
            ...submissionState,
            error: false,
            loading: false,
          })
          return
        }

        setSubmissionState({ ...submissionState, error: false, loading: false })
        // reroute to dashboard
        notificationState.set({
          open: true,
          message: T('SuccessfulLogin'),
        })
        router.push('/dashboard')
      }
    } catch (err) {
      console.error('ERROR', err)
      setSubmissionState({
        ...submissionState,
        loading: false,
        error: err.message || err.response?.data?.message || T('DefaultError'),
      })
    }
  }

  const { loading, error } = submissionState
  const userEmail = authState?.user?.idToken?.payload?.email
  const classes = useStyles()

  return (
    <div className="login">
      <Grid style={{ position: 'relative', zIndex: 5 }}>
        <Grid item xs={12}>
        <Typography variant="h2" className={classes.newHeading}>Welcome to Foster Share</Typography>
        <Typography variant="h4" className={classes.newHeadingSub}>
          A revolutionary new phone-based app that is changing the way foster parents and case managers communicate.
        </Typography>
        <Typography variant="h4" className={classes.newSubHeading}>Easier Logging</Typography>
        <Typography variant="h4" className={classes.newSubHeading}>Resource Library</Typography>
        <Typography variant="h4" className={classes.newSubHeading}>Push Notifications</Typography>
        <Typography variant="h4" className={classes.newSubHeading}>{'Built-in Calendar & Scanner'}</Typography>
        <Typography variant="h4" className={classes.newSubHeading}>And so much more</Typography>
        </Grid>
        <Container maxWidth="sm" style={{ marginTop: '2rem', marginLeft: 0, paddingLeft: 0 }}>
        <Grid item xs={12} className={classes.loginDiv}>
          <Typography variant="h2" style={{fontFamily: 'Georgia', color: '#002244'}}>{T('LoginHeading')}</Typography>
          <Typography variant="body1" style={{color: '#002244'}}>{T('LoginSubHeading')}</Typography>
          {!!error && !submissionState.needsNewPassword && (
            <Alert severity="error">
              {error?.message || JSON.stringify(error)}
            </Alert>
          )}
          {submissionState.needsNewPassword && (
            <Alert severity="success">{T('AccountVerified')}</Alert>
          )}
        </Grid>
        {authState.isLoggedIn ? (
          <AlreadyLoggedIn
            router={router}
            userEmail={userEmail}
            authState={authState}
          />
        ) : (
          <form
            className={`login-form ${classes.root}`}
            noValidate
            autoComplete="off"
            onSubmit={handleSubmit}
          >
            <Grid item xs={12} sm={8}>
              <TextField
                id="email"
                className={classes.field}
                variant="outlined"
                label={T('Email')}
                size="small"
                required
                value={formState.email}
                onChange={handleChange}
                error={!!formState.validation?.email}
                helperText={formState.validation?.email || ''}
                disabled={loading}
              />
            </Grid>
            <Grid item xs={12} sm={8}>
              <TextField
                id="password"
                className={classes.field}
                variant="outlined"
                label={
                  formState.needsNewPassword
                    ? T('NewPasswordLabel')
                    : T('PasswordLabel')
                }
                size="small"
                required
                value={formState.password}
                type={formState.showPassword ? 'text' : 'password'}
                onChange={handleChange}
                error={!!formState.validation?.password}
                helperText={formState.validation?.password || ''}
                disabled={loading}
                InputProps={{
                  endAdornment: (
                    <div onClick={toggleVisibility}>
                      {formState.showPassword ? (
                        <Visibility />
                      ) : (
                        <VisibilityOff />
                      )}
                    </div>
                  ),
                }}
              />
            </Grid>
            {submissionState.needsNewPassword && (
              <Grid item xs={12} sm={8}>
                <TextField
                  id="confirmPassword"
                  className={classes.field}
                  variant="outlined"
                  label={T('ConfirmPasswordLabel')}
                  size="small"
                  required
                  value={formState.confirmPassword}
                  type={formState.showPassword ? 'text' : 'password'}
                  onChange={handleChange}
                  error={!!formState.validation?.confirmPassword}
                  helperText={formState.validation?.confirmPassword || ''}
                  disabled={loading}
                  InputProps={{
                    endAdornment: (
                      <div onClick={toggleVisibility}>
                        {formState.showPassword ? (
                          <Visibility />
                        ) : (
                          <VisibilityOff />
                        )}
                      </div>
                    ),
                  }}
                />
              </Grid>
            )}
            <Grid item container xs={12}>
              {/* <Grid item xs={6} sm={4}>
                <FormGroup>
                  <FormControlLabel
                    control={
                      <Checkbox
                        disabled={loading}
                        id="remember"
                        checked={formState.remember}
                        onChange={handleChange}
                        name="remember"
                        color="primary"
                      />
                    }
                    label={T("Remember")}
                  />
                </FormGroup>
              </Grid> */}
              <Grid item xs={6} sm={4}>
                <Button href="/auth/forgot-password" color="primary">
                  {T('Forgot')}
                </Button>
              </Grid>
            </Grid>
            <Grid item className={classes.field}>
              <Button
                color="primary"
                variant="contained"
                type="submit"
                disabled={loading}
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
        )}
        </Container>
      </Grid>
      <Hidden xsDown>
        <img
          className={authState.isLoggedIn ? classes.loggedFamilyImage : classes.familyImage}
          src="/images/Family.png"
          alt="Resource Image"
        />
      </Hidden>
    </div>
  )
}

export default Login
