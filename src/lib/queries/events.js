import { gql } from '@apollo/client'

export const EVENT_PARTICIPANT_FRAGMENT = gql`
  fragment EventParticipantInfo on EventParticipant {
    id
    createdAt
    status
    parentId
    name
    email
    childrenCount
    childrenNames
    location
    image
  }
`

export const EVENT_FRAGMENT = gql`
  fragment EventInfo on Event {
    address
    createdAt
    description
    endsAt
    eventType
    id
    image
    startsAt
    published
    invitationsCount
    rsvpCount
    startsAt
    title
    updatedAt
    venue
  }
`

export const GET_EVENT = gql`
  query GetEvent($input: GetEventInput!) {
    event(input: $input) {
      ...EventInfo
      participants {
        ...EventParticipantInfo
      }
    }
  }
  ${EVENT_FRAGMENT}
  ${EVENT_PARTICIPANT_FRAGMENT}
`

export const GET_EVENTS = gql`
  query GetEvents($input: GetEventsInput!) {
    events(input: $input) {
      items {
        ...EventInfo
        participants {
          ...EventParticipantInfo
        }
      }
      pageInfo {
        cursor
        hasNextPage
        count
      }
    }
  }

  ${EVENT_FRAGMENT}
  ${EVENT_PARTICIPANT_FRAGMENT}
`

export const CREATE_EVENT = gql`
  mutation CreateEvent($input: CreateEventInput!) {
    createEvent(input: $input) {
      ...EventInfo
      participants {
        ...EventParticipantInfo
      }
    }
  }

  ${EVENT_FRAGMENT}
  ${EVENT_PARTICIPANT_FRAGMENT}
`

export const UPDATE_EVENT = gql`
  mutation UpdateEvent($input: UpdateEventInput!) {
    updateEvent(input: $input) {
      ...EventInfo
      participants {
        ...EventParticipantInfo
      }
    }
  }

  ${EVENT_FRAGMENT}
  ${EVENT_PARTICIPANT_FRAGMENT}
`

export const GET_EVENT_PARTICIPANTS = gql`
  query GetEventParticipants($input: GetEventParticipantsInput!) {
    eventParticipants(input: $input) {
      items {
        ...EventParticipantInfo
      }
      pageInfo {
        cursor
        hasNextPage
        count
      }
    }
  }
  ${EVENT_PARTICIPANT_FRAGMENT}
  ${EVENT_PARTICIPANT_FRAGMENT}
`

export const UPDATE_EVENT_PARTICIPANTS = gql`
  mutation UpdateEventParticipants($input: UpdateParticipantsInput!) {
    updateParticipants(input: $input) {
      ...EventInfo
      participants {
        ...EventParticipantInfo
      }
    }
  }

  ${EVENT_FRAGMENT}
  ${EVENT_PARTICIPANT_FRAGMENT}
`
