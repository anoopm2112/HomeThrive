import React from 'react'
import Link from 'next/link'
import _ from 'lodash'
import Visibility from '@material-ui/icons/Visibility'
import MoodIcon from '~/components/Icons/MoodIcon'
import { useRouter } from 'next/router'

const hiddenOn_upcomingVisits_childName = ['xs', ]
const hiddenOn_logSummary_dayRating = {
  hiddenOnDrawerOpen: ['xs', 'md'],
  hiddenOnDrawerClosed: ['xs'],
}
const hiddenOn_logSummary_childMood = {
  hiddenOnDrawerOpen: ['xs', 'sm', 'md'],
  hiddenOnDrawerClosed: ['xs', 'md'],
}
const hiddenOn_logSummary_parentMood = {
  hiddenOnDrawerOpen: ['xs', 'sm', 'md', 'lg'],
  hiddenOnDrawerClosed: ['xs', 'sm', 'md'],
}
const hiddenOn_logSummary_behavioralIssue = {
  hiddenOnDrawerOpen: ['xs', 'sm', 'md', 'lg', ],
  hiddenOnDrawerClosed: ['xs', 'sm', 'md', 'lg', ],
}

export const dashboardAdminListCellLayout = [
  {
    id: 'name',
    disablePadding: true,
    accessor: (d) => d.name,
    render: (d) => d.name,
    label: 'Agency',
  },
  {
    id: 'location',
    disablePadding: false,
    accessor: (d) => d.city,
    render: (d) => d.city,
    label: 'Location',
    hiddenOn: ['xs', 'sm'],
  },
  // @FIXME - missing adminsCount in data model
  // {
  //   id: 'n_admins',
  //   disablePadding: false,
  //   accessor: (d) => d?.poc?.email,
  //   render: (d) => (d?.poc?.email || '--'),
  //   label: '# of Admins',
  // },
  {
    id: 'agents',
    disablePadding: false,
    accessor: (d) => d?.agentsCount,
    render: (d) => d?.agentsCount,
    label: '# of Case Managers',
    hiddenOn: ['xs', 'sm'],
  },
  {
    id: 'children',
    disablePadding: false,
    accessor: (d) => d?.childrenCount,
    render: (d) => d?.childrenCount,
    label: '# of Children',
    hiddenOn: ['xs', 'sm'],
  },
  {
    id: 'action',
    render: function Action(d) {
      return (
        <Link href={`/agencies/${d.id}`}>
          <Visibility />
        </Link>
      )
    },
    label: '',
  },
]

export const dashboardAgencyUpcomingVisitsCellLayout = [
  {
    id: 'case-manager',
    disablePadding: true,
    accessor: (d) => {
      return d?.participants?.[0]?.agentName || ''
    },
    render: (d) => {
      return d?.participants?.[0]?.agentName || ''
    },
    label: 'Case Manager',
  },
  {
    id: 'child-visiting',
    disablePadding: true,
    accessor: (d) => {
      const users = d?.participants.filter((user) => {
        return user?.childrenNames?.length || false
      })
      return users?.[0]?.childrenNames?.join?.(', ') || ''
    },
    render: (d) => {
      const users = d?.participants.filter((user) => {
        return user?.childrenNames?.length || false
      })
      return users?.[0]?.childrenNames?.join?.(', ') || ''
    },
    label: 'Child Name',
    hiddenOn: hiddenOn_upcomingVisits_childName,
  },
  {
    id: 'date',
    disablePadding: false,
    accessor: (d) => new Date(d?.startsAt),
    render: (d) => new Date(d?.startsAt).toLocaleDateString(),
    label: 'Date',
  },
  {
    id: 'rsvp',
    disablePadding: true,
    accessor: (d) => {
      // @FIXME need to only provide Case Manager and not Parent participant
      return _.startCase((d?.participants?.[0]?.status || '—').toLowerCase())
    },
    render: (d) => {
      // @FIXME need to only provide Case Manager and not Parent participant
      return _.startCase((d?.participants?.[0]?.status || '—').toLowerCase())
    },
    label: 'RSVP',
  },
]

