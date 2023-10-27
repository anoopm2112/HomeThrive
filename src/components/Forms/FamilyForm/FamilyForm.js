import React, { useState, useEffect, useContext } from 'react'
import { useLazyQuery, useMutation, useQuery } from '@apollo/client'
import {
  CREATE_FAMILY,
  FAMILY_FRAGMENT_SHALLOW,
  UPDATE_FAMILY,
} from '~/lib/queries/families'
import { GET_AGENTS } from '~/lib/queries/users'
import { NotificationContext } from '~/components/Contexts/NotificationContext'
import { useValidator } from '~/lib/validators'
import StateList from '~/lib/assets/lists/StateList'
import TextField from '@material-ui/core/TextField'
import Typography from '@material-ui/core/Typography'
import Button from '@material-ui/core/Button'
import Dialog from '@material-ui/core/Dialog'
import DialogActions from '@material-ui/core/DialogActions'
import Grid from '@material-ui/core/Grid'
import DialogContent from '@material-ui/core/DialogContent'
import AsyncSearchSelect from '~/components/CustomFields/AsyncSearchSelect'
import Alert from '@material-ui/lab/Alert'
import Divider from '@material-ui/core/Divider'
import MenuItem from '@material-ui/core/MenuItem'
import CircularProgress from '@material-ui/core/CircularProgress'
import Languages from '~/lib/assets/lists/Languages'
import {
  updateCache,
  formatPhoneNumber,
  trimStringsInObject,
} from '~/lib/utils'
import { useGenericFormStyles } from '~/components/Forms/Form.styles'
import T from '~/lib/text'
import rules from './FamilyForm.rules'

export const emptyFormState = {
  firstName: '',
  lastName: '',
  email: '',
  phoneNumber: '',
  address: '',
  city: '',
  state: '',
  zipCode: '',
  occupation: '',
  agentId: '',
  childId: '',
  licenseNumber: '',
  hasTwoParents: false,
  primaryLanguage: '',
  parent2FirstName: '',
  parent2LastName: '',
  parent2Email: '',
  parent2PhoneNumber: '',
  parent2Occupation: '',
}

/**
 * Creates or Updates a Family information
 *
 * This Registration form only works for FS Admins.
 * It requires a query to the Agency list, which is only available to FS Admins
 *
 * @returns
 */
