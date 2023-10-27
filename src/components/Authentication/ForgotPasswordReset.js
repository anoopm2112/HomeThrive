import React, { useState, useContext, useEffect } from 'react'
import { useRouter } from 'next/router'
import { useValidator } from '~/lib/validators'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button'
import Grid from '@material-ui/core/Grid'
import Visibility from '@material-ui/icons/Visibility'
import VisibilityOff from '@material-ui/icons/VisibilityOff'
import T from '~/lib/text'
import useStyles from './ForgotPassword.styles'
import { forgotPasswordReset } from '~/lib/amplifyAuth'
import { NotificationContext } from '~/components/Contexts/NotificationContext'
import CircularProgress from '@material-ui/core/CircularProgress'

function ForgotPasswordReset({ email, onError }) {
  const [showPassword, setShowPassword] = useState(false)
  const [code, setCode] = useState('')
  const [password, setPassword] = useState('')
  const [confirmation, setConfirmation] = useState('')
  const [matches, setMatches] = useState(true)
  const { showErrors, setShowErrors, validation } = useValidator(
    { password, confirmation },
    {
      password: 'password',
      confirmation: 'password',
    }
  )

  // state of the form submitting
  const [loading, setLoading] = useState()

  const router = useRouter()
  const notificationState = useContext(NotificationContext)
  // _                 _ _
  // | |_  __ _ _ _  __| | |___ _ _ ___
  // | ' \/ _` | ' \/ _` | / -_) '_(_-<
  // |_||_\__,_|_||_\__,_|_\___|_| /__/
  //
  validation.passes()
  async function handleSubmit(e) {
    e.preventDefault()
    if (confirmation !== password) {
      setMatches(false)
    } else if (validation.fails()) {
      setShowErrors(true)
    } else {
      try {
        setLoading(true)
        const r = await forgotPasswordReset(
          email.trim(),
          code.trim(),
          password.trim()
        )
        console.log('RESPONSE', r)
        notificationState.set({
          ...notificationState,
          open: true,
          message: T('RedirectToLogin'),
        })
        setTimeout(() => router.push('/auth/login'), 1000)
      } catch (err) {
        setLoading(false)
        console.error(err)
        onError(err)
      }
    }
  }

  const passwordIsError =
    !matches || !!(showErrors && validation.errors.first('password'))
  const passwordHelpText = !matches
    ? 'Passwords must match'
    : showErrors && validation.errors.first('password')
  const confirmationIsError =
    !matches || !!(showErrors && validation.errors.first('confirmation'))
  const confirmationHelpText = !matches
    ? 'Passwords must match'
    : showErrors && validation.errors.first('confirmation')

  useEffect(() => {
    if (confirmation === password && !matches) setMatches(true)
  }, [confirmation, password])

  const classes = useStyles()
  return (
    <form
      className={`forgot-password-form ${classes.root}`}
      noValidate
      autoComplete="off"
      onSubmit={handleSubmit}
    >
      <Grid item xs={8} sm={6}>
        <TextField
          id="code"
          className={classes.field}
          variant="outlined"
          label={T('ConfirmationCode')}
          required
          value={code}
          type="text"
          onChange={(e) => setCode(e.target.value)}
          disabled={loading}
        />
      </Grid>
      <Grid item xs={8} sm={6}>
        <TextField
          id="password"
          className={classes.field}
          variant="outlined"
          label={T('NewPassword')}
          required
          value={password}
          type={showPassword ? 'text' : 'password'}
          onChange={(e) => setPassword(e.target.value)}
          error={passwordIsError}
          helperText={passwordHelpText}
          disabled={loading}
          InputProps={{
            endAdornment: (
              <div onClick={() => setShowPassword(!showPassword)}>
                {showPassword ? <Visibility /> : <VisibilityOff />}
              </div>
            ),
          }}
        />
      </Grid>
      <Grid item xs={8} sm={6}>
        <TextField
          id="confirmPassword"
          className={classes.field}
          variant="outlined"
          label={T('ConfirmNewPassword')}
          required
          value={confirmation}
          type={showPassword ? 'text' : 'password'}
          onChange={(e) => setConfirmation(e.target.value)}
          error={confirmationIsError}
          helperText={confirmationHelpText}
          disabled={loading}
          InputProps={{
            endAdornment: (
              <div onClick={() => setShowPassword(!showPassword)}>
                {showPassword ? <Visibility /> : <VisibilityOff />}
              </div>
            ),
          }}
        />
      </Grid>

      <Grid item className={classes.field} xs={8} sm={6}>
        <Button
          color="primary"
          variant="contained"
          type="submit"
          disabled={loading}
          endIcon={
            loading && <CircularProgress style={{ color: 'white' }} size={12} />
          }
        >
          {T('Submit')}
        </Button>
      </Grid>
    </form>
  )
}
export default ForgotPasswordReset
