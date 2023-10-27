import { gql } from '@apollo/client'

export const NOTIFICATION_FRAGMENT = gql`
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
export const GET_NOTIFICATIONS = gql`
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

  ${NOTIFICATION_FRAGMENT}
`

export const MARK_NOTIFICATION_AS_READ = gql`
  mutation MarkNotificationAsRead($input: MarkNotificationAsReadInput!) {
    markNotificationAsRead(input: $input) {
      ...NotificationInfo
    }
  }
  ${NOTIFICATION_FRAGMENT}
`
