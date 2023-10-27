import { gql } from '@apollo/client'

export const MESSAGE_FRAGMENT = gql`
  fragment MessageInfo on Message {
    id
    createdAt
    title
    body
    status
    senderName
    recipientName
  }
`

export const SCHEDULED_MESSAGE_FRAGMENT = gql`
  fragment ScheduledMessageInfo on ScheduledMessage {
    id
    createdAt
    title
    body
    senderName
    recipientName
    status
    schedule
    repeat
    frequency
  }
`

export const GET_MESSAGES = gql`
  query GetMessages($input: GetMessagesInput!) {
    messages(input: $input) {
      items {
        ...MessageInfo
      }
      pageInfo {
        cursor
        hasNextPage
        count
      }
    }
  }
  ${MESSAGE_FRAGMENT}
`

export const CREATE_MESSAGE = gql`
  mutation CreateMessage($input: CreateMessageInput!) {
    createMessage(input: $input) {
      ...MessageInfo
    }
  }
  ${MESSAGE_FRAGMENT}
`

export const GET_SCHEDULED_MESSAGES = gql`
  query GetScheduledMessages($input: GetScheduledMessagesInput!) {
    scheduledMessages(input: $input) {
      items {
        ...ScheduledMessageInfo
      }
      pageInfo {
        cursor
        hasNextPage
        count
      }
    }
  }
  ${SCHEDULED_MESSAGE_FRAGMENT}
`

export const CREATE_SCHEDULED_MESSAGE = gql`
  mutation CreateScheduledMessage($input: CreateScheduledMessageInput!) {
    createScheduledMessage(input: $input) {
      ...ScheduledMessageInfo
    }
  }
  ${SCHEDULED_MESSAGE_FRAGMENT}
`

export const DISABLE_SCHEDULED_MESSAGE = gql`
  mutation DisableScheduledMessage($input: DisableScheduledMessageInput!) {
    disableScheduledMessage(input: $input) {
      ...ScheduledMessageInfo
    }
  }
  ${SCHEDULED_MESSAGE_FRAGMENT}
`
