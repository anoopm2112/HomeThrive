import React, { useState } from 'react'
import Grid from '@material-ui/core/Grid'
import Typography from '@material-ui/core/Typography'
import Alert from '@material-ui/lab/Alert'
import T from '~/lib/text'
import ForgotPasswordReset from './ForgotPasswordReset'
import ForgotPasswordRequest from './ForgotPasswordRequest'

function ForgotPassword() {
  // state of controlled components in the form
  const [email, setEmail] = useState('')
  const [requestSubmitted, setRequestSubmitted] = useState(false)
  const [error, setError] = useState(false)

  return (
    <div className="forgot-password">
      <Grid container>
        <Grid item xs={12}>
          <Typography variant="h2">{T('ForgotPasswordHeading')}</Typography>
          <Typography variant="body1">
            {T('ForgotPasswordSubHeading')}
          </Typography>
          {!!error && (
            <Alert severity="error">
              {error?.message ? error.message : JSON.stringify(error)}
            </Alert>
          )}
        </Grid>
        {!requestSubmitted ? (
          <ForgotPasswordRequest
            onFinish={(v) => {
              setEmail(v.email)
              setRequestSubmitted(true)
            }}
            onError={(e) => setError(e)}
          />
        ) : (
          <ForgotPasswordReset email={email} onError={(e) => setError(e)} />
        )}
      </Grid>
    </div>
  )
}

export default ForgotPassword
