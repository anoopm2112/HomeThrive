/**
 * NOTE!: 02/05/21 - This has been adapted to the ResetPassword Component.
 * This is remaining here for a changing password component that will need to live
 * on the users profile page in the future.
 */
import React, { useState, useContext } from 'react'
import axios from 'axios'
import Grid from '@material-ui/core/Grid'
import Typography from '@material-ui/core/Typography'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button'
import Visibility from '@material-ui/icons/Visibility'
import VisibilityOff from '@material-ui/icons/VisibilityOff'
import Alert from '@material-ui/lab/Alert'
import { AuthContext } from '~/components/Contexts/AuthContext'
import CircularProgress from '@material-ui/core/CircularProgress'
import { trimStringsInObject } from '~/lib/utils'
import T from '~/lib/text'

function ChangePassword() {
  // state of controlled components in the form
  const [formState, setFormState] = useState({
    originalPassword: '',
    changePassword: '',
    changeConfirmPassword: '',
    showOriginalPassword: false,
    showPassword: false,
    validation: {},
  })

  // state of the form submitting
  const [submissionState, setSubmissionState] = useState({
    loading: false,
    error: false,
  })

  // parent authentication state that is passed through the entire app
  const authState = useContext(AuthContext)

  // sets the visibility of the password
  function toggleVisibility(type) {
    console.log(type)
    setFormState({ ...formState, [type]: !formState[type] })
  }

  // handles the change of the components as they are typed in
  function handleChange(e) {
    setFormState({
      ...formState,
      [e.target.id]: e.target.value,
    })
  }

  // validates the inputs in the fields
  function validate() {
    const result = {}
    if (!formState.originalPassword) {
      result.originalPassword = T('OriginalPasswordRequired')
    }
    if (!formState.changePassword) {
      result.changePassword = T('PasswordRequired')
    }
    if (!formState.changeConfirmPassword) {
      result.changeConfirmPassword = T('ConfirmationPasswordRequired')
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
        setSubmissionState({ ...submissionState, loading: true })
        const r = await axios({
          method: 'post',
          url: '/api/user',
          data: trimStringsInObject(formState),
        })
        /**
         * TODO:
         * Update this so that it is actually saving an re-login the user
         */
        // console.log(r.data)
      }
    } catch (err) {
      console.log('Submission Error', err)
      setSubmissionState({
        loading: false,
        error: err.response?.data?.message || T('DefaultErrorMessage'),
      })
    }
  }

  const { loading, error } = submissionState

  return (
    <div className="login">
      <Grid container>
        <Grid item xs={12}>
          <Typography variant="body1">{T('ChangePasswordHeading')}</Typography>
          {!!error && <Alert severity="error">{error}</Alert>}
        </Grid>
        <form
          className={`change-password-form`}
          noValidate
          autoComplete="off"
          onSubmit={handleSubmit}
        >
          <TextField
            id="originalPassword"
            variant="outlined"
            placeholder="old password"
            size="small"
            required
            value={formState.originalPassword}
            type={formState.showOriginalPassword ? 'text' : 'password'}
            onChange={handleChange}
            error={!!formState.validation?.originalPassword}
            helperText={formState.validation?.originalPassword || ''}
            disabled={loading}
            InputProps={{
              endAdornment: (
                <div onClick={() => toggleVisibility('showOriginalPassword')}>
                  {formState.showOriginalPassword ? (
                    <Visibility />
                  ) : (
                    <VisibilityOff />
                  )}
                </div>
              ),
            }}
          />
          <TextField
            id="changePassword"
            variant="outlined"
            placeholder="Password"
            size="small"
            required
            value={formState.changePassword}
            type={formState.showPassword ? 'text' : 'password'}
            onChange={handleChange}
            error={!!formState.validation?.changePassword}
            helperText={formState.validation?.changePassword || ''}
            disabled={loading}
            InputProps={{
              endAdornment: (
                <div onClick={() => toggleVisibility('showPassword')}>
                  {formState.showPassword ? <Visibility /> : <VisibilityOff />}
                </div>
              ),
            }}
          />
          <TextField
            id="changeConfirmPassword"
            variant="outlined"
            placeholder="Confirm Password"
            size="small"
            required
            value={formState.changeConfirmPassword}
            type={formState.showPassword ? 'text' : 'password'}
            onChange={handleChange}
            error={!!formState.validation?.changeConfirmPassword}
            helperText={formState.validation?.changeConfirmPassword || ''}
            disabled={loading}
          />
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
        </form>
      </Grid>
    </div>
  )
}

export default ChangePassword
