import React from 'react'
import { useRouter } from 'next/router'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import Visibility from '@material-ui/icons/Visibility'
import Typography from '@material-ui/core/Typography'
import { GET_RECREATION_LOGS } from '~/lib/queries/children'
import T from '~/lib/text'

function ChildRecreationLogsTable({ childId }) {
  const router = useRouter()

  function handleLogRoute(logId) {
    const { id } = router.query
    router.push(
      {
        query: {
          id,
          recreationlog: logId,
        },
      },
      undefined,
      {
        scroll: false,
      }
    )
  }

  const cellLayout = [
    {
      id: 'name',
      disablePadding: true,
      accessor: (d) => d.child.firstName,
      render: (d) => `${d?.child?.lastName}, ${d?.child?.firstName} `,
      label: T('ChildName'),
    },
    {
      id: 'date',
      disablePadding: false,
      accessor: (d) => new Date(d?.date),
      render: (d) => new Date(d?.date).toLocaleDateString(),
      label: T('Date'),
    },
    {
      id: 'parent',
      disablePadding: false,
      accessor: (d) => d.familyActivity,
      render: (d) => d.familyActivity.join(", "),
      label: 'Family Activity',
    },
    {
      id: 'issue',
      disablePadding: false,
      accessor: (d) => d.activityComment,
      render: (d) => d.activityComment,
      label: 'Activity Comment',
    },
    {
      id: 'action',
      render: function Action(d) {
        return <Visibility onClick={() => handleLogRoute(d.id)} />
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
        query={GET_RECREATION_LOGS}
        variableBuilder={variableBuilder}
        cellLayout={cellLayout}
        dataAccessor={(d) => d?.recreationLogs?.items || []}
        pageInfoAccessor={(d) => d?.recreationLogs?.pageInfo}
        allowSelect={false}
        showToolbar={false}
        showPagination={true}
        paperHeader={
          <>
            <Typography variant="h3">{T('RecreationLogsTableHeader')}</Typography>
            <div className="subheading">{T('RecreationLogsTableSubHeader')}</div>
          </>
        }
      />
    </>
  )
}

export default ChildRecreationLogsTable