function FamilyForm({ show, handleClose, initialState, agencyId }) {
  const [agentsResponse, setAgentsResponse] = useState([])
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
    createFamily,
    { loading: createLoading, data: createData, error: createError },
  ] = useMutation(CREATE_FAMILY, {
    update(cache, { data: { createFamily } }) {
      // updates the cache when a resource is created
      updateCache('families', createFamily, cache, FAMILY_FRAGMENT_SHALLOW)
    },
  })

  const [
    updateFamily,
    { loading: updateLoading, data: updateData, error: updateError },
  ] = useMutation(UPDATE_FAMILY)

  // console.log('PASSES', validation.passes(), showErrors)
  /**
   *
   *  _                 _ _
   * | |_  __ _ _ _  __| | |___ _ _ ___
   * | ' \/ _` | ' \/ _` | / -_) '_(_-<
   * |_||_\__,_|_||_\__,_|_\___|_| /__/
   *
   */
  // console.log('SHOW ERRORS', showErrors, validation.passes())
  validation.passes()
  // mutation for creating a resource
  function handleSubmit(e) {
    e.preventDefault()
    if (!validation.passes()) setShowErrors(true)
    else {
      const secondaryParents = formState.hasTwoParents
        ? [
            {
              id: formState.parent2Id,
              firstName: formState.parent2FirstName,
              lastName: formState.parent2LastName,
              email: formState.parent2Email,
              phoneNumber: formatPhoneNumber(formState.parent2PhoneNumber),
              occupation: formState.parent2Occupation,
            },
          ]
        : undefined
      const payload = {
        input: agencyId ? {
          firstName: formState?.firstName,
          lastName: formState?.lastName,
          occupation: formState?.occupation,
          email: formState?.email,
          phoneNumber: formatPhoneNumber(formState?.phoneNumber),
          agentId: parseInt(formState?.agentId),
          secondaryParents,
          city: formState?.city,
          state: formState?.state,
          zipCode: formState?.zipCode,
          licenseNumber: formState?.licenseNumber,
          primaryLanguage: formState?.primaryLanguage,
          address: formState?.address,
          agencyId: agencyId
        } : {
          firstName: formState?.firstName,
          lastName: formState?.lastName,
          occupation: formState?.occupation,
          email: formState?.email,
          phoneNumber: formatPhoneNumber(formState?.phoneNumber),
          agentId: parseInt(formState?.agentId),
          secondaryParents,
          city: formState?.city,
          state: formState?.state,
          zipCode: formState?.zipCode,
          licenseNumber: formState?.licenseNumber,
          primaryLanguage: formState?.primaryLanguage,
          address: formState?.address,
        },
      }

      if (isUpdate) {
        payload.input.id = initialState.id
        updateFamily({
          variables: trimStringsInObject(payload),
        })
      } else {
        createFamily({
          variables: trimStringsInObject(payload),
        })
      }
    }
  }

  function handleChange(e, v) {
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
  const canSubmit = agentsResponse?.agents?.pageInfo?.count !== 0
  const stateOptions = StateList.map(({ label, value }) => (
    <MenuItem value={value} key={value}>
      {label}
    </MenuItem>
  ))
  const languageOptions = Languages.map(([label, value]) => (
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

  // updates formState if initialState changes
  useEffect(() => {
    let hasTwoParents = false
    if (initialState?.parent2FirstName) hasTwoParents = true
    setFormState({ ...formState, ...initialState, hasTwoParents })
  }, [initialState])

  // listener to close dialog box
  useEffect(() => {
    if ((createData || updateData) && !loading) {
      close()
    }
    if (createData && !loading) {
      notificationState.set({
        open: true,
        message: T('SuccessfulCreate'),
      })
    } else if (updateData && !loading) {
      notificationState.set({
        open: true,
        message: T('SuccessfulUpdate'),
      })
    }
  }, [loading, createData, updateData])

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
      maxWidth="lg"
      open={show}
      onClose={close}
      aria-labelledby="create-family-dialog"
    >
      <form onSubmit={handleSubmit} autoComplete="off">
        <DialogContent>
          <Typography variant="h3">
            {isUpdate ? T('UpdateFamilyHeader') : T('CreateFamilyHeader')}
          </Typography>
          {!!error && (
            <Alert severity="error">
              {error.message ?? JSON.stringify(error)}
            </Alert>
          )}
          <div className="child-information">
            <Typography variant="h4">{T('FamilyFormHeader')}</Typography>
            <Grid container spacing={2}>
              <Grid item sm={12} md={6}>
                <TextField
                  size="small"
                  className={classes.field}
                  id="firstName"
                  required
                  variant="outlined"
                  label={T('Parent1FirstName')}
                  value={formState.firstName}
                  onChange={handleChange}
                  error={!!(showErrors && validation.errors.first('firstName'))}
                  helperText={
                    showErrors && validation.errors.first('firstName')
                  }
                  disabled={loading}
                />
                <TextField
                  size="small"
                  className={classes.field}
                  id="lastName"
                  required
                  variant="outlined"
                  label={T('Parent1LastName')}
                  value={formState.lastName}
                  onChange={handleChange}
                  error={!!(showErrors && validation.errors.first('lastName'))}
                  helperText={showErrors && validation.errors.first('lastName')}
                  disabled={loading}
                />
                <TextField
                  size="small"
                  className={classes.field}
                  id="occupation"
                  variant="outlined"
                  label={T('Parent1Occupation')}
                  value={formState.occupation}
                  onChange={handleChange}
                  error={
                    !!(showErrors && validation.errors.first('occupation'))
                  }
                  helperText={
                    showErrors && validation.errors.first('occupation')
                  }
                  disabled={loading}
                />
              </Grid>
              <Grid item sm={12} md={6}>
                <TextField
                  size="small"
                  className={classes.field}
                  id="email"
                  required
                  variant="outlined"
                  label={T('Parent1Email')}
                  value={formState.email}
                  onChange={handleChange}
                  error={!!(showErrors && validation.errors.first('email'))}
                  helperText={showErrors && validation.errors.first('email')}
                  disabled={loading}
                />
                <TextField
                  size="small"
                  className={classes.field}
                  id="phoneNumber"
                  required
                  variant="outlined"
                  label={T('Parent1Phone')}
                  value={formState.phoneNumber}
                  onChange={handleChange}
                  error={
                    !!(showErrors && validation.errors.first('phoneNumber'))
                  }
                  helperText={
                    showErrors && validation.errors.first('phoneNumber')
                  }
                  disabled={loading}
                />
                {!formState.hasTwoParents && (
                  <Button
                    className={classes.field}
                    variant="contained"
                    color="secondary"
                    disabled={loading}
                    onClick={() =>
                      setFormState({ ...formState, hasTwoParents: true })
                    }
                  >
                    Add Parent
                  </Button>
                )}
              </Grid>
            </Grid>
            {formState.hasTwoParents && (
              <Grid container spacing={2}>
                <Grid item sm={12} md={6}>
                  <TextField
                    size="small"
                    className={classes.field}
                    id="parent2FirstName"
                    required
                    variant="outlined"
                    label={T('Parent2FirstName')}
                    value={formState.parent2FirstName}
                    onChange={handleChange}
                    error={
                      showErrors && validation.errors.first('parent2FirstName')
                    }
                    helperText={
                      showErrors && validation.errors.first('parent2FirstName')
                    }
                    disabled={loading}
                  />
                  <TextField
                    size="small"
                    className={classes.field}
                    id="parent2LastName"
                    required
                    variant="outlined"
                    label={T('Parent2LastName')}
                    value={formState.parent2LastName}
                    onChange={handleChange}
                    error={
                      showErrors && validation.errors.first('parent2LastName')
                    }
                    helperText={
                      showErrors && validation.errors.first('parent2LastName')
                    }
                    disabled={loading}
                  />
                  <TextField
                    size="small"
                    className={classes.field}
                    id="parent2Occupation"
                    variant="outlined"
                    label={T('Parent2Occupation')}
                    value={formState.parent2Occupation}
                    onChange={handleChange}
                    error={
                      showErrors && validation.errors.first('parent2Occupation')
                    }
                    helperText={
                      showErrors && validation.errors.first('parent2Occupation')
                    }
                    disabled={loading}
                  />
                </Grid>
                <Grid item sm={12} md={6}>
                  <TextField
                    size="small"
                    className={classes.field}
                    id="parent2Email"
                    required
                    variant="outlined"
                    label={T('Parent2Email')}
                    value={formState.parent2Email}
                    onChange={handleChange}
                    error={
                      showErrors && validation.errors.first('parent2Email')
                    }
                    helperText={
                      showErrors && validation.errors.first('parent2Email')
                    }
                    disabled={loading}
                  />
                  <TextField
                    size="small"
                    className={classes.field}
                    id="parent2PhoneNumber"
                    required
                    variant="outlined"
                    label={T('Parent2Phone')}
                    value={formState.parent2PhoneNumber}
                    onChange={handleChange}
                    error={
                      showErrors &&
                      validation.errors.first('parent2PhoneNumber')
                    }
                    helperText={
                      showErrors &&
                      validation.errors.first('parent2PhoneNumber')
                    }
                    disabled={loading}
                  />
                </Grid>
              </Grid>
            )}
            <Divider className={classes.divider} />

            <Typography variant="h4">{T('HouseholdInformation')}</Typography>
            <Grid container spacing={2}>
              <Grid item sm={12} md={6}>
                <TextField
                  size="small"
                  className={classes.field}
                  id="address"
                  required
                  variant="outlined"
                  label={T('Address')}
                  value={formState.address}
                  onChange={handleChange}
                  error={!!(showErrors && validation.errors.first('address'))}
                  helperText={showErrors && validation.errors.first('address')}
                  disabled={loading}
                />
                <TextField
                  size="small"
                  className={classes.field}
                  id="city"
                  required
                  variant="outlined"
                  label={T('City')}
                  value={formState.city}
                  onChange={handleChange}
                  error={!!(showErrors && validation.errors.first('city'))}
                  helperText={showErrors && validation.errors.first('city')}
                  disabled={loading}
                />
                <TextField
                  select
                  size="small"
                  className={classes.field}
                  id="state"
                  required
                  name="state"
                  variant="outlined"
                  label={T('State')}
                  value={formState.state}
                  onChange={handleSelectChange}
                  disabled={loading}
                >
                  {stateOptions}
                </TextField>
              </Grid>
              <Grid item sm={12} md={6}>
                <TextField
                  size="small"
                  className={classes.field}
                  id="zipCode"
                  required
                  variant="outlined"
                  label={T('Zip')}
                  value={formState.zipCode}
                  onChange={handleChange}
                  error={!!(showErrors && validation.errors.first('zipCode'))}
                  helperText={showErrors && validation.errors.first('zipCode')}
                  disabled={loading}
                />
                <TextField
                  select
                  size="small"
                  className={classes.field}
                  id="primaryLanguage"
                  required
                  name="primaryLanguage"
                  variant="outlined"
                  label={T('Language')}
                  value={formState.primaryLanguage}
                  onChange={handleSelectChange}
                  disabled={loading}
                >
                  {languageOptions}
                </TextField>
              </Grid>
            </Grid>
            <Divider className={classes.divider} />
            <Typography variant="h4">Agency Information</Typography>
            <Grid container spacing={2}>
              <Grid item sm={12} md={6}>
                <TextField
                  className={classes.field}
                  id="licenseNumber"
                  required
                  variant="outlined"
                  label={T('License')}
                  value={formState.licenseNumber}
                  onChange={handleChange}
                  error={
                    !!(showErrors && validation.errors.first('licenseNumber'))
                  }
                  helperText={
                    showErrors && validation.errors.first('licenseNumber')
                  }
                  disabled={loading}
                />
              </Grid>
              <Grid item sm={12} md={6}>
                <AsyncSearchSelect
                  className={classes.field}
                  query={GET_AGENTS}
                  label={T('Agent')}
                  dataAccessor={(v) => v?.agents?.items}
                  pageInfoAccessor={(v) => v?.agents?.pageInfo}
                  labelAccessor={(v) => `${v.firstName} ${v.lastName}`}
                  onSelect={(v) => handleAsyncChange('agentId', v?.id || '')}
                  onSearchComplete={(d) => setAgentsResponse(d)}
                  required={true}
                  helperText={!canSubmit && T('CreateAgentFirst')}
                  defaultValue={
                    // if the agent exists, create a "replica" options object
                    // for which the search can display
                    initialState?.agentId && initialState?.agentName
                      ? {
                          id: initialState.agentId,
                          firstName: initialState.agentName,
                          lastName: '',
                        }
                      : undefined
                  }
                  disabled={loading}
                  agencyId={agencyId}
                  on
                />
              </Grid>
            </Grid>
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
            disabled={loading || !canSubmit}
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

export default FamilyForm
