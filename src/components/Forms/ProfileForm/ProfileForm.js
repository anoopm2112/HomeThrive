import React, { useState, useEffect, useContext } from 'react'
import { useMutation } from '@apollo/client'
import { UPDATE_PROFILE } from '~/lib/queries/users'
import { NotificationContext } from '~/components/Contexts/NotificationContext'
import { useValidator } from '~/lib/validators'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button'
import Dialog from '@material-ui/core/Dialog'
import Typography from '@material-ui/core/Typography'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import Alert from '@material-ui/lab/Alert'
import CircularProgress from '@material-ui/core/CircularProgress'
import { RolesForCreate } from '~/lib/assets/copy'
import { formatPhoneNumber, trimStringsInObject } from '~/lib/utils'
import { useGenericFormStyles } from '~/components/Forms/Form.styles'
import rules from './ProfileForm.rules'
import T from '~/lib/text'

export const emptyFormState = {
  firstName: '',
  lastName: '',
  email: '',
  phoneNumber: '',
  role: RolesForCreate[0],
  agencyId: '',
}

/**
 * Creates or Updates a Users information
 *
 * This Registration form only works for FS Admins.
 * It requires a query to the Agency list, which is only available to FS Admins
 *
 * @returns
 */
function ProfileForm({ show, handleClose, initialState }) {
  const [formState, setFormState] = useState({
    emptyFormState,
    ...initialState,
  })

  const notificationState = useContext(NotificationContext)
  const isUpdate = initialState && Object.keys(initialState).length > 0
  const { showErrors, setShowErrors, validation } = useValidator(
    formState,
    rules
  )
  /*                __       __  _
   *   __ _  __ __/ /____ _/ /_(_)__  ___
   *  /  ' \/ // / __/ _ `/ __/ / _ \/ _ \
   * /_/_/_/\_,_/\__/\_,_/\__/_/\___/_//_/
   *
   **/

  const [
    updateUser,
    { loading: updateLoading, data: updateData, error: updateError },
  ] = useMutation(UPDATE_PROFILE)

  /**
   *
   *  _                 _ _
   * | |_  __ _ _ _  __| | |___ _ _ ___
   * | ' \/ _` | ' \/ _` | / -_) '_(_-<
   * |_||_\__,_|_||_\__,_|_\___|_| /__/
   *
   */
  // dont know why this is necessary but without it validation wont appear
  validation.passes()

  // mutation for creating a resource
  function handleSubmit(e) {
    e.preventDefault()
    if (validation.fails()) {
      setShowErrors(true)
    } else {
      const payload = {
        input: {
          firstName: formState.firstName,
          lastName: formState.lastName,
          email: formState.email,
          phoneNumber: formatPhoneNumber(formState.phoneNumber),
        },
      }

      updateUser({
        variables: trimStringsInObject(payload),
      })
    }
  }

  function handleChange(e) {
    const el = e.target
    const val = el.value
    setFormState({ ...formState, [el.id]: val })
  }

  function close() {
    if (!isUpdate) setFormState(emptyFormState)
    handleClose()
  }

  /*     _      _
   *  __| |__ _| |_ __ _   _ __ _ _ ___ _ __
   * / _` / _` |  _/ _` | | '_ \ '_/ -_) '_ \
   * \__,_\__,_|\__\__,_| | .__/_| \___| .__/
   *                      |_|          |_|
   **/

  const loading = updateLoading
  const error = updateError

  /**
   *
   *  _ _    _
   * | (_)__| |_ ___ _ _  ___ _ _ ___
   * | | (_-<  _/ -_) ' \/ -_) '_(_-<
   * |_|_/__/\__\___|_||_\___|_| /__/
   *
   */

  // listener to close dialog box
  useEffect(() => {
    if (updateData && !updateLoading) {
      notificationState.set({
        open: true,
        message: T('Updated'),
      })
      handleClose()
    }
  }, [updateData, updateLoading])

  useEffect(() => {
    if (error) {
      console.log(
        'ERROR',
        error,
        Object.keys(error),
        error?.networkError?.result,
        error?.graphQLErrors
      )
    }
  }, [error])

  const classes = useGenericFormStyles()
  return (
    <Dialog
      open={show}
      onClose={close}
      title={T('Title')}
      aria-labelledby="create-resource-dialog"
    >
      <form onSubmit={handleSubmit} autoComplete="off">
        <DialogContent>
          {!!error && (
            <Alert severity="error">
              {error.message ?? JSON.stringify(error)}
            </Alert>
          )}
          <Typography variant="h3" className={classes.title}>
            {T('Title')}
          </Typography>
          <div className="register-form">
            <TextField
              className={classes.field}
              id="firstName"
              required
              variant="outlined"
              label={T('FirstName')}
              value={formState.firstName}
              onChange={handleChange}
              error={!!(showErrors && validation.errors.first('firstName'))}
              helperText={showErrors && validation.errors.first('firstName')}
            />
            <TextField
              className={classes.field}
              id="lastName"
              required
              variant="outlined"
              label={T('LastName')}
              value={formState.lastName}
              onChange={handleChange}
              error={!!(showErrors && validation.errors.first('lastName'))}
              helperText={showErrors && validation.errors.first('lastName')}
            />
            <TextField
              className={classes.field}
              id="email"
              required
              variant="outlined"
              label={T('Email')}
              value={formState.email}
              onChange={handleChange}
              error={!!(showErrors && validation.errors.first('email'))}
              helperText={showErrors && validation.errors.first('email')}
            />
            <TextField
              className={classes.field}
              id="phoneNumber"
              required
              variant="outlined"
              label={T('Phone')}
              value={formState.phoneNumber}
              onChange={handleChange}
              error={!!(showErrors && validation.errors.first('phoneNumber'))}
              helperText={showErrors && validation.errors.first('phoneNumber')}
            />
          </div>
        </DialogContent>
        <DialogActions>
          <Button
            variant="contained"
            color="secondary"
            onClick={close}
            disabled={loading}
          >
            {T('Cancel')}
          </Button>
          <Button
            type="submit"
            variant="contained"
            color="primary"
            disabled={loading}
            endIcon={
              loading && (
                <CircularProgress style={{ color: 'white' }} size={12} />
              )
            }
          >
            {T('UpdateProfile')}
          </Button>
        </DialogActions>
      </form>
    </Dialog>
  )
}

export default ProfileForm
