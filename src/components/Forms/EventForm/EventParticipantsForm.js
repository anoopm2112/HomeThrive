import React, { useState, useEffect, useContext } from 'react'
import { useMutation, gql } from '@apollo/client'
import { GET_FAMILIES } from '~/lib/queries/families'
import {
  UPDATE_EVENT_PARTICIPANTS,
  EVENT_FRAGMENT,
  EVENT_PARTICIPANT_FRAGMENT,
} from '~/lib/queries/events'
import { NotificationContext } from '~/components/Contexts/NotificationContext'
import Button from '@material-ui/core/Button'
import Dialog from '@material-ui/core/Dialog'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import Grid from '@material-ui/core/Grid'
import Alert from '@material-ui/lab/Alert'
import CircularProgress from '@material-ui/core/CircularProgress'
import InviteeSelect from './InviteeSelect'
import T from '~/lib/text'

function EventParticipantsForm({
  show,
  handleClose,
  initialState,
  eventId,
  onComplete,
}) {
  const invitees = initialState || []
  const [toAdd, setToAdd] = useState([])
  const notificationState = useContext(NotificationContext)

  const [
    updateParticipants,
    { loading, data: updateData, error },
  ] = useMutation(UPDATE_EVENT_PARTICIPANTS, {
    notifyOnNetworkStatusChange: true,
    update(cache, { data: { updateParticipants } }) {
      const result = cache.writeFragment({
        id: `Event:${eventId}`,
        fragment: EVENT_FRAGMENT,
        data: updateParticipants,
      })

      return result
    },
    onCompleted: (d) => {
      if (onComplete) onComplete(d)
    },
  })

  function handleSubmit() {
    // console.log('toAdd', toAdd)
    if (toAdd.length > 0) {
      updateParticipants({
        variables: {
          input: {
            eventId,
            add: toAdd.map((e) => parseInt(e.id)),
            remove: [],
          },
        },
      })
    }
  }

  useEffect(() => {
    if (updateData && !loading && !error) {
      console.log('UPDATE DATA', updateData)
      notificationState.set({
        open: true,
        message: T('SuccessfulUpdateParticipants'),
      })
      handleClose()
    }
  }, [updateData])

  return (
    <Dialog
      width={700}
      open={show}
      onClose={handleClose}
      aria-labelledby="create-event-dialog"
    >
      <DialogContent>
        {!!error && (
          <Alert severity="error">
            {error.message ?? JSON.stringify(error)}
          </Alert>
        )}
        <Grid container spacing={2}>
          <Grid item xs={12}>
            <InviteeSelect
              query={GET_FAMILIES}
              label={T('Invitees')}
              dataAccessor={(v) => v?.families?.items}
              pageInfoAccessor={(v) => v?.families?.pageInfo}
              labelAccessor={(v) => `(${v.id}) ${v.firstName} ${v.lastName}`}
              inviteeLabelAccessor={(v) => `${v.name}`}
              onChange={(v) => setToAdd(v)}
              limit={30}
              invitees={invitees}
            />
          </Grid>
        </Grid>
        <DialogActions>
          <Button variant="contained" onClick={handleClose} disabled={loading}>
            {T('Cancel')}
          </Button>
          <Button
            variant="contained"
            color="primary"
            onClick={handleSubmit}
            disabled={loading}
            endIcon={
              loading && (
                <CircularProgress style={{ color: 'white' }} size={12} />
              )
            }
          >
            {T('AddParticipants')}
          </Button>
        </DialogActions>
      </DialogContent>
    </Dialog>
  )
}

export default EventParticipantsForm
