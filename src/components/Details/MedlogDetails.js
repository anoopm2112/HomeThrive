import React from 'react'
import Paper from '@material-ui/core/Paper'
import Button from '@material-ui/core/Button'
import Alert from '@material-ui/lab/Alert'
import Typography from '@material-ui/core/Typography'
import CircularProgress from '@material-ui/core/CircularProgress'
import { useQuery, useLazyQuery } from '@apollo/client'
import { GET_CHILDREN_MED_LOG, GET_MED_LOG_DOCUMENT } from '~/lib/queries/children'
import T from '~/lib/text'
import useStyles from '~/styles/resourcesPage.styles'

function MedlogDetails({ medlogId, onFetchCompleted }) {

  //    __     _      _    _
  //   / _|___| |_ __| |_ (_)_ _
  //  |  _/ -_)  _/ _| ' \| | ' \
  //  |_| \___|\__\__|_||_|_|_||_
  //

  const {
    loading: fetchLoading,
    data: fetchData,
    error: fetchError,
  } = useQuery(GET_CHILDREN_MED_LOG, {
    skip: !medlogId,
    variables: { input: { id: medlogId } },
    onCompleted: (d) => {
      if (onFetchCompleted) onFetchCompleted(d)
    },
  })

  const [
    getDocumentURL, 
    { loading: fetchURLLoading, data: fetchURLData }
  ] = useLazyQuery(GET_MED_LOG_DOCUMENT, {
    skip: !medlogId,
    fetchPolicy: 'network-only',
    variables: { input: { id: medlogId } },
    onCompleted: (d) => {
      console.log('MEDLOG', d)
      window.open(d.medLog.documentUrl, '_blank');
    },
  });

  //     _      _
  //  __| |__ _| |_ __ _   _ __ _ _ ___ _ __
  // / _` / _` |  _/ _` | | '_ \ '_/ -_) '_ \
  // \__,_\__,_|\__\__,_| | .__/_| \___| .__/
  //                      |_|          |_|
  //
  const medLog = fetchData?.medLog

  const error = fetchError

  const classes = useStyles()
  return (
    <Paper className={classes.paper}>
      {fetchLoading ? (
        <CircularProgress />
      ) : (
        <div className="local-reource-details">
          <div className={classes.articleHeader}>
            {error && <Alert severity="error">{error.message}</Alert>}
            <Typography className={classes.articleDetailsTitle} variant="h3">
              {T('MedLogDetailsHeader')}
            </Typography>
          </div>
          <div className={classes.block}>
            <div className={classes.group}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('ChildName')}
              </Typography>
              <Typography variant="body1">{medLog?.child.firstName} {medLog?.child.lastName}</Typography>
            </div>
            <div className={classes.group}>
              <Typography className={classes.groupTitle} variant="body2" style={{textAlign: 'right'}}>
                {T('Gender')}
              </Typography>
              <Typography variant="body1" style={{textAlign: 'right'}}>{medLog?.childSex}</Typography>
            </div>
          </div>
          <div className={classes.block}>
            <div className={classes.group}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Family')}
              </Typography>
              <Typography variant="body1">{medLog?.family.firstName} {medLog?.family.lastName}</Typography>
            </div>
            <div className={classes.group}>
              <Typography className={classes.groupTitle} variant="body2" style={{textAlign: 'right'}}>
                {T('Month')}
              </Typography>
              <Typography variant="body1" style={{textAlign: 'right'}}>{medLog?.month} / {medLog?.year}</Typography>
            </div>
          </div>
          <div className={classes.block}>
            <div className={classes.group}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Allergies')}
              </Typography>
              <Typography variant="body1">{medLog?.allergies || '-'}</Typography>
            </div>
          </div>
          <div className={classes.block}>
            <div className={classes.group}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('SigningStatus')}
              </Typography>
              <Typography variant="body1">{medLog?.signingStatus || '-'}</Typography>
            </div>
            <div className={classes.group}>
              <Typography className={classes.groupTitle} variant="body2" style={{textAlign: 'right'}}>
                {T('MedLogStatus')}
              </Typography>
              <Typography variant="body1" style={{textAlign: 'right'}}>{medLog?.isSubmitted ? 'Submitted' : 'Not Submitted'}</Typography>
            </div>
          </div>
          {medLog?.signingStatus === 'COMPLETED' ?
          <div className={classes.block} style={{marginTop: 8}}>
            <div style={{display: 'flex', alignItems: 'center'}}>
              <Button variant="contained" color="primary" style={{marginRight: 5}} onClick={() => getDocumentURL()}>
                {T('GetDoument')}
              </Button>
              {fetchURLLoading ? ( <CircularProgress size={20}/> ) : <></> }
            </div>
          </div> : <></> }
        </div>
      )}
    </Paper>
  )
}

export default MedlogDetails