export const dashboardAgencyLogSummaryCellLayout = [
  {
    id: 'name',
    disablePadding: true,
    accessor: (d) => d.childName,
    render: (d) => d.childName,
    label: 'Child Name',
  },
  {
    id: 'date',
    disablePadding: false,
    accessor: (d) => new Date(d?.date),
    render: (d) => new Date(d?.date).toLocaleDateString(),
    label: 'Date',
  },
  {
    id: 'day',
    disablePadding: false,
    accessor: (d) => d.dayRating,
    render: function Mood(d) {
      return <MoodIcon rating={d?.dayRating} />
    },
    label: 'Day Rating',
    ...hiddenOn_logSummary_dayRating,
  },
  {
    id: 'parent',
    disablePadding: false,
    accessor: (d) => d.parentMoodRating,
    render: function Mood(d) {
      return <MoodIcon rating={d?.parentMoodRating} />
    },
    label: 'Parent Mood',
    ...hiddenOn_logSummary_parentMood,
  },
  {
    id: 'child',
    disablePadding: false,
    accessor: (d) => d.childMoodRating,
    render: function Mood(d) {
      return <MoodIcon rating={d?.childMoodRating} />
    },
    label: 'Child Mood',
    ...hiddenOn_logSummary_childMood,
  },
  {
    id: 'issue',
    disablePadding: false,
    accessor: (d) => (d?.behavioralIssues || []).length,
    render: (d) => ((d?.behavioralIssues || []).length > 0 ? 'Yes' : 'No'),
    label: 'Behavioral Issue',
    ...hiddenOn_logSummary_behavioralIssue,
  },
  {
    id: 'action',
    render: function Action(d, router) {
      return (
        <Visibility
          onClick={() => {
            const { id } = router.query
            router.push(
              {
                query: {
                  id,
                  log: d.id,
                },
              },
              undefined,
              {
                scroll: false,
              }
            )
          }}
        />
      )
    },
    label: '',
  },
]

export const dashboardCaseManagerUpcomingVisitsCellLayout = [
  {
    id: 'case-manager',
    disablePadding: true,
    accessor: (d) => {
      return d?.participants?.[0]?.agentName || ''
    },
    render: (d) => {
      return d?.participants?.[0]?.agentName || ''
    },
    label: 'Case Manager',
  },
  {
    id: 'child-visiting',
    disablePadding: true,
    accessor: (d) => {
      const users = d?.participants.filter((user) => {
        return user?.childrenNames?.length || false
      })
      return users?.[0]?.childrenNames?.join?.(', ') || ''
    },
    render: (d) => {
      const users = d?.participants.filter((user) => {
        return user?.childrenNames?.length || false
      })
      return users?.[0]?.childrenNames?.join?.(', ') || ''
    },
    label: 'Child Name',
    hiddenOn: hiddenOn_upcomingVisits_childName,
  },
  {
    id: 'date',
    disablePadding: false,
    accessor: (d) => new Date(d?.startsAt),
    render: (d) => new Date(d?.startsAt).toLocaleDateString(),
    label: 'Date',
  },
  {
    id: 'rsvp',
    disablePadding: true,
    accessor: (d) => {
      // @FIXME need to only provide Case Manager and not Parent participant
      return _.startCase((d?.participants?.[0]?.status || '—').toLowerCase())
    },
    render: (d) => {
      // @FIXME need to only provide Case Manager and not Parent participant
      return _.startCase((d?.participants?.[0]?.status || '—').toLowerCase())
    },
    label: 'RSVP',
  },
]

export const dashboardCaseManagerLogSummaryCellLayout = [
  {
    id: 'name',
    disablePadding: true,
    accessor: (d) => d.childName,
    render: (d) => d.childName,
    label: 'Child Name',
  },
  {
    id: 'date',
    disablePadding: false,
    accessor: (d) => new Date(d?.date),
    render: (d) => new Date(d?.date).toLocaleDateString(),
    label: 'Date',
  },
  {
    id: 'day',
    disablePadding: false,
    accessor: (d) => d.dayRating,
    render: function Mood(d) {
      return <MoodIcon rating={d?.dayRating} />
    },
    label: 'Day Rating',
    ...hiddenOn_logSummary_dayRating,
  },
  {
    id: 'parent',
    disablePadding: false,
    accessor: (d) => d.parentMoodRating,
    render: function Mood(d) {
      return <MoodIcon rating={d?.parentMoodRating} />
    },
    label: 'Parent Mood',
    ...hiddenOn_logSummary_parentMood,
  },
  {
    id: 'child',
    disablePadding: false,
    accessor: (d) => d.childMoodRating,
    render: function Mood(d) {
      return <MoodIcon rating={d?.childMoodRating} />
    },
    label: 'Child Mood',
    ...hiddenOn_logSummary_childMood,
  },
  {
    id: 'issue',
    disablePadding: false,
    accessor: (d) => (d?.behavioralIssues || []).length,
    render: (d) => ((d?.behavioralIssues || []).length > 0 ? 'Yes' : 'No'),
    label: 'Behavioral Issue',
    ...hiddenOn_logSummary_behavioralIssue,
  },
  {
    id: 'action',
    render: function Action(d, router) {
      return (
        <Visibility
          onClick={() => {
            const { id } = router.query
            router.push(
              {
                query: {
                  id,
                  log: d.id,
                },
              },
              undefined,
              {
                scroll: false,
              }
            )
          }}
        />
      )
    },
    label: '',
  },
]
