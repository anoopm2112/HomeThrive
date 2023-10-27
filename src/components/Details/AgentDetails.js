import React, { useState, useEffect } from 'react'
import { useQuery } from '@apollo/client'
import { GET_AGENT } from '~/lib/queries/users'
import AgencyUserForm from '~/components/Forms/AgencyUserForm'
import Typography from '@material-ui/core/Typography'
import Button from '@material-ui/core/Button'
import Paper from '@material-ui/core/Paper'
import Grid from '@material-ui/core/Grid'
import Edit from '@material-ui/icons/Edit'
import CircularProgress from '@material-ui/core/CircularProgress'
import T from '~/lib/text'
import useStyles from './Details.styles'

function AgentDetails({ agentId }) {
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
  } = useQuery(GET_AGENT, {
    skip: !agentId,
    variables: { input: { id: parseInt(agentId) } },
  })

  const agent = fetchData?.agent

  //     _      _
  //  __| |__ _| |_ __ _   _ __ _ _ ___ _ __
  // / _` / _` |  _/ _` | | '_ \ '_/ -_) '_ \
  // \__,_\__,_|\__\__,_| | .__/_| \___| .__/
  //                      |_|          |_|

  let initialEditState
  if (agent) {
    initialEditState = {
      id: parseInt(agentId),
      firstName: agent?.firstName,
      lastName: agent?.lastName,
      email: agent?.email,
      title: agent?.title,
      phoneNumber: agent?.phoneNumber,
      childrenCount: agent?.childrenCount,
      familyCount: agent?.familyCount,
    }
  }

  const name = agent?.lastName ? agent?.firstName + ' ' + agent?.lastName : '--'

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
        <div className="agency-details">
          <AgencyUserForm
            show={showDialog}
            handleClose={() => setShowDialog(false)}
            initialState={initialEditState}
          />
          <Grid container spacing={2}>
            <Grid item xs={12} className={classes.header}>
              <Typography className={classes.detailsTitle} variant="h4">
                {T('AgentDetailsHeader')}
              </Typography>
              <Button color="secondary" onClick={() => setShowDialog(true)}>
                <Edit />
              </Button>
            </Grid>
            <Grid item xs={12}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Name')}
              </Typography>
              <Typography variant="h3">{name}</Typography>
            </Grid>
            <Grid item xs={8}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Email')}
              </Typography>
              <Typography variant="body1">{agent?.email}</Typography>
            </Grid>
            <Grid item xs={4}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('NumFamilies')}
              </Typography>
              <Typography variant="body1">{agent?.familiesCount}</Typography>
            </Grid>
            <Grid item xs={8}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Phone')}
              </Typography>
              <Typography variant="body1">{agent?.phoneNumber}</Typography>
            </Grid>
            <Grid item xs={4}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('NumChildren')}
              </Typography>
              <Typography variant="body1">{agent?.childrenCount}</Typography>
            </Grid>
          </Grid>
        </div>
      )}
    </Paper>
  )
}

export default AgentDetails
