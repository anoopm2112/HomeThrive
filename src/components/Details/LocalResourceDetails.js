import React, { useState } from 'react'
import LocalResourceForm from '~/components/Forms/LocalResourceForm'
import Paper from '@material-ui/core/Paper'
// import Chip from '@material-ui/core/Chip'
import Button from '@material-ui/core/Button'
import Edit from '@material-ui/icons/Edit'
import Alert from '@material-ui/lab/Alert'
import Typography from '@material-ui/core/Typography'
import CircularProgress from '@material-ui/core/CircularProgress'
import { useQuery, useMutation } from '@apollo/client'
import { GET_LOCAL_RESOURCE, UPDATE_LOCAL_RESOURCE } from '~/lib/queries/localResources'
import { useUser } from '~/lib/amplifyAuth'
import T from '~/lib/text'
import useStyles from '~/styles/resourcesPage.styles'

function LocalResourceDetails({ resourceId, onFetchCompleted }) {
  const [showDialog, setShowDialog] = useState(false)
  const user = useUser()
  const role = user?.attributes
    ? parseInt(user?.attributes['custom:role'])
    : undefined

  //    __     _      _    _
  //   / _|___| |_ __| |_ (_)_ _
  //  |  _/ -_)  _/ _| ' \| | ' \
  //  |_| \___|\__\__|_||_|_|_||_
  //

  const {
    loading: fetchLoading,
    data: fetchData,
    error: fetchError,
  } = useQuery(GET_LOCAL_RESOURCE, {
    skip: !resourceId,
    variables: { input: { id: resourceId } },
    onCompleted: (d) => {
      // console.log('RESOURCE', d)
      if (onFetchCompleted) onFetchCompleted(d)
    },
  })

  // creates the mutation for updating
  const [
    updateResource,
    { loading: updateLoading, data: updateData, error: updateError },
  ] = useMutation(UPDATE_LOCAL_RESOURCE)

  //  _                 _ _
  // | |_  __ _ _ _  __| | |___ _ _ ___
  // | ' \/ _` | ' \/ _` | / -_) '_(_-<
  // |_||_\__,_|_||_\__,_|_\___|_| /__/
  //

  async function handleChange(e) {
    await updateResource({
      variables: {
        input: {
          id: parseInt(resource.id),
          published: e.target.value,
        },
      },
    })
  }

  //     _      _
  //  __| |__ _| |_ __ _   _ __ _ _ ___ _ __
  // / _` / _` |  _/ _` | | '_ \ '_/ -_) '_ \
  // \__,_\__,_|\__\__,_| | .__/_| \___| .__/
  //                      |_|          |_|
  //
  const resource = fetchData?.supportService
  const name = resource?.name
  const description = resource?.description || '-'
  const phoneNumber = resource?.phoneNumber || '-'
  const email = resource?.email || '-'
  const website = resource?.website || '-'
  // const categories = resource?.categories.map((e, i) => (
  //   <Chip key={`${e.id}.${i}`} size="small" label={e.name} />
  // ))

  let initialEditState
  if (resource) {
    initialEditState = {
      id: resourceId,
      supportservicename: resource?.name,
      description: resource?.description,
      phoneNumber: resource?.phoneNumber,
      email: resource?.email || '',
      website: resource?.website,
      agency: {
        id: resource?.agencyId || '',
        name: resource?.agencyName || '',
      }
    }
  }

  const error = fetchError || updateError

  const classes = useStyles()
  return (
    <Paper className={classes.paper}>
      {fetchLoading ? (
        <CircularProgress />
      ) : (
        <div className="local-reource-details">
          <LocalResourceForm
            show={showDialog}
            role={role}
            handleClose={() => setShowDialog(false)}
            initialState={initialEditState}
          />
          <div className={classes.articleHeader}>
            {error && <Alert severity="error">{error.message}</Alert>}
            <Typography className={classes.articleDetailsTitle} variant="h3">
              {T('LocalResourceDetails')}
            </Typography>
            <Button color="secondary" onClick={() => setShowDialog(true)}>
              <Edit />
            </Button>
          </div>
          <div className={classes.articleDetailsAuthor}>
            <Typography variant="body2">{T('SupportServiceName')}</Typography>
            <Typography variant="h3">{name}</Typography>
          </div>
          <div className={classes.block}>
            <div className={classes.group}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Description')}
              </Typography>
              <Typography variant="body1">{description}</Typography>
            </div>
          </div>
          <div className={classes.block}>
            <div className={classes.group}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Phone')}
              </Typography>
              <Typography variant="body1">{phoneNumber}</Typography>
            </div>
            <div className={classes.group}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Email')}
              </Typography>
              {/* <Typography variant="body1">google@gmail.com</Typography> */}
              <a
                className={classes.link}
                href={`mailto: ${email}`}
                style={{ marginTop: '0' }}
              >
                <Typography variant="body1">{email}</Typography>
              </a>
            </div>
          </div>
          <div className={classes.block}>
            <div className={classes.group}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('URL')}
              </Typography>
              <Typography variant="body1">{website}</Typography>
              <a
                className={classes.link}
                href={website}
                target="_blank"
                rel="noreferrer"
              >
                <Button variant="contained" color="primary">
                  {T('Preview')}
                </Button>
              </a>
            </div>
          </div>
        </div>
      )}
    </Paper>
  )
}

export default LocalResourceDetails
