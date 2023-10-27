import React, { useState, useEffect } from 'react'
import { useQuery } from '@apollo/client'
import { GET_EVENT, GET_EVENT_PARTICIPANTS } from '~/lib/queries/events'
import EventForm from '~/components/Forms/EventForm'
import Typography from '@material-ui/core/Typography'
import Button from '@material-ui/core/Button'
import Paper from '@material-ui/core/Paper'
import Grid from '@material-ui/core/Grid'
import Edit from '@material-ui/icons/Edit'
import CircularProgress from '@material-ui/core/CircularProgress'
import T from '~/lib/text'
import useStyles from './Details.styles'

function EventDetails({ eventId }) {
  const [showDialog, setShowDialog] = useState(false)
  // gets currently logged in user

  //    __     _      _    _             __                 _        _   _
  //   / _|___| |_ __| |_ (_)_ _  __ _  / _|___   _ __ _  _| |_ __ _| |_(_)___ _ _
  //  |  _/ -_)  _/ _| ' \| | ' \/ _` | > _|_ _| | '  \ || |  _/ _` |  _| / _ \ ' \
  //  |_| \___|\__\__|_||_|_|_||_\__, | \_____|  |_|_|_\_,_|\__\__,_|\__|_\___/_||_|
  //

  const {
    loading: fetchLoading,
    data: fetchData,
    error: fetchError,
  } = useQuery(GET_EVENT, {
    skip: !eventId,
    variables: { input: { id: eventId } },
  })

  const event = fetchData?.event

  //     _      _
  //  __| |__ _| |_ __ _   _ __ _ _ ___ _ __
  // / _` / _` |  _/ _` | | '_ \ '_/ -_) '_ \
  // \__,_\__,_|\__\__,_| | .__/_| \___| .__/
  //                      |_|          |_|

  let initialEditState
  if (event) {
    initialEditState = {
      id: eventId,
      title: event?.title,
      description: event?.description,
      startsAt: event?.startsAt,
      endsAt: event?.endsAt,
      venue: event?.venue,
      address: event?.address,
      image: event?.image,
      latitude: event?.latitude,
      longitude: event?.longitude,
      eventType: event?.eventType,
      invitationsCount: event?.invitationsCount,
      rsvpCount: event?.rsvpCount,
    }
  }

  const start = new Date(event?.startsAt)
  const end = new Date(event?.endsAt)
  const date = start?.toLocaleDateString()
  const startTime = start?.toLocaleTimeString([], {
    hour: '2-digit',
    minute: '2-digit',
  })

  const endTime = end?.toLocaleTimeString([], {
    hour: '2-digit',
    minute: '2-digit',
  })
  const timespan = `${startTime} - ${endTime}`

  //  _ _    _
  // | (_)__| |_ ___ _ _  ___ _ _ ___
  // | | (_-<  _/ -_) ' \/ -_) '_(_-<
  // |_|_/__/\__\___|_||_\___|_| /__/
  //

  useEffect(() => {
    if (fetchError) {
      console.log(
        'ERROR',
        fetchError,
        Object.keys(fetchError),
        fetchError?.networkError?.result,
        fetchError?.graphQLErrors
      )
    }
  }, [fetchError])

  const classes = useStyles()

  return (
    <Paper className={classes.paper}>
      {fetchLoading ? (
        <CircularProgress />
      ) : (
        <div className="event-details">
          <EventForm
            show={showDialog}
            handleClose={() => setShowDialog(false)}
            initialState={initialEditState}
          />
          <Grid container spacing={2}>
            <Grid item xs={12} className={classes.header}>
              <Typography className={classes.detailsTitle} variant="h4">
                {T('EventHeader')}
              </Typography>
              <Button color="secondary" onClick={() => setShowDialog(true)}>
                <Edit />
              </Button>
            </Grid>
            <Grid item xs={12}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Title')}
              </Typography>
              <Typography variant="h3">{event?.title}</Typography>
            </Grid>
            <Grid item xs={12}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Description')}
              </Typography>
              <Typography variant="body1">{event?.description}</Typography>
            </Grid>
            <Grid item xs={12}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Venue')}
              </Typography>
              <Typography variant="body1">{event?.venue}</Typography>
            </Grid>

            <Grid item xs={12}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Location')}
              </Typography>
              <Typography variant="body1">{event?.address}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Date')}
              </Typography>
              <Typography variant="body1">{date}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Time')}
              </Typography>
              <Typography variant="body1">{timespan}</Typography>
            </Grid>
          </Grid>
        </div>
      )}
    </Paper>
  )
}

export default EventDetails
