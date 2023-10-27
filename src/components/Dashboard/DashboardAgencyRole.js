// libraries
import React from 'react'
import Paper from '@material-ui/core/Paper'
import { useQuery } from '@apollo/client'

// assets
import Families from '~/lib/assets/icons/family-no-size.svg'
import Children from '~/lib/assets/icons/children-no-size.svg'
import User from '~/lib/assets/icons/user-no-size.svg'
import {
  PlaceholderUpcomingVisits,
  PlaceholderChildrenLogs,
} from '~/components/Tables/Placeholders'

// styles
import useStyles from '~/styles/dashboard.styles'

// utilities
import { GET_CHILDREN_LOGS } from '~/lib/queries/children'
import {
  GET_DASHBOARD_AGENCY_STATS,
  GET_DASHBOARD_AGENCY_UPCOMING_VISITS,
} from '~/lib/queries/dashboard'

// components
import {
  dashboardAgencyLogSummaryCellLayout,
  dashboardAgencyUpcomingVisitsCellLayout,
} from '~/components/Dashboard/table-layouts'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import LogDetails from '~/components/Details/LogDetails'
import T from '~/lib/text'

const DashboardTile = (props) => {
  const classes = useStyles()

  return (
    <Paper className={`${classes.dashboardTile}`}>
      <div className="flex-vertical">
        <div className="subheading">{props.subheading}</div>
        <div className="flex-half">
          <div className="heading">{props.heading}</div>
          <div className="icon">
            <props.icon />
          </div>
        </div>
      </div>
    </Paper>
  )
}

const DashboardAgencyRole = (props) => {
  const classes = useStyles()

  // query dashboard stats
  const {
    loading: fetchLoading,
    data: fetchData,
    error: fetchError,
  } = useQuery(GET_DASHBOARD_AGENCY_STATS, {
    fetchPolicy: 'no-cache',
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
      <div className={classes.fsAgency}>
        <div className="flex-thirds">
          <DashboardTile
            subheading={T('NumberOfAgents')}
            heading={`${fetchData?.agencyProfile?.agentsCount || '—'} ${T(
              'Agents'
            )}`}
            icon={User}
          />
          <div className="spacer"></div>
          <DashboardTile
            subheading={T('NumFamilies')}
            heading={`${fetchData?.agencyProfile?.familiesCount || '—'} ${T(
              'Families'
            )}`}
            icon={Families}
          />
          <div className="spacer"></div>
          <DashboardTile
            subheading={T('NumChildren')}
            heading={`${fetchData?.agencyProfile?.childrenCount || '—'} ${T(
              'Children'
            )}`}
            icon={Children}
          />
        </div>
        <div className="flex-tables">
          <GenericTable
            title={'upcoming-visits'}
            query={GET_DASHBOARD_AGENCY_UPCOMING_VISITS}
            variableBuilder={variableBuilderUpcomingVisits}
            cellLayout={dashboardAgencyUpcomingVisitsCellLayout}
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
          <div className="spacer"></div>
          <GenericTable
            title={'children-logs'}
            query={GET_CHILDREN_LOGS}
            variableBuilder={variableBuilderLogSummary}
            cellLayout={dashboardAgencyLogSummaryCellLayout}
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
  )
}

export default DashboardAgencyRole
