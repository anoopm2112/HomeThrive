import React, { useState, useEffect, useContext } from 'react'
import { useMutation } from '@apollo/client'
import {
  formatDateForMaterialUIsStupidComponents,
  formatTimeForMaterialUIsStupidComponents,
  formatDateTimeToISOString,
  updateCache,
  trimStringsInObject,
} from '~/lib/utils'
import {
  CREATE_EVENT,
  EVENT_FRAGMENT,
  UPDATE_EVENT,
} from '~/lib/queries/events'
import { GET_FAMILIES } from '~/lib/queries/families'
import { NotificationContext } from '~/components/Contexts/NotificationContext'
import { useValidator, checkForDateErrors } from '~/lib/validators'
import TextField from '@material-ui/core/TextField'
import Typography from '@material-ui/core/Typography'
import Button from '@material-ui/core/Button'
import Dialog from '@material-ui/core/Dialog'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import Grid from '@material-ui/core/Grid'
import Box from '@material-ui/core/Box'
import InviteeSelect from './InviteeSelect'
import Alert from '@material-ui/lab/Alert'
import MenuItem from '@material-ui/core/MenuItem'
import CircularProgress from '@material-ui/core/CircularProgress'
import { useGenericFormStyles } from '~/components/Forms/Form.styles'
import rules from './EventForm.rules'
import T from '~/lib/text'

export const emptyFormState = {
  title: '',
  description: '',
  startsAt: '',
  endsAt: '',
  venue: '',
  address: '',
  image: '',
  latitude: undefined,
  longitude: undefined,
  eventType: '',
  participants: [],
}

