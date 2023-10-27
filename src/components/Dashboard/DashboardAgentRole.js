import React from 'react'
import _ from 'lodash'
import Paper from '@material-ui/core/Paper'
import { useQuery } from '@apollo/client'
import Link from 'next/link'

// styles
import useStyles from '~/styles/dashboard.styles'

// utilities
import { GET_CHILDREN_LOGS } from '~/lib/queries/children'
import {
  GET_DASHBOARD_CASE_MANAGER_UPCOMING_VISITS,
  CASE_MANAGER_GET_NOTIFICATIONS,
} from '~/lib/queries/dashboard'
import T from '~/lib/text'

// components
import {
  dashboardCaseManagerLogSummaryCellLayout,
  dashboardCaseManagerUpcomingVisitsCellLayout,
} from '~/components/Dashboard/table-layouts'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import LogDetails from '~/components/Details/LogDetails'
import {
  PlaceholderChildrenLogs,
  PlaceholderUpcomingVisits,
} from '~/components/Tables/Placeholders'

const DashboardAgentRole = (props) => {
  const classes = useStyles()

  // query dashboard stats
  const {
    loading: fetchLoading,
    data: fetchData,
    error: fetchError,
  } = useQuery(CASE_MANAGER_GET_NOTIFICATIONS, {
    fetchPolicy: 'no-cache',
    variables: {
      input: {
        pagination: {
          limit: 10,
        },
      },
    },
  })

  // search & pagination
  function variableBuilderLogSummary({
    router,
    searchTerm,
    rowsPerPage,
    cursor,
  }) {
    return {
      input: {
        familyId: undefined,
        search: searchTerm,
        pagination: {
          cursor: cursor,
          limit: rowsPerPage,
        },
      },
    }
  }

  function variableBuilderUpcomingVisits({
    router,
    searchTerm,
    rowsPerPage,
    cursor,
  }) {
    return {
      input: {
        eventType: 'AGENTVISIT',
        fromDate: new Date().toISOString().split('T')[0], // format as YYYY-MM-DD
        search: searchTerm,
        pagination: {
          cursor: cursor,
          limit: rowsPerPage,
        },
      },
    }
  }

  return (
    <div className="dashboard">
      <LogDetails />
      <div className={classes.fsCaseManager}>
        <div className="flex-left-right">
          <div className="left">
            <Paper className={`${classes.paper} ${classes.tileNotifications}`}>
              <div className="subheading">{T('YourNotifications')}</div>
              <div className="heading">
                {fetchData?.notifications?.items?.length
                  ? `${fetchData?.notifications?.items?.length} ${T('New')}`
                  : ''}{' '}
                {T('Notifications')}
              </div>
              <div className="text">{T('NewActionsToTake')}</div>
              <Link href="/families">
                <div className="button">{T('ViewFamilies')}</div>
              </Link>
            </Paper>
            <GenericTable
              title={'upcoming-visits'}
              query={GET_DASHBOARD_CASE_MANAGER_UPCOMING_VISITS}
              variableBuilder={variableBuilderUpcomingVisits}
              cellLayout={dashboardCaseManagerUpcomingVisitsCellLayout}
              dataAccessor={(d) => d?.events?.items || []}
              pageInfoAccessor={(d) => d?.events?.pageInfo}
              allowSelect={false}
              showToolbar={false}
              showPagination={true}
              defaultSortBy={'date'}
              defaultSortDirection={'asc'}
              buttons={''}
              paperClasses={`${classes.paper} ${classes.dashboardTable} ${classes.tableUpcomingVisits}`}
              paperHeader={
                <>
                  <div className="heading">{T('UpcomingVisits')}</div>
                  <div className="subheading">
                    {T('UpcomingVisitsSubheading')}
                  </div>
                </>
              }
              placeholderZeroTableRows={<PlaceholderUpcomingVisits />}
            />
          </div>
          <div className="spacer"></div>
          <div className="right">
            <GenericTable
              title={'children-logs'}
              query={GET_CHILDREN_LOGS}
              variableBuilder={variableBuilderLogSummary}
              cellLayout={dashboardCaseManagerLogSummaryCellLayout}
              dataAccessor={(d) => d?.childrenLogs?.items || []}
              pageInfoAccessor={(d) => d?.childrenLogs?.pageInfo}
              allowSelect={false}
              showToolbar={false}
              showPagination={true}
              buttons={''}
              paperClasses={`${classes.paper} ${classes.dashboardTable} ${classes.tableLogSummary}`}
              paperHeader={
                <>
                  <div className="heading">{T('LogSummary')}</div>
                  <div className="subheading">{T('LogSummarySubheading')}</div>
                </>
              }
              placeholderZeroTableRows={<PlaceholderChildrenLogs />}
            />
          </div>
        </div>
      </div>
    </div>
  )
}

export default DashboardAgentRole
