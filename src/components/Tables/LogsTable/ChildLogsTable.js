import React, { useState, useEffect } from 'react'
import { useRouter } from 'next/router'
import { useLazyQuery } from '@apollo/client'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import Visibility from '@material-ui/icons/Visibility'
import Button from '@material-ui/core/Button'
import Typography from '@material-ui/core/Typography'
import MoodIcon from '~/components/Icons/MoodIcon'
import { GET_CHILD_LOGS } from '~/lib/queries/children'
import { PlaceholderChildrenLogs } from '~/components/Tables/Placeholders'
import CircularProgress from '@material-ui/core/CircularProgress'
import T from '~/lib/text'

function ChildLogsTable({ childId }) {
  const [isExporting, setIsExporting] = useState(false)
  const router = useRouter()

  // export query
  const [
    exportLogs,
    { loading: exportLoading, data: exportData, error: exportError },
  ] = useLazyQuery(GET_CHILD_LOGS, {
    fetchPolicy: 'network-only',
    onCompleted: () => setIsExporting(false),
    variables: {
      input: {
        id: childId,
        search: '',
        pagination: {
          limit: 10000,
        },
      },
    },
  })

  function handleLogRoute(logId) {
    const { id } = router.query
    router.push(
      {
        query: {
          id,
          log: logId,
        },
      },
      undefined,
      {
        scroll: false,
      }
    )
  }

  function handleExport() {
    setIsExporting(true)
    exportLogs({
      fetchPolicy: 'network-only',
      onCompleted: () => setIsExporting(false),
      variables: {
        input: {
          id: childId,
          search: '',
          pagination: {
            limit: 10000,
          },
        },
      },
    })
  }

  const cellLayout = [
    {
      id: 'date',
      disablePadding: false,
      accessor: (d) => new Date(d?.date),
      render: (d) => new Date(d?.date).toLocaleDateString(),
      label: T('Date'),
    },
    {
      id: 'day',
      disablePadding: false,
      accessor: (d) => d.dayRating,
      render: function DayRating(d) {
        return <MoodIcon rating={d?.dayRating} />
      },
      label: T('DayRating'),
    },
    {
      id: 'parent',
      disablePadding: false,
      accessor: (d) => d.parentMoodRating,
      render: function ParentRating(d) {
        return <MoodIcon rating={d?.parentMoodRating} />
      },
      label: T('ParentMoodLabel'),
      hiddenOn: ['xs', 'sm', 'md'],
    },
    {
      id: 'child',
      disablePadding: false,
      accessor: (d) => d.childMoodRating,
      render: function ChildRating(d) {
        return <MoodIcon rating={d?.childMoodRating} />
      },
      label: T('ChildMoodLabel'),
    },
    {
      id: 'issue',
      disablePadding: false,
      accessor: (d) => (d?.behavioralIssues || []).length,
      render: (d) => ((d?.behavioralIssues || []).length > 0 ? 'Yes' : 'No'),
      label: T('BehavioralIssue'),
    },
    {
      id: 'action',
      render: function Action(d) {
        return <Visibility onClick={() => handleLogRoute(d.id)} />
      },
      label: '',
    },
  ]

  function Buttons({ visibleData }) {
    return (
      <Button
        color="primary"
        variant="contained"
        onClick={handleExport}
        disabled={exportLoading}
        endIcon={
          exportLoading && (
            <CircularProgress style={{ color: 'white' }} size={12} />
          )
        }
      >
        {T('Export')}
      </Button>
    )
  }

  function variableBuilder({ router, searchTerm, rowsPerPage, cursor }) {
    return {
      input: {
        id: childId,
        search: searchTerm,
        pagination: {
          cursor: cursor,
          limit: rowsPerPage,
        },
      },
    }
  }

  // Format and export
  useEffect(() => {
    if (!exportLoading && exportData) {
      // console.log('EXPORT DATA', exportData)
      let csvContent = 'data:text/csv;charset=utf-8,'
      const logs = exportData?.childLogs?.items

      const headers = logs[0] ? Object.keys(logs[0]) : []
      csvContent += headers.join(',') + '\n'
      logs.forEach((p) => {
        const entries = Object.entries(p)
        const toAppend =
          entries
            .map(([key, value]) => {
              return key === 'notes' ? JSON.stringify(value.text) : value
            })
            .join(',') + '\n'
        csvContent += toAppend
      })
      const encodedURI = encodeURI(csvContent)
      window.open(encodedURI)
    }
  }, [exportData, exportLoading])

  return (
    <>
      <GenericTable
        title={'children-logs'}
        query={GET_CHILD_LOGS}
        variableBuilder={variableBuilder}
        cellLayout={cellLayout}
        dataAccessor={(d) => d?.childLogs?.items || []}
        pageInfoAccessor={(d) => d?.childLogs?.pageInfo}
        allowSelect={false}
        showToolbar={true}
        showPagination={true}
        buttons={Buttons}
        paperHeader={
          <>
            <Typography variant="h3">{T('LogTableHeader')}</Typography>
            <div className="subheading">{T('LogTableSubHeader')}</div>
          </>
        }
        placeholderZeroTableRows={<PlaceholderChildrenLogs />}
      />
    </>
  )
}

export default ChildLogsTable
