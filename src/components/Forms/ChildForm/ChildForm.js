import React, { useState, useEffect, useContext } from 'react'
import { useLazyQuery, useMutation, useQuery } from '@apollo/client'
import {
  CREATE_CHILD,
  CHILD_FRAGMENT_DEEP,
  UPDATE_CHILD,
} from '~/lib/queries/children'
import { GET_AGENTS } from '~/lib/queries/users'
import { GET_FAMILIES } from '~/lib/queries/families'
import { NotificationContext } from '~/components/Contexts/NotificationContext'
import { useValidator, checkForPastDateErrors } from '~/lib/validators'
import TextField from '@material-ui/core/TextField'
import Typography from '@material-ui/core/Typography'
import Button from '@material-ui/core/Button'
import Dialog from '@material-ui/core/Dialog'
import DialogActions from '@material-ui/core/DialogActions'
import Grid from '@material-ui/core/Grid'
import DialogContent from '@material-ui/core/DialogContent'
import AsyncSearchSelect from '~/components/CustomFields/AsyncSearchSelect'
import Alert from '@material-ui/lab/Alert'
import MenuItem from '@material-ui/core/MenuItem'
import Divider from '@material-ui/core/Divider'
import CircularProgress from '@material-ui/core/CircularProgress'
import PropTypes from 'prop-types'
import { updateCache, trimStringsInObject } from '~/lib/utils'
import { useGenericFormStyles } from '~/components/Forms/Form.styles'
import T from '~/lib/text'
import rules from './ChildForm.rules'

export const emptyFormState = {
  firstName: '',
  lastName: '',
  agentId: '',
  familyId: '',
  placementId: '',
  medicaidNumber: '',
  notes: '',
  dateOfBirth: '',
  parentId: '',
  fosterCareStartDate: '',
  level: 'BASIC',
}

/**
 * Creates or Updates a Users information
 *
 * This Registration form only works for FS Admins.
 * It requires a query to the Agency list, which is only available to FS Admins
 *
 * @returns
 */
