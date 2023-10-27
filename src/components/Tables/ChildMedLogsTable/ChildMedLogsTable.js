import React from 'react'
import Link from 'next/link'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import Visibility from '@material-ui/icons/Visibility'
import Typography from '@material-ui/core/Typography'
import { GET_CHILDREN_MED_LOGS } from '~/lib/queries/children'
import T from '~/lib/text'

function ChildMedLogsTable({ childId }) {

  const cellLayout = [
    {
      id: 'name',
      disablePadding: true,
      accessor: (d) => d.child.firstName,
      render: (d) => d.child.firstName,
      label: T('ChildName'),
    },
    {
      id: 'childSex',
      disablePadding: false,
      accessor: (d) => d.childSex,
      render: (d) => d.childSex,
      label:'Gender',
    },
    {
      id: 'date',
      disablePadding: false,
      accessor: (d) => new Date(d?.prescriptionDate),
      render: (d) => new Date(d?.prescriptionDate).toLocaleDateString(),
      label: 'Prescription Date',
    },
    {
      id: 'month',
      disablePadding: false,
      accessor: (d) => d.month,
      render: (d) => `${d?.month}, ${d?.year} `,
      label: 'Month',
    },
    {
      id: 'action',
      render: function Action(d) {
        return (
          <Link href={`/medlogs/${d.id}`}>
            <Visibility />
          </Link>
        )
      },
      label: '',
    },
  ]

  function variableBuilder({ router, searchTerm, rowsPerPage, cursor }) {
    return {
      input: {
        childId: childId ? childId : undefined,
        search: searchTerm,
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
        query={GET_CHILDREN_MED_LOGS}
        variableBuilder={variableBuilder}
        cellLayout={cellLayout}
        dataAccessor={(d) => d?.medLogs?.items || []}
        pageInfoAccessor={(d) => d?.medLogs?.pageInfo}
        allowSelect={false}
        showToolbar={false}
        showPagination={true}
        paperHeader={
          <>
            <Typography variant="h3">{T('MedLogTableHeader')}</Typography>
            <div className="subheading">{T('MedLogTableSubHeader')}</div>
          </>
        }
      />
    </>
  )
}

export default ChildMedLogsTable
