import React, { useState, useEffect } from 'react'
import axios from 'axios'
import Paper from '@material-ui/core/Paper'
import Typography from '@material-ui/core/Typography'
import Hidden from '@material-ui/core/Hidden'
import CircularProgress from '@material-ui/core/CircularProgress'
import useStyles from '~/styles/resourcesPage.styles'
import clsx from 'clsx'

function ResourceDetailsContent({ resource }) {
  const [metadata, setMetadata] = useState()

  //       _      _
  //  __| |__ _| |_ __ _   _ __ _ _ ___ _ __
  // / _` / _` |  _/ _` | | '_ \ '_/ -_) '_ \
  // \__,_\__,_|\__\__,_| | .__/_| \___| .__/
  //                      |_|          |_|

  const imgURL = resource?.image
  const title = resource?.title
  const summary = resource?.summary
  const loading = !resource
  //  _ _    _
  // | (_)__| |_ ___ _ _  ___ _ _ ___
  // | | (_-<  _/ -_) ' \/ -_) '_(_-<
  // |_|_/__/\__\___|_||_\___|_| /__/
  //
  useEffect(() => {
    async function getResourceMetadata() {
      if (resource) {
        const url = resource.url
        const { data: _metadata } = await axios.get(
          `/api/proxyMetadataRequest?url=${url}`
        )
        setMetadata(_metadata)
      }
    }
    getResourceMetadata()
  }, [resource])

  const classes = useStyles()
  return (
    <Hidden smDown>
      <Paper
        className={clsx([
          classes.paper,
          classes.paperTall,
          classes.disableCursor,
        ])}
      >
        {loading ? (
          <CircularProgress />
        ) : (
          <div className="article-title-card">
            <Typography variant="h3">{title}</Typography>
            <Typography variant="h5">Summary:</Typography>
            <Typography variant="body1">{summary}</Typography>
            <img
              className={classes.resourceImage}
              src={imgURL}
              alt="Resource Image"
            />
          </div>
        )}
      </Paper>
    </Hidden>
  )
}

export default ResourceDetailsContent