function ChildForm({ show, handleClose, initialState, agencyId }) {
  const [formState, setFormState] = useState(emptyFormState)
  const notificationState = useContext(NotificationContext)
  const isUpdate = initialState && Object.keys(initialState).length > 0
  const { showErrors, setShowErrors, validation } = useValidator(
    formState,
    rules
  )

  const dateErrors = checkForPastDateErrors(formState.dateOfBirth)

  /*                __       __  _
   *   __ _  __ __/ /____ _/ /_(_)__  ___
   *  /  ' \/ // / __/ _ `/ __/ / _ \/ _ \
   * /_/_/_/\_,_/\__/\_,_/\__/_/\___/_//_/
   *
   **/

  // // mutation for creating
  const [
    createChild,
    { loading: createLoading, data: createData, error: createError },
  ] = useMutation(CREATE_CHILD, {
    update(cache, { data: { createChild } }) {
      // updates the cache when a resource is created
      updateCache('children', createChild, cache, CHILD_FRAGMENT_DEEP)
    },
  })

  const [
    updateChild,
    { loading: updateLoading, data: updateData, error: updateError },
  ] = useMutation(UPDATE_CHILD)

  /**
   *
   *  _                 _ _
   * | |_  __ _ _ _  __| | |___ _ _ ___
   * | ' \/ _` | ' \/ _` | / -_) '_(_-<
   * |_||_\__,_|_||_\__,_|_\___|_| /__/
   *
   */

  // mutation for creating a resource
  function handleSubmit(e) {
    e.preventDefault()
    if (validation.fails() || dateErrors) {
      setShowErrors(true)
    } else {
      const payload = agencyId ? {
        firstName: formState.firstName,
        lastName: formState.lastName,
        dateOfBirth: formState.dateOfBirth,
        agentId: parseInt(formState.agentId) || undefined,
        fosterCareStartDate: formState.fosterCareStartDate,
        level: formState.level,
        placementId: formState.placementId,
        medicaidNumber: formState.medicaidNumber,
        notes: formState.notes,
        parentId: parseInt(formState.parentId) || undefined,
        agencyId: agencyId
      } : {
        firstName: formState.firstName,
        lastName: formState.lastName,
        dateOfBirth: formState.dateOfBirth,
        agentId: parseInt(formState.agentId) || undefined,
        fosterCareStartDate: formState.fosterCareStartDate,
        level: formState.level,
        placementId: formState.placementId,
        medicaidNumber: formState.medicaidNumber,
        notes: formState.notes,
        parentId: parseInt(formState.parentId) || undefined,
      }
      if (isUpdate) {
        updateChild({
          variables: {
            input: { id: initialState.id, ...trimStringsInObject(payload) },
          },
        })
      } else {
        createChild({
          variables: { input: trimStringsInObject(payload) },
        })
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

  function handleAsyncChange(id, v) {
    const updatedFormState = v ? { ...formState, [id]: v } : { ...formState, [id]: v, level: null, placementId: null, fosterCareStartDate: null, medicaidNumber: null }
    setFormState(updatedFormState)
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

  // const agencies = data?.agencies?.items || []
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

  // dont know why this is necessary but without it validation wont appear
  validation.passes()

  // updates formState if initialState changes
  useEffect(() => {
    setFormState({ ...formState, ...initialState })
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
      maxWidth="md"
      open={show}
      onClose={close}
      aria-labelledby="create-child-dialog"
    >
      <form onSubmit={handleSubmit} autoComplete="off">
        <DialogContent>
          {!!error && (
            <Alert severity="error">
              {error.message ?? JSON.stringify(error)}
            </Alert>
          )}
          <Typography variant="h3" className={classes.title}>
            {isUpdate ? T('Update') : T('Create')}
          </Typography>
          <div className="child-information">
            <Typography variant="h4">{T('FormHeader')}</Typography>
            <Grid container spacing={2}>
              <Grid item sm={12} md={6}>
                <TextField
                  className={classes.field}
                  id="firstName"
                  required
                  variant="outlined"
                  label={T('FirstName')}
                  value={formState.firstName}
                  onChange={handleChange}
                  error={!!(showErrors && validation.errors.first('firstName'))}
                  helperText={
                    showErrors && validation.errors.first('firstName')
                  }
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
              </Grid>
              <Grid item sm={12} md={6}>
                <TextField
                  className={classes.field}
                  id="dateOfBirth"
                  required
                  variant="outlined"
                  label={T('BirthDate')}
                  type="date"
                  onChange={handleChange}
                  value={formState.dateOfBirth}
                  error={
                    !!(
                      showErrors &&
                      (validation.errors.first('dateOfBirth') || dateErrors)
                    )
                  }
                  helperText={
                    showErrors &&
                    (validation.errors.first('dateOfBirth') || dateErrors)
                  }
                  InputLabelProps={{
                    shrink: true,
                  }}
                  disabled={loading}
                />
                <AsyncSearchSelect
                  className={classes.field}
                  required
                  query={GET_AGENTS}
                  label={T('Agent')}
                  dataAccessor={(v) => v?.agents?.items}
                  pageInfoAccessor={(v) => v?.agents?.pageInfo}
                  labelAccessor={(v) => `${v.lastName}, ${v.firstName}`}
                  onSelect={(v) => handleAsyncChange('agentId', v?.id || '')}
                  limit={5}
                  defaultValue={
                    initialState?.agentId && initialState?.agentName
                      ? {
                          id: initialState.agentId,
                          firstName: initialState.agentName.split(' ')[0],
                          lastName: initialState.agentName.split(' ')[1],
                        }
                      : undefined
                  }
                  disabled={loading}
                  agencyId={agencyId}
                />
              </Grid>
            </Grid>
            <Divider className={classes.divider} />
            <Typography variant="h4">{T('PlacementInformation')}</Typography>
            <Grid container spacing={2}>
              <Grid item sm={12} md={6}>
                <AsyncSearchSelect
                  className={classes.field}
                  query={GET_FAMILIES}
                  label={T('Family')}
                  dataAccessor={(v) => v?.families?.items}
                  pageInfoAccessor={(v) => v?.families?.pageInfo}
                  labelAccessor={(v) => `${v.lastName}, ${v.firstName}`}
                  onSelect={(v) => handleAsyncChange('parentId', v?.id || '')}
                  defaultValue={
                    initialState?.parent?.id
                      ? {
                          id: initialState.parent.id,
                          firstName: initialState.parent.firstName,
                          lastName: initialState.parent.lastName,
                        }
                      : undefined
                  }
                  disabled={loading}
                  agencyId={agencyId}
                />
                <TextField
                  className={classes.field}
                  id="placementId"
                  required={formState.parentId ? true : false}
                  variant="outlined"
                  label={T('PID')}
                  value={formState.parentId ? formState.placementId : ''}
                  onChange={handleChange}
                  error={
                    !!(showErrors && validation.errors.first('placementId'))
                  }
                  helperText={
                    showErrors && validation.errors.first('placementId')
                  }
                  disabled={loading || !formState.parentId}
                />
                <TextField
                  className={classes.field}
                  id="medicaidNumber"
                  required={formState.parentId ? true : false}
                  variant="outlined"
                  label={T('MedicaidNumber')}
                  value={formState.parentId ? formState.medicaidNumber : ''}
                  onChange={handleChange}
                  error={
                    showErrors && validation.errors.first('medicaidNumber')
                  }
                  helperText={
                    showErrors && validation.errors.first('medicaidNumber')
                  }
                  disabled={loading || !formState.parentId}
                />
              </Grid>
              <Grid item sm={12} md={6}>
                <TextField
                  className={classes.field}
                  name="level"
                  id="level"
                  required={formState.parentId ? true : false}
                  variant="outlined"
                  label={T('ChildLevel')}
                  select={true}
                  value={formState.level}
                  onChange={handleSelectChange}
                  disabled={loading || !formState.parentId}
                >
                  <MenuItem key="basic" value="BASIC">
                    Basic
                  </MenuItem>
                  <MenuItem key="moderate" value="MODERATE">
                    Moderate
                  </MenuItem>
                  <MenuItem key="specialized" value="SPECIALIZED">
                    Specialized
                  </MenuItem>
                </TextField>
                <TextField
                  className={classes.field}
                  id="fosterCareStartDate"
                  required={formState.parentId ? true : false}
                  variant="outlined"
                  label={T('FosterStartDate')}
                  type="date"
                  onChange={handleChange}
                  value={formState.parentId ? formState.fosterCareStartDate : ''}
                  error={
                    showErrors && validation.errors.first('fosterCareStartDate')
                  }
                  helperText={
                    showErrors && validation.errors.first('fosterCareStartDate')
                  }
                  InputLabelProps={{
                    shrink: true,
                  }}
                  disabled={loading || !formState.parentId}
                />
              </Grid>
              <Grid item sm={12} md={12}>
                <TextField
                  id="notes"
                  label={T('Notes')}
                  className={classes.field}
                  multiline={true}
                  variant="outlined"
                  onChange={handleChange}
                  value={formState.notes}
                  error={!!(showErrors && validation.errors.first('notes'))}
                  helperText={showErrors && validation.errors.first('notes')}
                  rows={3}
                  disabled={loading}
                />
              </Grid>
            </Grid>
          </div>
        </DialogContent>
        <DialogActions>
          <Button variant="contained" onClick={close} disabled={loading}>
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
            {T('Submit')}
          </Button>
        </DialogActions>
      </form>
    </Dialog>
  )
}

ChildForm.propTypes = {
  show: PropTypes.bool.isRequired,
  handleClose: PropTypes.func.isRequired,
  initialState: PropTypes.object,
}

export default ChildForm
