import React, { useState, useEffect, useContext, useRef } from 'react'
import { useMutation, useQuery } from '@apollo/client'
import {
  // GET_RESOURCES_CATEGORIES,
  CREATE_LOCAL_RESOURCE,
  UPDATE_LOCAL_RESOURCE,
  LOCAL_RESOURCE_FRAGMENT_SHALLOW,
} from '~/lib/queries/localResources'
import { GET_AGENCIES } from '~/lib/queries/agencies'
import { NotificationContext } from '~/components/Contexts/NotificationContext'
import { useValidator } from '~/lib/validators'
import Typography from '@material-ui/core/Typography'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button'
import Alert from '@material-ui/lab/Alert'
import DialogTitle from '@material-ui/core/DialogTitle'
import Dialog from '@material-ui/core/Dialog'
import Popover from '@material-ui/core/Popover'
import Grid from '@material-ui/core/Grid'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import MenuItem from '@material-ui/core/MenuItem'
import CircularProgress from '@material-ui/core/CircularProgress'
import AsyncSearchSelect from '~/components/CustomFields/AsyncSearchSelect'
import {
  updateCache,
  onlyUpdatedObjectProperties,
  trimStringsInObject,
} from '~/lib/utils'
import { useGenericFormStyles } from '~/components/Forms/Form.styles'
import T from '~/lib/text'
import rules from './LocalResourceForm.rules'
import HelpIcon from '@material-ui/icons/Help'

