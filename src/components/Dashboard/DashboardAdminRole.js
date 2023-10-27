// libraries
import React from 'react'
import Paper from '@material-ui/core/Paper'
import { useQuery } from '@apollo/client'

// assets
import Families from '~/lib/assets/icons/family-no-size.svg'
import Children from '~/lib/assets/icons/children-no-size.svg'

// styles
import useStyles from '~/styles/dashboard.styles'

// utilities
import { GET_AGENCIES } from '~/lib/queries/agencies'
import { GET_DASHBOARD_FS_ADMIN_STATS } from '~/lib/queries/dashboard'
import { dashboardAdminListCellLayout } from '~/components/Dashboard/table-layouts'
import T from '~/lib/text'

// components
import GenericTable from '~/components/Tables/Generic/GenericTable'
import StackedBarChart from '~/components/Widgets/StackedBarChart'

const DashboardAdminRole = (props) => {
  const classes = useStyles()

  // query dashboard stats
  const {
    loading: fetchLoading,
    data: fetchData,
    error: fetchError,
  } = useQuery(GET_DASHBOARD_FS_ADMIN_STATS, {
    fetchPolicy: 'no-cache',
  })

  // search & pagination
  function variableBuilder({ router, searchTerm, rowsPerPage, cursor }) {
    return {
      input: {
        search: searchTerm,
        pagination: {
          cursor: cursor,
          limit: rowsPerPage,
        },
      },
    }
  }

  // stacked bar charts data
  const barData1 = [
    {
      label: T('DailyLogsCompleted'),
      value: fetchData?.weeklyLogsPercentage || 0.0,
      color: '#B8EE8C',
    },
  ]
  const barData2 = [
    {
      label: T('EventAttendance'),
      value: fetchData?.weeklyEventAttendancePercentage || 0.0,
      color: '#CFEE8C',
    },
  ]
  const barData3 = [
    {
      label: T('Incomplete'),
      value: fetchData?.weeklyLogsSummary?.incompleteLogs || 0,
      color: '#DBE2E7',
    },
    {
      label: T('Bad'),
      value: fetchData?.weeklyLogsSummary?.hardDayLogs || 0,
      color: '#ff0000',
    },
    {
      label: T('Poor'),
      value: fetchData?.weeklyLogsSummary?.sosoLogs || 0,
      color: '#FFA44A',
    },
    {
      label: T('Okay'),
      value: fetchData?.weeklyLogsSummary?.averageLogs || 0,
      color: '#FEE661',
    },
    {
      label: T('Good'),
      value: fetchData?.weeklyLogsSummary?.goodLogs || 0,
      color: '#CFEE8C',
    },
    {
      label: T('Great'),
      value: fetchData?.weeklyLogsSummary?.greatLogs || 0,
      color: '#89E096',
    },
  ]

  return (
    <div className="dashboard">
      <div className={classes.fsAdmin}>
        <div className="charts">
          <div className="flex-half">
            <Paper className={`${classes.paper} ${classes.dashFamilies}`}>
              <div className={`${classes.flexHeadingWithIcon}`}>
                <div className="flex-left">
                  <div className="heading">
                    {fetchData?.familiesCount || '—'} {T('Families')}
                  </div>
                  <div className="subheading">{T('FSAdminFamilySummary')}</div>
                </div>
                <div className="flex-right">
                  <Families />
                </div>
              </div>
              <div className="flex-half">
                <div className="flex-left">
                  <StackedBarChart data={barData1} />
                </div>
                <div className="spacer" />
                <div className="flex-right">
                  <StackedBarChart data={barData2} />
                </div>
              </div>
            </Paper>
            <div className="spacer"></div>
            <Paper className={`${classes.paper} dash-children`}>
              <div className={`${classes.flexHeadingWithIcon}`}>
                <div className="flex-left">
                  <div className="heading">
                    {fetchData?.childrenCount || '—'} {T('Children')}
                  </div>
                  <div className="subheading">
                    {T('FSAdminChildrenSummary')}
                  </div>
                </div>
                <div className="flex-right">
                  <Children />
                </div>
              </div>
              <StackedBarChart data={barData3} />
            </Paper>
          </div>
        </div>
        <GenericTable
          title={'agency'}
          query={GET_AGENCIES}
          variableBuilder={variableBuilder}
          cellLayout={dashboardAdminListCellLayout}
          dataAccessor={(d) => d?.agencies?.items || []}
          pageInfoAccessor={(d) => d?.agencies?.pageInfo}
          allowSelect={false}
          showToolbar={false}
          showPagination={true}
          buttons={''}
          paperClasses={`${classes.paper} ${classes.dashboardTable}`}
          paperHeader={<div className="heading">{T('AgencyOverview')}</div>}
        />
      </div>
    </div>
  )
}

export default DashboardAdminRole
