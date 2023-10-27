import React, { useEffect, useState } from 'react'
import axios from 'axios'
import { FORGOT_PASSWORD } from '~/lib/queries/users'
import { useValidator } from '~/lib/validators'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button'
import Grid from '@material-ui/core/Grid'
import T from '~/lib/text'
import useStyles from './ForgotPassword.styles'
import CircularProgress from '@material-ui/core/CircularProgress'

function ForgotPasswordRequest({ onFinish, onError }) {
  const [email, setEmail] = useState('')
  const [loading, setLoading] = useState(false)
  const { showErrors, setShowErrors, validation } = useValidator(
    { email },
    {
      email: 'email',
    }
  )

  // _                 _ _
  // | |_  __ _ _ _  __| | |___ _ _ ___
  // | ' \/ _` | ' \/ _` |s / -_) '_(_-<
  // |_||_\__,_|_||_\__,_|_\___|_| /__/
  //

  // dont know why this is necessary but without it validation wont appear
  validation.passes()

  async function handleSubmit(e) {
    e.preventDefault()
    if (validation.fails()) {
      setShowErrors(true)
    } else {
      try {
        setLoading(true)
        const url = process.env.NEXT_PUBLIC_UNAUTHED_ENDPOINT
        const id = process.env.NEXT_PUBLIC_USER_POOL_WEB_CLIENT_ID

        const r = await axios({
          method: 'POST',
          url: url,
          data: {
            query: `mutation ForgotPassword($input: ForgotPasswordInput!) {
              forgotPassword(input: $input)
            }`,
            variables: {
              input: {
                clientId: id,
                email: email.trim(),
              },
            },
          },
          headers: {
            'Content-Type': 'application/json',
          },
        })

        console.log(r)
        if (!r.data?.data?.forgotPassword || r?.data.errors) {
          ;(r.data.errors || []).forEach((e) => console.error(e.message))
          throw new Error(r?.data?.errors[0].message)
        }
        onFinish({ email })
        onError()
      } catch (err) {
        console.error(err)
        onError(err)
      } finally {
        setLoading(false)
      }
    }
  }

  // useEffect(() => {
  //   if (!loading && data && !error) {
  //     onFinish(data)
  //   }
  // }, [loading, data, error])

  // console.log('LOADING', loading, data, error)

  const classes = useStyles()
  return (
    <form
      className={`forgot-password-form ${classes.root}`}
      autoComplete="off"
      onSubmit={handleSubmit}
    >
      <Grid item xs={8} sm={6}>
        <TextField
          id="email"
          className={classes.field}
          variant="outlined"
          label={T('Email')}
          required
          value={email}
          type="text"
          onChange={(e) => setEmail(e.target.value)}
          error={!!(showErrors && validation.errors.first('email'))}
          helperText={showErrors && validation.errors.first('email')}
          disabled={loading}
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
export default ForgotPasswordRequest
