import React, { useState } from 'react'
import { useQuery } from '@apollo/client'
import Visibility from '@material-ui/icons/Visibility'
import Paper from '@material-ui/core/Paper'
import Typography from '@material-ui/core/Typography'
import CircularProgress from '@material-ui/core/CircularProgress'
import Table from '@material-ui/core/Table'
import TableBody from '@material-ui/core/TableBody'
import TableHead from '@material-ui/core/TableHead'
import TableCell from '@material-ui/core/TableCell'
import TableContainer from '@material-ui/core/TableContainer'
import TableRow from '@material-ui/core/TableRow'
import Alert from '@material-ui/lab/Alert'
import { GET_MED_LOG_MEDICATION_LIST } from '~/lib/queries/children'
import useStyles from '../LogsTable/ChildLogsTable.styles.js'
import MedicationNotes from './MedicationNotes'
import T from '~/lib/text'

function MedicationList({ medlogId }) {
  const [openNotes, setOpenNotes] = useState(false)
  const [selectedMedication, setSelectedMedication] = useState([])
  const classes = useStyles()

  const {
    loading: fetchLoading,
    data: fetchData,
    error,
  } = useQuery(GET_MED_LOG_MEDICATION_LIST, {
    skip: !medlogId,
    variables: { input: { id: medlogId } }
  })

  function openNoteModal(medication) {
    setSelectedMedication(medication)
    setOpenNotes(true)
  }
  
  const medications = fetchData?.medLog.medications

  return (
    <>
    <Paper className={classes.paper} style={{padding: '16px 0'}}>
      {fetchLoading ? (
        <div style={{padding: '0 24px'}}>
          <CircularProgress />
        </div>
      ) : (
      <>
      <div className={classes.articleHeader} style={{padding: '0 16px'}}>
        {error && <Alert severity="error">{error.message}</Alert>}
        <Typography className={classes.articleDetailsTitle} variant="h3">
          {T('MedicationList')}
        </Typography>
      </div>
      <TableContainer className={classes.tableContainer}>
        <Table
          aria-labelledby="Table"
          size="medium"
          aria-label="Medication List"
        >
          <TableHead>
            <TableRow>
              <TableCell><strong>Medication Name</strong></TableCell>
              <TableCell><strong>Reason</strong></TableCell>
              <TableCell><strong>Dosage</strong></TableCell>
              <TableCell><strong>Strength</strong></TableCell>
              <TableCell><strong>Physician Name</strong></TableCell>
              <TableCell><strong>Prescription Date</strong></TableCell>
              <TableCell><strong>Notes</strong></TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {medications?.map((medication, index) => {
              return (
                <TableRow
                  key={`${medication.id}.${index}`}
                  sx={{ '&:last-child td, &:last-child th': { border: 0 } }}
                >
                  <TableCell>{medication.medicationName}</TableCell>
                  <TableCell>{medication.reason}</TableCell>
                  <TableCell>{medication.dosage}</TableCell>
                  <TableCell>{medication.strength}</TableCell>
                  <TableCell>{medication.physicianName || '-'}</TableCell>
                  <TableCell>{medication.prescriptionDate ? new Date(medication.prescriptionDate).toLocaleDateString() : '-'}</TableCell>
                  <TableCell align="center">
                    {medication.notes.length ? <Visibility onClick={() => openNoteModal(medication)}/> : <></>}
                  </TableCell>
                </TableRow>
              )
            })}
          </TableBody>
        </Table>
      </TableContainer>
      </>
    )}
    </Paper>
    {openNotes && <MedicationNotes notes={selectedMedication.notes} medicationName={selectedMedication.medicationName} closeNotes={() => setOpenNotes(false)} />}
    </>
  )
}

export default MedicationList
