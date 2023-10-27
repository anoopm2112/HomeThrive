import { gql } from '@apollo/client'

export const GET_DASHBOARD_FS_ADMIN_STATS = gql`
  query GetFostershareDashboard {
    weeklyLogsPercentage
    weeklyEventAttendancePercentage
    weeklyLogsSummary {
      incompleteLogs
      hardDayLogs
      sosoLogs
      averageLogs
      goodLogs
      greatLogs
    }
    familiesCount
    childrenCount
  }
`

export const GET_DASHBOARD_AGENCY_STATS = gql`
  query GetAgencyDashboard {
    agencyProfile {
      agentsCount
      childrenCount
      familiesCount
    }
  }
`

export const GET_DASHBOARD_AGENCY_UPCOMING_VISITS = gql`
  query GetAgencyDashboard($input: GetEventsInput!) {
    events(input: $input) {
      items {
        id
        eventType
        startsAt
        participants {
          id
          name
          agentName
          childrenNames
          status
        }
      }
      pageInfo {
        cursor
        hasNextPage
        count
      }
    }
  }
`

export const GET_DASHBOARD_CASE_MANAGER_UPCOMING_VISITS = gql`
  query GetAgencyDashboard($input: GetEventsInput!) {
    events(input: $input) {
      items {
        id
        eventType
        startsAt
        participants {
          id
          name
          agentName
          childrenNames
          status
        }
      }
      pageInfo {
        cursor
        hasNextPage
        count
      }
    }
  }
`

export const CASE_MANAGER_GET_NOTIFICATIONS = gql`
  query GetNotifications($input: GetNotificationsInput!) {
    notifications(input: $input) {
      items {
        ...NotificationInfo
      }
      pageInfo {
        cursor
        hasNextPage
        count
      }
    }
  }

  fragment NotificationInfo on Notification {
    id
    createdAt
    title
    body
    parentId
    parentName
    childrenName
    read
  }
`
