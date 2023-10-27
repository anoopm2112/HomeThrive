import React, { useState, useEffect, useContext } from 'react'
import { useMutation } from '@apollo/client'
import {
  CREATE_AGENCY,
  UPDATE_AGENCY,
  UPDATE_AGENCY_PROFILE,
  AGENCY_FRAGMENT_SHALLOW,
} from '~/lib/queries/agencies'
import { NotificationContext } from '~/components/Contexts/NotificationContext'
import { useValidator } from '~/lib/validators'
import StateList from '~/lib/assets/lists/StateList'
import Typography from '@material-ui/core/Typography'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button'
import Alert from '@material-ui/lab/Alert'
import Grid from '@material-ui/core/Grid'
import Dialog from '@material-ui/core/Dialog'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import MenuItem from '@material-ui/core/MenuItem'
import CircularProgress from '@material-ui/core/CircularProgress'
import PropTypes from 'prop-types'
import { updateCache, trimStringsInObject } from '~/lib/utils'
import { useGenericFormStyles } from '~/components/Forms/Form.styles'
import T from '~/lib/text'
import rules from './AgencyForm.rules'

const emptyFormState = {
  name: '',
  address: '',
  city: '',
  state: '',
  zip: '',
  license: '',
  calendarLink: '',
  pocFirstName: '',
  pocLastName: '',
  pocEmail: '',
  pocTitle: '',
  pocPhone: '',
}