export const emptyFormState = {
  supportservicename: '',
  description: '',
  phoneNumber: '',
  email: '',
  website: '',
  agency: ''
}
function LocalResourceForm({ show, role, handleClose, initialState }) {
  const initialFormState = {
    ...emptyFormState,
    ...initialState,
    agency: initialState?.agency?.id || '',
  }

  const [showHelp, setShowHelp] = useState(false)
  const helpRef = useRef(null)
  const [formState, setFormState] = useState(initialFormState)
  const notificationState = useContext(NotificationContext)
  const isUpdate = !!initialState && Object.keys(initialState).length > 0
  const { showErrors, setShowErrors, validation } = useValidator(
    formState,
    rules
  )

  /**
   *   __     _      _    _
   *  / _|___| |_ __| |_ (_)_ _  __ _
   * |  _/ -_)  _/ _| ' \| | ' \/ _` |
   * |_| \___|\__\__|_||_|_|_||_\__, |
   *                            |___/
   */
  // fetches the categories and the resource categories for the dropdowns
  // const {
  //   loading: fetchLoading,
  //   data: fetchData,
  //   error: fetchError,
  // } = useQuery(GET_RESOURCES_CATEGORIES)

  /*                __       __  _
   *   __ _  __ __/ /____ _/ /_(_)__  ___
   *  /  ' \/ // / __/ _ `/ __/ / _ \/ _ \
   * /_/_/_/\_,_/\__/\_,_/\__/_/\___/_//_/
   *
   **/
  const [
    createSupportService,
    { loading: createLoading, data: createData, error: createError },
  ] = useMutation(CREATE_LOCAL_RESOURCE, {
    update(cache, { data: { createSupportService } }) {
      // updates the cache when a resource is created
      updateCache('supportServices', createSupportService, cache, LOCAL_RESOURCE_FRAGMENT_SHALLOW)
    },
  })

  const [
    updateResource,
    { loading: updateLoading, data: updateData, error: updateError },
  ] = useMutation(UPDATE_LOCAL_RESOURCE)

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

  function handleAsyncChange(id, v) {
    setFormState({ ...formState, [id]: v })
  }

  function handleChange(e) {
    const id = e.target.id || e.target.name
    const value = e.target.value
    setFormState({ ...formState, [id]: value })
  }

  function handleSelectChangeMultiple(e) {
    if (
      e.target.name === 'categories' &&
      e.target.value.includes('createCategory')
    ) {
      setFormState({
        ...formState,
        createCategory: true,
      })
    } else {
      setFormState({
        ...formState,
        [e.target.name]: Array.isArray(e.target.value)
          ? e.target.value
          : [e.target.value],
      })
    }
  }

  // mutation for creating a resource
  // from dialog
  function handleSubmit(e) {
    e.preventDefault()
    if (validation.fails()) return setShowErrors(true)
    const data = formState
    let  payload = {
      input: {
        name: data.supportservicename,
        description: data.description,
        phoneNumber: data.phoneNumber,
        // email: data.email,
        // website: data.website,
        agencyId: data.agency
      },
    }

    if (data.email){
      payload = {input: {...payload.input, email: data.email }}
    }
    if (data.website){
      payload = {input: {...payload.input, website: data.website }}
    }

    // removes the agency field if set to all
    // the database assumes if no agency is set that all agencies can see it

    if (!isUpdate) {
      if (data.agency === '') delete payload.input.agency
      createSupportService({ variables: trimStringsInObject(payload) })
    } else {
      const newPayload = trimStringsInObject({
        input: {
          ...onlyUpdatedObjectProperties(initialState, payload.input),
          id: initialState.id, // required to be an INT
          agencyId: data.agency === '' ? undefined : data.agency,
        },
      })
      updateResource({
        variables: newPayload,
      })
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
  // const loading = createLoading || updateLoading || fetchLoading
  // const error = fetchError || createError || updateError
  const loading = createLoading || updateLoading
  const error = createError || updateError

  // let categoryOptions = []
  // if (fetchData) {
  //   const { resourceCategories, agencies } = fetchData

  //   categoryOptions = [
  //     <MenuItem key="createCategory" value="createCategory">
  //       + {T('NewCategory')}
  //     </MenuItem>,
  //     ...(resourceCategories || []).map((e, i) => (
  //       <MenuItem key={e.id} value={e.name}>
  //         {e.name}
  //       </MenuItem>
  //     )),
  //   ]

  //   // if (isUpdate) {
  //   //   categoryOptions = [
  //   //     ...(resourceCategories || []).map((e, i) => (
  //   //       <MenuItem key={e.id} value={e.name}>
  //   //         {e.name}
  //   //       </MenuItem>
  //   //     )),
  //   //   ]
  //   // }
  // }

  /**
   *
   *  _ _    _
   * | (_)__| |_ ___ _ _  ___ _ _ ___
   * | | (_-<  _/ -_) ' \/ -_) '_(_-<
   * |_|_/__/\__\___|_||_\___|_| /__/
   *
   */

  // console.log(formState)

  // listener to close dialog box
  useEffect(() => {
    if ((createData || updateData) && !loading) {
      notificationState.set({
        open: true,
        message: T('Create'),
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
        message: T('Updated'),
      })
      close(false)
    }
  }, [updateData, updateLoading, updateError])

  const classes = useGenericFormStyles()
  return (
    <Dialog
      open={show}
      onClose={close}
      aria-labelledby="create-resource-dialog"
    >
      <form onSubmit={handleSubmit} autoComplete="off">
        <DialogTitle>
          <Typography variant="h3">{T('LocalResourceFormHeader')}</Typography>
        </DialogTitle>
        <DialogContent>
          {!!error && (
            <Alert severity="error">
              {error.message ? error.message : JSON.stringify(error)}
            </Alert>
          )}
          <Grid container spacing={1}>
            <Grid item xs={12}>
              <TextField
                id="supportservicename"
                className={classes.field}
                variant="outlined"
                label={T('SupportServiceName')}
                required
                value={formState.supportservicename}
                onChange={handleChange}
                error={!!(showErrors && validation.errors.first('supportservicename'))}
                helperText={showErrors && validation.errors.first('supportservicename')}
                disabled={loading}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                id="description"
                className={classes.field}
                variant="outlined"
                // label={T('description')}
                label="Description"
                required
                value={formState.description}
                onChange={handleChange}
                error={!!(showErrors && validation.errors.first('description'))}
                helperText={showErrors && validation.errors.first('description')}
                multiline={true}
                rows={3}
                disabled={loading}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                id="phoneNumber"
                className={classes.field}
                variant="outlined"
                // label={T('Image')}
                label="Phone"
                required
                value={formState.phoneNumber}
                onChange={handleChange}
                error={!!(showErrors && validation.errors.first('phoneNumber'))}
                helperText={showErrors && validation.errors.first('phoneNumber')}
                disabled={loading}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                id="email"
                className={classes.field}
                variant="outlined"
                label={T('Email')}
                value={formState.email}
                onChange={handleChange}
                error={!!(showErrors && validation.errors.first('email'))}
                helperText={showErrors && validation.errors.first('email')}
                disabled={loading}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                id="website"
                className={classes.field}
                variant="outlined"
                label="Website Link"
                value={formState.website}
                onChange={handleChange}
                error={!!(showErrors && validation.errors.first('website'))}
                helperText={showErrors && validation.errors.first('website')}
                disabled={loading}
              />
            </Grid>
            {role === 0 ?
            <Grid item xs={12}>
              <AsyncSearchSelect
                id="agency_id"
                className={classes.field}
                query={GET_AGENCIES}
                label={T('Agency')}
                dataAccessor={(v) => v?.agencies?.items || []}
                labelAccessor={(v) => v?.name || ''}
                onSelect={(v) => handleAsyncChange('agency', v?.id || '')}
                value={{ id: formState?.agency || '' }}
                // defaultValue={
                //   initialState.agency
                //     ? {
                //         id: initialState?.agency?.id,
                //         name: initialState?.agency?.name,
                //       }
                //     : { id: '', name: T('All') }
                // }
                pageInfoAccessor={(v) => v?.agencies?.pageInfo}
                disabled={loading}
                // allSelection={{ id: '', name: T('All') }}
                required
              />
            </Grid> : <></> }
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={close} color="primary">
            {T('Cancel')}
          </Button>
          {Object.keys(initialState) > 0 && (
            <Button
              onClick={() => {
                alert('This doesnt work yet')
              }}
              variant="contained"
              disabled={loading}
              color="secondary"
            >
              {T('Delete')}
            </Button>
          )}
          <Button
            type="submit"
            variant="contained"
            disabled={loading}
            color="primary"
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

LocalResourceForm.defaultProps = {
  categories: [],
  agencies: [],
  initialState: {},
}

export default LocalResourceForm
