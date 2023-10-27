import React, { useEffect, useState } from 'react'
import { useRouter } from 'next/router'
import { useQuery } from '@apollo/client'
import { GET_LOG } from '~/lib/queries/children'
import MoodIcon from '~/components/Icons/MoodIcon'
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
import BehaviorIssueIcon from '~/components/Icons/BehaviorIssueIcon.js'
import useStyles from './LogDetails.styles.js'
import Modal from '@material-ui/core/Modal'
import T from '~/lib/text'

function LogDetails() {
  const classes = useStyles()
  const router = useRouter()
  const { log: logId, id: childId } = router?.query
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
  } = useQuery(GET_LOG, {
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
    createdAt,
    updatedAt,
    childName,
    date,
    dayRating,
    dayRatingComments,
    firstName,
    lastName,
    childMoodRating,
    childMoodComments,
    parentMoodRating,
    parentMoodComments,
    familyVisit,
    familyVisitComments,
    behavioralIssues,
    behavioralIssuesComments,
    notes,
    medicationChange,
    medicationChangeComments,
    images,
    submittedBy
  } = fetchData?.childLog || {}

  const dateToShow = new Date(date).toLocaleDateString()
  const noteEls = (notes || []).map((e, i) => {
    const datetime = new Date(e.createdAt)
    const dayString = datetime.toLocaleDateString()
    const time = datetime.toLocaleTimeString([], {
      hour: '2-digit',
      minute: '2-digit',
    })
    const day =
      new Date().toLocaleDateString() === dayString ? T('Today') : dayString
    return (
      <div className={classes.note} key={e.id}>
        <div className={classes.noteHeader}>
          <Typography variant="body2" className={classes.noteTitle}>
            {T('AddedBy')}: {e.authorName}
          </Typography>
          <Typography variant="body2" className={classes.noteCreatedAt}>
            {day} {time}
          </Typography>
        </div>
        <Typography variant="body2" className={classes.noteText}>
          {e.text}
        </Typography>
      </div>
    )
  })

  const imageCards = (images || []).map((e, i) => (
    <img
      key={e.imageURL}
      className={classes.image}
      src={e.imageURL}
      onClick={() => setImage(e.imageURL)}
    />
  ))

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
              <Typography variant="h2">{T('LogsHeader')}</Typography>
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
                                <strong>{T('Question')}</strong>
                              </Typography>
                            </TableCell>
                            <TableCell align="right">
                              <Typography
                                variant="body2"
                                className={classes.grayText}
                              >
                                <strong>{T('Answer')}</strong>
                              </Typography>
                            </TableCell>
                            <TableCell align="right">
                              <Typography
                                variant="body2"
                                className={classes.grayText}
                              >
                                <strong>{T('Comments')}</strong>
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
                              {T('ChildMood')}
                            </TableCell>
                            <TableCell align="right">
                              <MoodIcon rating={childMoodRating} />
                            </TableCell>
                            <TableCell align="right">
                              {childMoodComments || '--'}
                            </TableCell>
                          </TableRow>
                          <TableRow>
                            <TableCell
                              component="th"
                              scope="row"
                              className={classes.questionHeader}
                            >
                              {T('ParentMood')}
                            </TableCell>
                            <TableCell align="right">
                              <MoodIcon rating={parentMoodRating} />
                            </TableCell>
                            <TableCell align="right">
                              {parentMoodComments || '--'}
                            </TableCell>
                          </TableRow>
                          <TableRow>
                            <TableCell
                              component="th"
                              scope="row"
                              className={classes.questionHeader}
                            >
                              {T('BehavioralIssues')}
                            </TableCell>
                            <TableCell align="right">
                              {(behavioralIssues || []).length ? (
                                behavioralIssues.map((e, i) => (
                                  <BehaviorIssueIcon
                                    key={`${e.id}.${i}`}
                                    issue={behavioralIssues[i]}
                                  />
                                ))
                              ) : (
                                <span className={classes.box}>{T('No')}</span>
                              )}
                            </TableCell>
                            <TableCell align="right">
                              {behavioralIssuesComments || '--'}
                            </TableCell>
                          </TableRow>
                          <TableRow>
                            <TableCell
                              component="th"
                              scope="row"
                              className={classes.questionHeader}
                            >
                              {T('BioFamilyContact')}
                            </TableCell>
                            <TableCell align="right">
                              {familyVisit ? (
                                <span className={classes.box}>{T('Yes')}</span>
                              ) : (
                                <span className={classes.box}>{T('No')}</span>
                              )}
                            </TableCell>
                            <TableCell align="right">
                              {familyVisitComments || '--'}
                            </TableCell>
                          </TableRow>
                          <TableRow>
                            <TableCell
                              component="th"
                              scope="row"
                              className={classes.questionHeader}
                            >
                              {T('MedicationChange')}
                            </TableCell>
                            <TableCell align="right">
                              {medicationChange ? (
                                <span className={classes.box}>{T('Yes')}</span>
                              ) : (
                                <span className={classes.box}>{T('No')}</span>
                              )}
                            </TableCell>
                            <TableCell align="right">
                              {medicationChangeComments || '--'}
                            </TableCell>
                          </TableRow>
                          <TableRow>
                            <TableCell
                              component="th"
                              scope="row"
                              className={classes.questionHeader}
                            >
                              {T('Overall')}
                            </TableCell>
                            <TableCell align="right">
                              <MoodIcon rating={dayRating} />
                            </TableCell>
                            <TableCell align="right">
                              {dayRatingComments || '--'}
                            </TableCell>
                          </TableRow>
                        </TableBody>
                      </Table>
                    </TableContainer>
                  </Grid>
                  <Grid item xs={7}>
                    <Typography variant="h3">{T('Notes')}:</Typography>
                    <div className={classes.notes}>
                      {noteEls.length > 0 ? (
                        noteEls
                      ) : (
                        <Typography className={classes.note}>
                          {T('NoNotes')}
                        </Typography>
                      )}
                    </div>
                  </Grid>
                  <Grid item xs={5}>
                    <Typography variant="h3">
                      {T('Images')}: {(images || []).length}
                      <div className={classes.images}>{imageCards}</div>
                    </Typography>
                  </Grid>
                  <Grid item xs={12}>
                    <Typography variant="h4">Submitted By:</Typography>
                    <Typography variant="body1">{submittedBy}</Typography>
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

export default LogDetails