function EventForm({ show, handleClose, initialState }) {
  // prep formState
  let date, start, end
  if (initialState) {
    date = formatDateForMaterialUIsStupidComponents(initialState.startsAt)
    start = formatTimeForMaterialUIsStupidComponents(initialState.startsAt)
    end = formatTimeForMaterialUIsStupidComponents(initialState.endsAt)
  }
  const stateToUse = {
    ...emptyFormState,
    ...initialState,
    date,
    start,
    end,
  }

  const [formState, setFormState] = useState(stateToUse)
  const [tab, setTab] = useState(0)
  const [hasInteracted, setHasInteracted] = useState(false)
  const notificationState = useContext(NotificationContext)
  const isUpdate = initialState && Object.keys(initialState).length > 0

  const { showErrors, setShowErrors, validation } = useValidator(
    formState,
    rules
  )

  const dateErrors = checkForDateErrors(
    formState.date,
    formatDateTimeToISOString(formState.date, formState.start),
    formatDateTimeToISOString(formState.date, formState.end),
    'future'
  )

  /*               __       __  _
   *   __ _  __ __/ /____ _/ /_(_)__  ___
   *  /  ' \/ // / __/ _ `/ __/ / _ \/ _ \
   * /_/_/_/\_,_/\__/\_,_/\__/_/\___/_//_/
   *
   **/

  // // mutation for creating
  const [
    createEvent,
    { loading: createLoading, data: createData, error: createError },
  ] = useMutation(CREATE_EVENT, {
    update(cache, { data: { createEvent } }) {
      // updates the cache when a resource is created
      updateCache('events', createEvent, cache, EVENT_FRAGMENT)
    },
  })

  const [
    updateEvent,
    { loading: updateLoading, data: updateData, error: updateError },
  ] = useMutation(UPDATE_EVENT)

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

  // mutation for creating  resource
  function handleSubmit(e) {
    const startsAt = formatDateTimeToISOString(formState.date, formState.start)
    const endsAt = formatDateTimeToISOString(formState.date, formState.end)

    if (validation.fails() || !!dateErrors) {
      setShowErrors(true)
    }
    // check DATE TIME issues
    else {
      const participantIds = formState.participants.map((e) => parseInt(e.id))
      const payload = {
        input: {
          title: formState?.title,
          description: formState?.description,
          startsAt,
          endsAt,
          venue: formState?.venue,
          address: formState?.address,
          image: formState?.image,
          eventType: formState?.eventType,
          // participantIds,
        },
      }
      if (isUpdate) {
        payload.input.id = initialState.id
        updateEvent({
          variables: trimStringsInObject(payload),
        })
      } else {
        if (participantIds.length !== 0)
          payload.input.participantIds = participantIds
        createEvent({
          variables: trimStringsInObject(payload),
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

  function handleInviteesChange(v) {
    if (!hasInteracted) setHasInteracted(true)
    setFormState({ ...formState, participants: v })
  }

  function close() {
    if (!isUpdate) setFormState(emptyFormState)
    handleClose()
    setTab(0)
  }

  function handleNextOrSubmit(e) {
    e.preventDefault()
    if (validation.fails() || !!dateErrors) {
      setShowErrors(true)
    } else if (tab === 1 && hasInteracted) {
      handleSubmit()
    } else {
      setTab(1)
    }
  }

  /*     _      _
   *  __| |__ _| |_ __ _   _ __ _ _ ___ _ __
   * / _` / _` |  _/ _` | | '_ \ '_/ -_) '_ \
   * \__,_\__,_|\__\__,_| | .__/_| \___| .__/
   *                      |_|          |_|
   **/

  const loading = createLoading || updateLoading
  const error = createError || updateError
  const invitees = initialState?.participants

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
      width={700}
      open={show}
      onClose={close}
      aria-labelledby="create-event-dialog"
    >
      <form onSubmit={handleNextOrSubmit} autoComplete="off">
        <DialogContent>
          <Typography variant="h3" className={classes.title}>
            {T('EventHeader')}
          </Typography>
          {!!error && (
            <Alert severity="error">
              {error.message ?? JSON.stringify(error)}
            </Alert>
          )}
          <TabPanel value={tab} index={0}>
            <div className="event-information">
              <Grid container spacing={1}>
                <Grid item xs={12}>
                  <TextField
                    size="small"
                    className={classes.field}
                    id="title"
                    required
                    variant="outlined"
                    label={T('Title')}
                    value={formState.title}
                    onChange={handleChange}
                    error={!!(showErrors && validation.errors.first('title'))}
                    helperText={showErrors && validation.errors.first('title')}
                  />
                </Grid>
                <Grid item xs={12}>
                  <TextField
                    size="small"
                    className={classes.field}
                    id="description"
                    required
                    multiline={true}
                    variant="outlined"
                    label={T('Description')}
                    value={formState.description}
                    rows={3}
                    onChange={handleChange}
                    error={
                      !!(showErrors && validation.errors.first('description'))
                    }
                    helperText={
                      showErrors && validation.errors.first('description')
                    }
                  />
                </Grid>
                <Grid item xs={6}>
                  <TextField
                    size="small"
                    className={classes.field}
                    id="venue"
                    required
                    variant="outlined"
                    label={T('Venue')}
                    value={formState.venue}
                    onChange={handleChange}
                    error={!!(showErrors && validation.errors.first('venue'))}
                    helperText={showErrors && validation.errors.first('venue')}
                  />
                </Grid>
                <Grid item xs={6}>
                  <TextField
                    size="small"
                    className={classes.field}
                    id="date"
                    required
                    label={T('Date')}
                    type="date"
                    variant="outlined"
                    onChange={handleChange}
                    value={formState.date}
                    error={!!showErrors && dateErrors?.date}
                    helperText={!!showErrors && dateErrors?.date}
                    InputLabelProps={{
                      shrink: true,
                    }}
                  />
                </Grid>
                <Grid item xs={6}>
                  <TextField
                    size="small"
                    className={classes.field}
                    id="start"
                    required
                    label={T('Start')}
                    type="time"
                    variant="outlined"
                    onChange={handleChange}
                    value={formState.start}
                    error={!!showErrors && dateErrors?.start}
                    helperText={!!showErrors && dateErrors?.start}
                    InputLabelProps={{
                      shrink: true,
                    }}
                  />
                </Grid>
                <Grid item xs={6}>
                  <TextField
                    size="small"
                    className={classes.field}
                    id="end"
                    required
                    label={T('End')}
                    type="time"
                    variant="outlined"
                    onChange={handleChange}
                    value={formState.end}
                    error={!!showErrors && dateErrors?.end}
                    helperText={!!showErrors && dateErrors?.end}
                    InputLabelProps={{
                      shrink: true,
                    }}
                  />
                </Grid>
                <Grid item xs={12}>
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
                    helperText={
                      showErrors && validation.errors.first('address')
                    }
                  />
                </Grid>
                <Grid item xs={12}>
                  <TextField
                    id="eventType"
                    name="eventType"
                    size="small"
                    className={classes.field}
                    select
                    required
                    variant="outlined"
                    label={T('Type')}
                    value={formState.eventType}
                    onChange={handleSelectChange}
                  >
                    <MenuItem value="MEETING">{T('Meeting')}</MenuItem>
                    <MenuItem value="AGENTVISIT">{T('AgentVisit')}</MenuItem>
                  </TextField>
                </Grid>
              </Grid>
            </div>
          </TabPanel>
          <TabPanel value={tab} index={1}>
            <Grid container spacing={2}>
              <Grid item xs={12}>
                <InviteeSelect
                  query={GET_FAMILIES}
                  label={T('Invitees')}
                  dataAccessor={(v) => v?.families?.items}
                  pageInfoAccessor={(v) => v?.families?.pageInfo}
                  labelAccessor={(v) => `${v.id} ${v.firstName} ${v.lastName}`}
                  onChange={(v) => handleInviteesChange(v)}
                  limit={30}
                  invitees={invitees}
                  participantLimit={
                    formState.eventType === 'AGENTVISIT' ? 1 : 0 // limit agent visits to 1 fam
                  }
                />
              </Grid>
            </Grid>
          </TabPanel>
        </DialogContent>
        <DialogActions>
          <Button variant="contained" onClick={close} disabled={loading}>
            {T('Cancel')}
          </Button>
          {tab === 1 && (
            <Button
              variant="contained"
              color="secondary"
              onClick={() => setTab(0)}
              disabled={loading}
            >
              {T('Back')}
            </Button>
          )}
          <Button
            type="submit"
            variant="contained"
            color="primary"
            disabled={loading || (tab === 1 && !hasInteracted)}
            endIcon={
              loading && (
                <CircularProgress style={{ color: 'white' }} size={12} />
              )
            }
          >
            {!isUpdate && tab === 0 ? T('Next') : T('Submit')}
          </Button>
        </DialogActions>
      </form>
    </Dialog>
  )
}

export default EventForm

function a11yProps(index) {
  return {
    id: `simple-tab-${index}`,
    'aria-controls': `simple-tabpanel-${index}`,
  }
}

function TabPanel(props) {
  const { children, value, index, ...other } = props

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
    >
      {value === index && <Box>{children}</Box>}
    </div>
  )
}
