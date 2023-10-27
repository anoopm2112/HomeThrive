import React, { useEffect, useState } from 'react'
import { useRouter } from 'next/router'
import { useQuery } from '@apollo/client'
import { GET_RECREATION_LOG } from '~/lib/queries/children'
import Typography from '@material-ui/core/Typography'
import Button from '@material-ui/core/Button'
import Grid from '@material-ui/core/Grid'
import Dialog from '@material-ui/core/Dialog'
import DialogTitle from '@material-ui/core/DialogTitle'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import Table from '@material-ui/core/Table'
import TableBody from '@material-ui/core/TableBody'
import TableCell from '@material-ui/core/TableCell'
import TableContainer from '@material-ui/core/TableContainer'
import TableHead from '@material-ui/core/TableHead'
import TableRow from '@material-ui/core/TableRow'
import CircularProgress from '@material-ui/core/CircularProgress'
import useStyles from './LogDetails.styles.js'
import Modal from '@material-ui/core/Modal'
import T from '~/lib/text'

function RecreationLogDetails() {
  const classes = useStyles()
  const router = useRouter()
  const { recreationlog: logId, id: childId } = router?.query
  const [image, setImage] = useState('')
  const [show, setShow] = useState(false)

  //  __ _ _  _ ___ _ _ _  _
  // / _` | || / -_) '_| || |
  // \__, |\_,_\___|_|  \_, |
  //    |_|             |__/
  //

  const payload = {
    id: logId,
  }
  const shouldSkip = !logId || !show || !payload.id
  const {
    loading: fetchLoading,
    data: fetchData,
    error: fetchError,
  } = useQuery(GET_RECREATION_LOG, {
    skip: shouldSkip,
    fetchPolicy: 'cache-first',
    variables: {
      input: payload,
    },
  })

  //     _      _
  //  __| |__ _| |_ __ _   _ __ _ _ ___ _ __
  // / _` / _` |  _/ _` | | '_ \ '_/ -_) '_ \
  // \__,_\__,_|\__\__,_| | .__/_| \___| .__/
  //                      |_|          |_|
  //

  const {
    childName,
    date,
    familyActivity,
    communityActivity,
    dailyIndoorOutdoorActivity,
    individualFreeTimeActivity,
  } = fetchData?.recreationLog || {}

  const dateToShow = new Date(date).toLocaleDateString()

  //  _                 _ _
  // | |_  __ _ _ _  __| | |___ _ _ ___
  // | ' \/ _` | ' \/ _` | / -_) '_(_-<
  // |_||_\__,_|_||_\__,_|_\___|_| /__/
  //

  function close() {
    router.push(
      {
        query: {
          id: childId,
        },
      },
      undefined,
      {
        scroll: false,
      }
    )
    setShow(false)
  }

  //  _ _    _
  // | (_)__| |_ ___ _ _  ___ _ _ ___
  // | | (_-<  _/ -_) ' \/ -_) '_(_-<
  // |_|_/__/\__\___|_||_\___|_| /__/
  //

  useEffect(() => {
    if (logId) setShow(true)
  }, [logId])

  return (
    <>
      <Modal
        open={image !== ''}
        onClose={() => setImage('')}
        classes={classes.modal}
      >
        <div className={classes.modalContent}>
          <img className={classes.modalImage} src={image} />
          <Button
            className={classes.modalButtons}
            color="primary"
            variant="contained"
            onClick={() => setImage('')}
          >
            {T('Close')}
          </Button>
        </div>
      </Modal>
      <Dialog
        maxWidth="md"
        open={show}
        onClose={close}
        aria-labelledby="log-dialog"
      >
        <DialogTitle>
          <Grid container spacing={2}>
            <Grid item xs={10}>
              <Typography variant="h2">{T('RecreationLogDetailsHeader')}</Typography>
            </Grid>
            {!fetchLoading && (
              <>
                <Grid item xs={2} className={classes.logDate}>
                  <Typography variant="body2">{dateToShow}</Typography>
                </Grid>
                <Grid item xs={12}>
                  <div className="child-details">
                    <Typography variant="h4">{childName}</Typography>
                  </div>
                </Grid>
              </>
            )}
          </Grid>
        </DialogTitle>
        <DialogContent>
          <div className={classes.logContent}>
            <Grid container spacing={2}>
              {fetchLoading ? (
                <CircularProgress />
              ) : (
                <>
                  <Grid item xs={12}>
                    <TableContainer>
                      <Table aria-label="table">
                        <TableHead>
                          <TableRow>
                            <TableCell>
                              <Typography
                                variant="body2"
                                className={classes.grayText}
                              >
                                <strong>
                                  {T('ActivityType')}
                                </strong>
                              </Typography>
                            </TableCell>
                            <TableCell align="right">
                              <Typography
                                variant="body2"
                                className={classes.grayText}
                              >
                                <strong>
                                  {T('Activities')}
                                </strong>
                              </Typography>
                            </TableCell>
                          </TableRow>
                        </TableHead>
                        <TableBody>
                          <TableRow>
                            <TableCell
                              component="th"
                              scope="row"
                              className={classes.questionHeader}
                            >
                              {T('DailyIndoorOutdoorActivity')}
                            </TableCell>
                            <TableCell align="right">
                              {dailyIndoorOutdoorActivity?.join(", ") || '-'}
                            </TableCell>
                          </TableRow>
                          <TableRow>
                            <TableCell
                              component="th"
                              scope="row"
                              className={classes.questionHeader}
                            >
                              {T('IndividualFreeTimeActivity')}
                            </TableCell>
                            <TableCell align="right">
                              {individualFreeTimeActivity?.join(", ") || '-'}
                            </TableCell>
                          </TableRow>
                          <TableRow>
                            <TableCell
                              component="th"
                              scope="row"
                              className={classes.questionHeader}
                            >
                              {T('CommunityActivity')}
                            </TableCell>
                            <TableCell align="right">
                              {communityActivity?.join(", ") || '-'}
                            </TableCell>
                          </TableRow>
                          <TableRow>
                            <TableCell
                              component="th"
                              scope="row"
                              className={classes.questionHeader}
                            >
                              {T('FamilyActivity')}
                            </TableCell>
                            <TableCell align="right">
                              {familyActivity?.join(", ") || '-'}
                            </TableCell>
                          </TableRow>
                        </TableBody>
                      </Table>
                    </TableContainer>
                  </Grid>
                </>
              )}
            </Grid>
          </div>
        </DialogContent>
        <DialogActions>
          <Button onClick={close} color="primary" variant="contained">
            {T('Close')}
          </Button>
        </DialogActions>
      </Dialog>
    </>
  )
}

export default RecreationLogDetails
