import React, { useState, useEffect, useContext } from 'react'
import { useMutation, useQuery } from '@apollo/client'
import {
  CREATE_AGENT,
  USER_PROFILE_FRAGMENT,
  UPDATE_AGENT,
} from '~/lib/queries/users'
import { NotificationContext } from '~/components/Contexts/NotificationContext'
import { useValidator } from '~/lib/validators'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button'
import MenuItem from '@material-ui/core/MenuItem'
import Dialog from '@material-ui/core/Dialog'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import Typography from '@material-ui/core/Typography'
import Alert from '@material-ui/lab/Alert'
import CircularProgress from '@material-ui/core/CircularProgress'
import PropTypes from 'prop-types'
import {
  updateCache,
  formatPhoneNumber,
  trimStringsInObject,
} from '~/lib/utils'
import { useGenericFormStyles } from '~/components/Forms/Form.styles'
import T from '~/lib/text'
import rules from './AgencyUserForm.rules'

export const emptyFormState = {
  firstName: '',
  lastName: '',
  email: '',
  phoneNumber: '',
  agencyId: '',
  // role: '',
}

function AngecyUserForm({ show, handleClose, initialState }) {
  const [formState, setFormState] = useState(emptyFormState)
  const notificationState = useContext(NotificationContext)
  const isUpdate = initialState && Object.keys(initialState).length > 0
  const { showErrors, setShowErrors, validation } = useValidator(
    formState,
    rules
  )
  /*               __       __  _
   *   __ _  __ __/ /____ _/ /_(_)__  ___
   *  /  ' \/ // / __/ _ `/ __/ / _ \/ _ \
   * /_/_/_/\_,_/\__/\_,_/\__/_/\___/_//_/
   *
   **/

  // // mutation for creating
  const [
    createAgent,
    { loading: createLoading, data: createData, error: createError },
  ] = useMutation(CREATE_AGENT, {
    update(cache, { data: { createAgent } }) {
      // updates the cache when a resource is created
      updateCache('agents', createAgent, cache, USER_PROFILE_FRAGMENT)
    },
  })

  const [
    updateUser,
    { loading: updateLoading, data: updateData, error: updateError },
  ] = useMutation(UPDATE_AGENT)

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
    // check validation
    if (validation.fails()) {
      setShowErrors(true)
    } else {
      // create payload
      const payload = {
        input: {
          firstName: formState?.firstName,
          lastName: formState?.lastName,
          email: formState?.email,
          phoneNumber: formatPhoneNumber(formState?.phoneNumber),
          // role: formState?.role,
        },
      }
      if (isUpdate) {
        // if it is an update add the ID of the agent to update
        payload.input.id = parseInt(initialState.id)
        updateUser({
          variables: trimStringsInObject(payload),
        })
      } else {
        // otherwise create it
        createAgent({ variables: trimStringsInObject(payload) })
      }
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

  // updates formState if initialState changes
  useEffect(() => {
    setFormState({ ...formState, ...initialState })
  }, [initialState])

  // listener to close dialog box
  useEffect(() => {
    // closes the dialog if the update/create is done
    if ((createData || updateData) && !loading) {
      close()
    }

    // notifications that the process was complete
    if (createData && !loading) {
      notificationState.set({
        open: true,
        message: T('Invited'),
      })
    } else if (updateData && !loading) {
      notificationState.set({
        open: true,
        message: T('Updated'),
      })
    }
  }, [loading, createData, updateData])

  // logs errors
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
      aria-labelledby="create-resource-dialog"
    >
      <form onSubmit={handleSubmit} autoComplete="off">
        <DialogContent>
          <Typography className={classes.title} variant="h3">
            {isUpdate ? T('HeaderUpdate') : T('HeaderCreate')}
          </Typography>
          {!!error && (
            <Alert severity="error">
              {error.message ?? JSON.stringify(error)}
            </Alert>
          )}
          <div className="create-update-agent-form">
            <TextField
              className={classes.field}
              id="firstName"
              required
              disabled={loading}
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
              disabled={loading}
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
              disabled={loading}
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
              disabled={loading}
              variant="outlined"
              label={T('Phone')}
              value={formState.phoneNumber}
              onChange={handleChange}
              error={!!(showErrors && validation.errors.first('phoneNumber'))}
              helperText={showErrors && validation.errors.first('phoneNumber')}
            />
            {/* <TextField
              className={classes.field}
              name="role"
              id="Role"
              required
              variant="outlined"
              label={T('Role')}
              select={true}
              value={formState.role}
              onChange={handleSelectChange}
              disabled={loading}
            >
              {[T('Admin'), T('Agent')].map((name) => (
                <MenuItem key={name} value={name}>
                  {name}
                </MenuItem>
              ))}
            </TextField> */}
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
            variant="contained"
            color="primary"
            type="submit"
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

AngecyUserForm.propTypes = {
  show: PropTypes.bool.isRequired,
  handleClose: PropTypes.func.isRequired,
  initialState: PropTypes.object,
}

export default AngecyUserForm
