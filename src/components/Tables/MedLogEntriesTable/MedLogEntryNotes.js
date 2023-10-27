import React from 'react'
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
import useStyles from '~/components/Details/LogDetails.styles.js'
import T from '~/lib/text'

function MedLogEntryNotes({notes, medicationName, entryDate, closeNotes}) {
  const classes = useStyles()

  //  _                 _ _
  // | |_  __ _ _ _  __| | |___ _ _ ___
  // | ' \/ _` | ' \/ _` | / -_) '_(_-<
  // |_||_\__,_|_||_\__,_|_\___|_| /__/
  //

  function close() {
    closeNotes()
  }

  return (
    <>
      <Dialog
        maxWidth="md"
        open={true}
        onClose={close}
        aria-labelledby="log-dialog"
      >
        <DialogTitle>
          <Grid container spacing={2}>
            <Grid item xs={10}>
              <Typography variant="h2">{T('Notes')}</Typography>
            </Grid>
            <Grid item xs={2} className={classes.logDate}>
              <Typography variant="body2">{new Date(entryDate).toLocaleDateString()}</Typography>
            </Grid>
            <Grid item xs={12}>
              <div className="child-details" style={{display: 'flex', alignItems: 'center'}}>
                <Typography variant="body2" style={{marginRight: '5px'}}>Medication Name:</Typography>
                <Typography variant="h4">{medicationName}</Typography>
              </div>
            </Grid>
          </Grid>
        </DialogTitle>
        <DialogContent>
          <div className={classes.logContent}>
            <Grid container spacing={2}>
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
                            <strong>Note</strong>
                          </Typography>
                        </TableCell>
                        <TableCell align="right">
                          <Typography
                            variant="body2"
                            className={classes.grayText}
                          >
                            <strong>Entered By</strong>
                          </Typography>
                        </TableCell>
                      </TableRow>
                    </TableHead>
                    <TableBody>
                      {notes?.map((note, index) => {
                      return (
                          <TableRow
                          key={`${note.id}.${index}`}
                          sx={{ '&:last-child td, &:last-child th': { border: 0 } }}
                          >
                          <TableCell>{note.content}</TableCell>
                          <TableCell align="right">{note.enteredBy}</TableCell>
                          </TableRow>
                      )
                      })}
                  </TableBody>
                  </Table>
                </TableContainer>
              </Grid>
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

export default MedLogEntryNotes
