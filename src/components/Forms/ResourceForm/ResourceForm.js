import React, { useState, useEffect, useContext, useRef } from 'react'
import { useMutation, useQuery } from '@apollo/client'
import {
  GET_RESOURCES_CATEGORIES,
  CREATE_RESOURCE,
  UPDATE_RESOURCE,
  RESOURCE_FRAGMENT_SHALLOW,
} from '~/lib/queries/resources'
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
import rules from './ResourceForm.rules'
import HelpIcon from '@material-ui/icons/Help'

export const emptyFormState = {
  title: '',
  summary: '',
  link: '',
  image: '',
  agency: '',
  published: true,
  categories: [],
  createCategory: false,
}
function ResourceForm({ show, handleClose, initialState }) {
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
  const {
    loading: fetchLoading,
    data: fetchData,
    error: fetchError,
  } = useQuery(GET_RESOURCES_CATEGORIES)

  /*                __       __  _
   *   __ _  __ __/ /____ _/ /_(_)__  ___
   *  /  ' \/ // / __/ _ `/ __/ / _ \/ _ \
   * /_/_/_/\_,_/\__/\_,_/\__/_/\___/_//_/
   *
   **/
  const [
    createResource,
    { loading: createLoading, data: createData, error: createError },
  ] = useMutation(CREATE_RESOURCE, {
    update(cache, { data: { createResource } }) {
      // updates the cache when a resource is created
      updateCache('resources', createResource, cache, RESOURCE_FRAGMENT_SHALLOW)
    },
  })

  const [
    updateResource,
    { loading: updateLoading, data: updateData, error: updateError },
  ] = useMutation(UPDATE_RESOURCE)

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
    const payload = {
      input: {
        title: data.title,
        summary: data.summary,
        image: data.image,
        url: data.link,
        categories: data.categories,
        published: data.published,
        agency: data.agency,
      },
    }

    // removes the agency field if set to all
    // the database assumes if no agency is set that all agencies can see it

    if (!isUpdate) {
      if (data.agency === '') delete payload.input.agency
      createResource({ variables: trimStringsInObject(payload) })
    } else {
      const newPayload = trimStringsInObject({
        input: {
          ...onlyUpdatedObjectProperties(initialState, payload.input),
          id: initialState.id, // required to be an INT
          agency: data.agency === '' ? undefined : data.agency,
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
  const loading = createLoading || updateLoading || fetchLoading
  const error = fetchError || createError || updateError

  let categoryOptions = []
  if (fetchData) {
    const { resourceCategories, agencies } = fetchData

    categoryOptions = [
      <MenuItem key="createCategory" value="createCategory">
        + {T('NewCategory')}
      </MenuItem>,
      ...(resourceCategories || []).map((e, i) => (
        <MenuItem key={e.id} value={e.name}>
          {e.name}
        </MenuItem>
      )),
    ]

    // if (isUpdate) {
    //   categoryOptions = [
    //     ...(resourceCategories || []).map((e, i) => (
    //       <MenuItem key={e.id} value={e.name}>
    //         {e.name}
    //       </MenuItem>
    //     )),
    //   ]
    // }
  }

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
          <Typography variant="h3">{T('ResourceFormHeader')}</Typography>
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
                id="title"
                className={classes.field}
                variant="outlined"
                label={T('Title')}
                required
                value={formState.title}
                onChange={handleChange}
                error={!!(showErrors && validation.errors.first('title'))}
                helperText={showErrors && validation.errors.first('title')}
                disabled={loading}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                id="summary"
                className={classes.field}
                variant="outlined"
                label={T('Summary')}
                required
                value={formState.summary}
                onChange={handleChange}
                error={!!(showErrors && validation.errors.first('summary'))}
                helperText={showErrors && validation.errors.first('summary')}
                multiline={true}
                rows={3}
                disabled={loading}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                id="link"
                className={classes.field}
                variant="outlined"
                label={T('Link')}
                required
                value={formState.link}
                onChange={handleChange}
                error={!!(showErrors && validation.errors.first('link'))}
                helperText={showErrors && validation.errors.first('link')}
                disabled={loading}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                id="image"
                className={classes.field}
                variant="outlined"
                label={T('Image')}
                required
                value={formState.image}
                onChange={handleChange}
                error={!!(showErrors && validation.errors.first('image'))}
                helperText={showErrors && validation.errors.first('image')}
                disabled={loading}
              />
            </Grid>
            {fetchLoading ? (
              <CircularProgress />
            ) : (
              <>
                <Grid item xs={12}>
                  <div className={classes.categoriesDropDown}>
                    <TextField
                      id="categories"
                      name="categories"
                      variant="outlined"
                      className={classes.field}
                      label={
                        !formState.createCategory ? T('Categories') : T('New')
                      }
                      select={!formState.createCategory}
                      SelectProps={{ multiple: true }}
                      value={formState.categories}
                      onChange={handleSelectChangeMultiple}
                      error={
                        !!(showErrors && validation.errors.first('categories'))
                      }
                      helperText={
                        showErrors && validation.errors.first('categories')
                      }
                      disabled={loading}
                    >
                      {categoryOptions}
                    </TextField>
                    <HelpIcon
                      ref={helpRef}
                      onClick={() => setShowHelp(true)}
                      className={classes.helpIcon}
                    />
                    <Popover
                      classes={{
                        paper: classes.paper,
                      }}
                      open={showHelp}
                      anchorEl={helpRef.current}
                      anchorOrigin={{
                        vertical: 'top',
                        horizontal: 'right',
                      }}
                      transformOrigin={{
                        vertical: 'top',
                        horizontal: 'left',
                      }}
                      onClose={() => setShowHelp(false)}
                      disableRestoreFocus
                    >
                      <Typography variant="body2" className={classes.popover}>
                        {T('CategoriesHelp')}
                      </Typography>
                    </Popover>
                  </div>
                </Grid>
              </>
            )}
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
                defaultValue={
                  initialState.agency
                    ? {
                        id: initialState?.agency?.id,
                        name: initialState?.agency?.name,
                      }
                    : { id: '', name: T('All') }
                }
                pageInfoAccessor={(v) => v?.agencies?.pageInfo}
                disabled={loading}
                allSelection={{ id: '', name: T('All') }}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                id="published"
                name="published"
                className={classes.field}
                variant="outlined"
                label={T('Action')}
                select
                value={formState.published}
                onChange={handleChange}
                error={!!(showErrors && validation.errors.first('published'))}
                helperText={showErrors && validation.errors.first('published')}
                disabled={loading}
              >
                <MenuItem value={true}>
                  <em>{T('Publish')}</em>
                </MenuItem>
                <MenuItem value={false}>
                  <em>{T('SaveAsDraft')}</em>
                </MenuItem>
              </TextField>
            </Grid>
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

ResourceForm.defaultProps = {
  categories: [],
  agencies: [],
  initialState: {},
}

export default ResourceForm
