import React, { useState } from 'react'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import Visibility from '@material-ui/icons/Visibility'
import Typography from '@material-ui/core/Typography'
import { GET_MEDLOG_ENTRIES } from '~/lib/queries/children'
import MedLogEntryNotes from './MedLogEntryNotes'
import T from '~/lib/text'

function MedLogEntriesTable({ medlogId }) {
  const [openNotes, setOpenNotes] = useState(false)
  const [selectedEntry, setSelectedEntry] = useState([])

  function openNoteModal(entry) {
    setSelectedEntry(entry)
    setOpenNotes(true)
  }

  const cellLayout = [
    {
      id: 'enteredBy',
      disablePadding: true,
      accessor: (d) => d.enteredBy,
      render: (d) => d.enteredBy,
      label: 'Entered By',
    },
    {
      id: 'date',
      disablePadding: false,
      accessor: (d) => new Date(d?.dateTime),
      render: (d) => new Date(d?.dateTime).toLocaleDateString(),
      label: 'Date',
    },
    {
      id: 'medicationName',
      disablePadding: true,
      accessor: (d) => d.medication.medicationName,
      render: (d) => d.medication.medicationName,
      label: 'Medication Name',
    },
    {
      id: 'given',
      disablePadding: false,
      accessor: (d) => d.given || '-',
      render: (d) => d.given || '-',
      label:'Given',
    },
    {
      id: 'failureReason',
      disablePadding: false,
      accessor: (d) => d.failureReason || '-',
      render: (d) => d.failureReason || '-',
      label:'Failure Reason',
    },
    {
      id: 'failureDescription',
      disablePadding: false,
      accessor: (d) => d.failureDescription || '-',
      render: (d) => d.failureDescription || '-',
      label:'Failure Description',
    },
    {
      id: 'action',
      render: function Action(d) {
        return d.notesCount ? <Visibility onClick={() => openNoteModal(d)} /> : <></>
      },
      label: 'Notes',
    }
  ]

  function variableBuilder({ router, searchTerm, rowsPerPage, cursor }) {
    return {
      input: {
        medLogId: medlogId ? medlogId : undefined,
        pagination: {
          cursor: cursor,
          limit: rowsPerPage,
        },
      },
    }
  }

  return (
    <>
      <GenericTable
        title={'med-logs'}
        query={GET_MEDLOG_ENTRIES}
        variableBuilder={variableBuilder}
        cellLayout={cellLayout}
        dataAccessor={(d) => d?.medLogEntries?.items || []}
        pageInfoAccessor={(d) => d?.medLogEntries?.pageInfo}
        allowSelect={false}
        showToolbar={false}
        showPagination={true}
        paperHeader={
          <>
            <Typography variant="h3">{T('MedLogEntriesTableHeader')}</Typography>
            <div className="subheading">{T('MedLogEntriesTableSubHeader')}</div>
          </>
        }
      />
      {openNotes && 
        <MedLogEntryNotes 
          notes={selectedEntry.notes}
          medicationName={selectedEntry.medication.medicationName}
          entryDate={selectedEntry.dateTime}
          closeNotes={() => setOpenNotes(false)}
        />}
    </>
  )
}

export default MedLogEntriesTable
