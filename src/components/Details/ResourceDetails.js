import React, { useState, useEffect, useContext } from 'react'
import ResourceForm from '~/components/Forms/ResourceForm'
import Paper from '@material-ui/core/Paper'
import Chip from '@material-ui/core/Chip'
import Button from '@material-ui/core/Button'
import Edit from '@material-ui/icons/Edit'
import Alert from '@material-ui/lab/Alert'
import Typography from '@material-ui/core/Typography'
import CircularProgress from '@material-ui/core/CircularProgress'
import { NotificationContext } from '~/components/Contexts/NotificationContext'
import Divider from '@material-ui/core/Divider'
import FormControl from '@material-ui/core/FormControl'
import InputLabel from '@material-ui/core/InputLabel'
import Select from '@material-ui/core/Select'
import MenuItem from '@material-ui/core/MenuItem'
import { useQuery, useMutation } from '@apollo/client'
import { GET_RESOURCE, UPDATE_RESOURCE } from '~/lib/queries/resources'
import T from '~/lib/text'
import useStyles from '~/styles/resourcesPage.styles'

function ResourceDetails({ resourceId, onFetchCompleted }) {
  const [showDialog, setShowDialog] = useState(false)

  //    __     _      _    _
  //   / _|___| |_ __| |_ (_)_ _
  //  |  _/ -_)  _/ _| ' \| | ' \
  //  |_| \___|\__\__|_||_|_|_||_
  //

  const {
    loading: fetchLoading,
    data: fetchData,
    error: fetchError,
  } = useQuery(GET_RESOURCE, {
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
  ] = useMutation(UPDATE_RESOURCE)

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
  const resource = fetchData?.resource
  const author = resource?.author
  const agency = resource?.agency?.name || 'All'
  const name = author?.firstName + ' ' + author?.lastName
  const publishedOn = new Date(resource?.createdAt).toLocaleDateString()
  const updated = new Date(resource?.updatedAt).toLocaleDateString()
  const isPublished = resource?.published
  const categories = resource?.categories.map((e, i) => (
    <Chip key={`${e.id}.${i}`} size="small" label={e.name} />
  ))

  let initialEditState
  if (resource) {
    initialEditState = {
      id: resourceId,
      title: resource?.title,
      link: resource?.url,
      summary: resource?.summary,
      image: resource?.image,
      agency: resource?.agency || '',
      published: resource?.published,
      categories: (resource?.categories || []).map((e) => e.name),
    }
  }

  const error = fetchError || updateError

  const classes = useStyles()
  return (
    <Paper className={classes.paper}>
      {fetchLoading ? (
        <CircularProgress />
      ) : (
        <div className="article-details">
          <ResourceForm
            show={showDialog}
            handleClose={() => setShowDialog(false)}
            initialState={initialEditState}
          />
          <div className={classes.articleHeader}>
            {error && <Alert severity="error">{error.message}</Alert>}
            <Typography className={classes.articleDetailsTitle} variant="h3">
              {T('ArticleDetails')}
            </Typography>
            <Button color="secondary" onClick={() => setShowDialog(true)}>
              <Edit />
            </Button>
          </div>
          <div className={classes.articleDetailsAuthor}>
            <Typography variant="body2">{T('PublishedBy')}</Typography>
            <Typography variant="h3">{name}</Typography>
          </div>
          <div className={classes.block}>
            <div className={classes.group}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('PublishedOn')}
              </Typography>
              <Typography variant="body1">{publishedOn}</Typography>
            </div>
            <div className={classes.group}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('UpdatedOn')}
              </Typography>
              <Typography variant="body1">{updated}</Typography>
            </div>
          </div>
          <Divider className={classes.divider} />

          <div className={classes.block}>
            <div className={classes.group}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Categories')}
              </Typography>
              <div>{categories}</div>
            </div>
            <FormControl
              variant="outlined"
              size="small"
              className={classes.formControl}
            >
              <InputLabel id="article-publish-status-select">
                {T('Status')}
              </InputLabel>
              <Select
                labelId="article-publish-status-select"
                id="demo-simple-select-outlined"
                value={isPublished}
                onChange={handleChange}
                label="Status"
              >
                <MenuItem value={true}>
                  <em>{T('Published')}</em>
                </MenuItem>
                <MenuItem value={false}>
                  <em>{T('Draft')}</em>
                </MenuItem>
              </Select>
            </FormControl>
          </div>
          <div className={classes.block}>
            <div className={classes.group}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Agency')}
              </Typography>
              <Typography variant="body1">{agency}</Typography>
            </div>
          </div>
          <div className={classes.block}>
            <div className={classes.group}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('URL')}
              </Typography>
              <Typography variant="body1">{resource?.url}</Typography>
              <a
                className={classes.link}
                href={resource?.url}
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

export default ResourceDetails
