import React, { useState, useEffect, useContext } from 'react'
import { useMutation, useQuery } from '@apollo/client'
import {
  CREATE_USER,
  USER_PROFILE_FRAGMENT,
  UPDATE_USER,
} from '~/lib/queries/users'
import { GET_AGENCIES } from '~/lib/queries/agencies'
import { NotificationContext } from '~/components/Contexts/NotificationContext'
import { useValidator } from '~/lib/validators'
import AsyncSearchSelect from '~/components/CustomFields/AsyncSearchSelect'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button'
import Dialog from '@material-ui/core/Dialog'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import Alert from '@material-ui/lab/Alert'
import MenuItem from '@material-ui/core/MenuItem'
import CircularProgress from '@material-ui/core/CircularProgress'
import { RolesForCreateDictionary } from '~/lib/assets/copy'
import { Typography } from '@material-ui/core'
import { useGenericFormStyles } from '~/components/Forms/Form.styles'
import {
  updateCache,
  formatPhoneNumber,
  trimStringsInObject,
} from '~/lib/utils'
import T from '~/lib/text'
import rules from './UserForm.rules'

const rolesByBackend = Object.keys(RolesForCreateDictionary)

export const emptyFormState = {
  firstName: '',
  lastName: '',
  email: '',
  phoneNumber: '',
  role: rolesByBackend[0],
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
function UserForm({ show, handleClose, initialState }) {
  const [formState, setFormState] = useState(emptyFormState)
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
  // // mutation for creating
  const [
    createUser,
    { loading: createLoading, data: createData, error: createError },
  ] = useMutation(CREATE_USER, {
    update(cache, { data: { createUser } }) {
      // updates the cache when a resource is created
      updateCache('users', createUser, cache, USER_PROFILE_FRAGMENT)
    },
  })

  const [
    updateUser,
    { loading: updateLoading, data: updateData, error: updateError },
  ] = useMutation(UPDATE_USER)

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
      return
    }
    const payload = {
      input: {
        firstName: formState.firstName,
        lastName: formState.lastName,
        email: formState.email,
        phoneNumber: formatPhoneNumber(formState.phoneNumber),
      },
    }

    if (isUpdate) {
      payload.input.id = initialState.cognitoId
      updateUser({
        variables: trimStringsInObject(payload),
      })
    } else {
      // if they arent a "FOSTERSHARE" admin, add their agencyId
      payload.input.role = formState?.role
      if (formState.role !== rolesByBackend[0]) {
        payload.input.agencyId = formState?.agencyId
      }

      createUser({ variables: trimStringsInObject(payload) })
    }
  }

  function handleChange(e) {
    const el = e.target
    const val = el.value
    setFormState({ ...formState, [el.id]: val })
  }

  function handleSelectChange(e) {
    const { name, value } = e.target
    setFormState({ ...formState, [name]: value })
  }

  function handleAsyncChange(id, v) {
    setFormState({ ...formState, [id]: v })
  }

  function close() {
    setShowErrors(false)
    if (!isUpdate) setFormState(emptyFormState)
    handleClose()
  }

  /*     _      _
   *  __| |__ _| |_ __ _   _ __ _ _ ___ _ __
   * / _` / _` |  _/ _` | | '_ \ '_/ -_) '_ \
   * \__,_\__,_|\__\__,_| | .__/_| \___| .__/
   *                      |_|          |_|
   **/

  const loading = createLoading || updateLoading
  const error = createError || updateError
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
    if (updateData && !loading) {
      close()
      notificationState.set({
        open: true,
        message: T('Updated'),
      })
    }
  }, [loading, updateData])

  useEffect(() => {
    if (createData && !loading) {
      close()
      notificationState.set({
        open: true,
        message: T('Created'),
      })
    }
  }, [loading, createData])

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

  useEffect(() => {
    setFormState({ ...emptyFormState, ...(initialState || {}) })
  }, [initialState])

  const classes = useGenericFormStyles()
  return (
    <Dialog
      open={show}
      onClose={close}
      aria-labelledby="create-resource-dialog"
    >
      <form onSubmit={handleSubmit} autoComplete="off">
        <DialogContent>
          <Typography variant="h3" className={classes.title}>
            {isUpdate ? T('HeaderUpdate') : T('HeaderCreate')}
          </Typography>
          {!!error && (
            <Alert severity="error">
              {error.message ?? JSON.stringify(error)}
            </Alert>
          )}
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
              disabled={loading}
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
              disabled={loading}
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
              disabled={loading}
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
              disabled={loading}
            />
            {!isUpdate && (
              <>
                <TextField
                  className={classes.field}
                  name="role"
                  id="Role"
                  required
                  variant="outlined"
                  label={T('Role')}
                  select={true}
                  value={formState.role || ''}
                  onChange={handleSelectChange}
                  disabled={loading}
                >
                  {Object.entries(RolesForCreateDictionary).map(
                    ([key, value]) => (
                      <MenuItem key={key} value={key}>
                        {value}
                      </MenuItem>
                    )
                  )}
                </TextField>
                <AsyncSearchSelect
                  id="agency_id"
                  className={classes.field}
                  query={GET_AGENCIES}
                  label={T('Agency')}
                  required={formState.roles !== rolesByBackend[0]}
                  dataAccessor={(v) => v?.agencies?.items || []}
                  labelAccessor={(v) => v?.name || ''}
                  onSelect={(v) => handleAsyncChange('agencyId', v?.id || '')}
                  value={{ id: formState?.agencyId || '' }}
                  pageInfoAccessor={(v) => v?.agencies?.pageInfo}
                  disabled={loading || formState.role === rolesByBackend[0]}
                />
              </>
            )}
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
            {isUpdate ? T('Update') : T('Submit')}
          </Button>
        </DialogActions>
      </form>
    </Dialog>
  )
}

export default UserForm