//  __  __   _   ___ _  _
// |  \/  | /_\ |_ _| \| |
// | |\/| |/ _ \ | || .` |
// |_|  |_/_/ \_\___|_|\_|
//
function AgencyForm({ show, handleClose, initialState, role, agencyId }) {
  const initialFormState = {
    ...emptyFormState,
    ...initialState,
  }

  const [formState, setFormState] = useState(initialFormState)
  const notificationState = useContext(NotificationContext)
  const isUpdate = Object.keys(initialState).length > 0
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

  const [
    createAgency,
    { loading: createLoading, data: createData, error: createError },
  ] = useMutation(CREATE_AGENCY, {
    update(cache, { data: { createAgency } }) {
      // updates the cache when a agency is created
      updateCache('agencies', createAgency, cache, AGENCY_FRAGMENT_SHALLOW)
    },
  })

  const UPDATE_QUERY = role === 0 ? UPDATE_AGENCY : UPDATE_AGENCY_PROFILE
  const [
    updateAgency,
    { loading: updateLoading, data: updateData, error: updateError },
  ] = useMutation(UPDATE_QUERY)

  /**
   *
   *  _                 _ _
   * | |_  __ _ _ _  __| | |___ _ _ ___
   * | ' \/ _` | ' \/ _` | / -_) '_(_-<
   * |_||_\__,_|_||_\__,_|_\___|_| /__/
   *
   */

  function handleChange(e) {
    const id = e.target.id
    const value = e.target.value
    setFormState({ ...formState, [id]: value })
  }

  function handleSelectChange(e) {
    const { name, value } = e.target
    setFormState({ ...formState, [name]: value })
  }

  // dont know why this is necessary but without it validation wont appear
  validation.passes()

  async function handleSubmit(e) {
    e.preventDefault()
    const data = formState
    if (validation.fails()) {
      setShowErrors(true)
    } else {
      const payload = {
        input: {
          name: data?.name,
          address: data?.address,
          city: data?.city,
          state: data?.state,
          zipCode: data?.zip,
          licenseNumber: data?.license,
          agencyCalendarUrl: data.calendarLink,
          poc: {
            firstName: data?.pocFirstName,
            lastName: data?.pocLastName,
            email: data?.pocEmail,
            title: data?.pocTitle,
            phoneNumber: data?.pocPhone,
          },
        },
      }

      if (isUpdate) {
        // cannot update the name of an agency
        delete payload.input.name
        if (role === 0) payload.input.id = agencyId
        updateAgency({
          variables: trimStringsInObject(payload),
        })
      } else {
        createAgency({ variables: trimStringsInObject(payload) })
      }
    }
  }

  function close() {
    setShowErrors(false)
    setFormState(initialFormState)
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
  const stateOptions = StateList.map(({ label, value }) => (
    <MenuItem value={value} key={value}>
      {label}
    </MenuItem>
  ))

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
    if ((createData || updateData) && !loading) {
      notificationState.set({
        open: true,
        message: T('SuccessfulCreate'),
      })
      close()
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
    if (updateData && !updateLoading && !updateError) {
      notificationState.set({
        open: true,
        message: T('SuccessfulUpdate'),
      })
      close(false)
    }
  }, [updateData, updateLoading, updateError])

  const classes = useGenericFormStyles()
  return (
    <Dialog
      maxWidth="md"
      open={show}
      onClose={close}
      aria-labelledby="create-agency-dialog"
    >
      <form onSubmit={handleSubmit} autoComplete="off">
        <DialogContent>
          <div className={`create-agency-form ${classes.root}`}>
            <Typography className={classes.title} variant="h3">
              {isUpdate ? T('UpdateAgency') : T('NewAgency')}
            </Typography>
            {!!error && <Alert severity="error">{error.message}</Alert>}
            <Grid container spacing={2}>
              <Grid item sm={12} md={6}>
                <Typography variant="h4">{T('AgencyInformation')}</Typography>
                <TextField
                  id="name"
                  className={classes.field}
                  variant="outlined"
                  label={T('AgencyLabel')}
                  required
                  value={formState.name}
                  onChange={handleChange}
                  error={!!(showErrors && validation.errors.first('name'))}
                  helperText={showErrors && validation.errors.first('name')}
                  disabled={loading || isUpdate}
                />
                <TextField
                  id="address"
                  className={classes.field}
                  variant="outlined"
                  label={T('Address')}
                  required
                  value={formState.address}
                  onChange={handleChange}
                  error={!!(showErrors && validation.errors.first('address'))}
                  helperText={showErrors && validation.errors.first('address')}
                  disabled={loading}
                />
                <TextField
                  id="city"
                  className={classes.field}
                  variant="outlined"
                  label={T('City')}
                  required
                  value={formState.city}
                  onChange={handleChange}
                  error={!!(showErrors && validation.errors.first('city'))}
                  helperText={showErrors && validation.errors.first('city')}
                  disabled={loading}
                />
                <TextField
                  select
                  className={classes.field}
                  id="state"
                  name="state"
                  required
                  variant="outlined"
                  label={T('State')}
                  value={formState.state}
                  onChange={handleSelectChange}
                  disabled={loading}
                >
                  {stateOptions}
                </TextField>
                <TextField
                  id="zip"
                  className={classes.field}
                  variant="outlined"
                  label={T('Zip')}
                  required
                  value={formState.zip}
                  onChange={handleChange}
                  error={!!(showErrors && validation.errors.first('zip'))}
                  helperText={showErrors && validation.errors.first('zip')}
                  disabled={loading}
                />
                <TextField
                  id="license"
                  className={classes.field}
                  variant="outlined"
                  label={T('AgencyLicense')}
                  required
                  value={formState.license}
                  onChange={handleChange}
                  error={!!(showErrors && validation.errors.first('license'))}
                  helperText={showErrors && validation.errors.first('license')}
                  disabled={loading}
                />
                <TextField
                  id="calendarLink"
                  className={classes.field}
                  variant="outlined"
                  label={T('CalendarLink')}
                  value={formState.calendarLink}
                  onChange={handleChange}
                  error={!!(showErrors && validation.errors.first('calendarLink'))}
                  helperText={showErrors && validation.errors.first('calendarLink')}
                  disabled={loading}
                />
              </Grid>
              <Grid item sm={12} md={6}>
                <Typography variant="h4">{T('ContactInformation')}</Typography>
                <TextField
                  id="pocFirstName"
                  className={classes.field}
                  variant="outlined"
                  label={T('FirstName')}
                  required
                  value={formState.pocFirstName}
                  onChange={handleChange}
                  error={
                    !!(showErrors && validation.errors.first('pocFirstName'))
                  }
                  helperText={
                    showErrors && validation.errors.first('pocFirstName')
                  }
                  disabled={loading}
                />
                <TextField
                  id="pocLastName"
                  className={classes.field}
                  variant="outlined"
                  label={T('LastName')}
                  required
                  value={formState.pocLastName}
                  onChange={handleChange}
                  error={
                    !!(showErrors && validation.errors.first('pocLastName'))
                  }
                  helperText={
                    showErrors && validation.errors.first('pocLastName')
                  }
                  disabled={loading}
                />
                <TextField
                  id="pocEmail"
                  className={classes.field}
                  variant="outlined"
                  label={T('Email')}
                  required
                  value={formState.pocEmail}
                  onChange={handleChange}
                  error={!!(showErrors && validation.errors.first('pocEmail'))}
                  helperText={showErrors && validation.errors.first('pocEmail')}
                  disabled={loading}
                />
                <TextField
                  id="pocTitle"
                  className={classes.field}
                  variant="outlined"
                  label={T('Title')}
                  required
                  value={formState.pocTitle}
                  onChange={handleChange}
                  error={!!(showErrors && validation.errors.first('pocTitle'))}
                  helperText={showErrors && validation.errors.first('pocTitle')}
                  disabled={loading}
                />
                <TextField
                  id="pocPhone"
                  className={classes.field}
                  variant="outlined"
                  label={T('Phone')}
                  required
                  value={formState.pocPhone}
                  onChange={handleChange}
                  error={!!(showErrors && validation.errors.first('pocPhone'))}
                  helperText={showErrors && validation.errors.first('pocPhone')}
                  disabled={loading}
                />
              </Grid>
            </Grid>
          </div>
        </DialogContent>
        <DialogActions>
          <Button onClick={close} color="primary">
            {T('Cancel')}
          </Button>
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
        </DialogActions>
      </form>
    </Dialog>
  )
}

AgencyForm.defaultProps = {
  initialState: {},
}

AgencyForm.propTypes = {
  show: PropTypes.bool.isRequired,
  handleClose: PropTypes.func.isRequired,
  initialState: PropTypes.object,
}

export default AgencyForm
