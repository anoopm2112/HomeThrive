import { gql } from '@apollo/client'

export const CHILD_FRAGMENT_SHALLOW = gql`
  fragment ChildInfoShallow on Child {
    id
    firstName
    lastName
    dateOfBirth
    agentName
    logsCount
    parent {
      id
      firstName
      lastName
      secondaryParents {
        firstName
        lastName
      }
    }
  }
`

export const CHILD_FRAGMENT_DEEP = gql`
  fragment ChildInfoDeep on Child {
    id
    agencyId
    agencyName
    agentId
    agentName
    dateOfBirth
    firstName
    fosterCareStartDate
    lastName
    level
    level
    logsCount
    medicaidNumber
    notes
    placementId
    parent {
      id
      firstName
      lastName
      secondaryParents {
        firstName
        lastName
      }
    }
    collaborators {
      id
      firstName
      lastName
      association
      phoneNumber
      email
    }
  }
`

export const CHILD_LOG_FRAGMENT = gql`
  fragment ChildLogFragment on ChildLog {
    id
    childId
    childName
    date
    behavioralIssues
    behavioralIssuesComments
    childMoodRating
    childMoodComments
    dayRating
    dayRatingComments
    familyVisit
    familyVisitComments
    parentMoodComments
    parentMoodRating
    medicationChange
    medicationChangeComments
    createdAt
    updatedAt
    images {
      imageURL
    }
    notes {
      authorName
      createdAt
      id
      text
    }
  }
`

export const GET_CHILDREN = gql`
  query GetChildren($input: GetChildrenInput!) {
    children(input: $input) {
      items {
        ...ChildInfoShallow
      }
      pageInfo {
        cursor
        hasNextPage
        count
      }
    }
  }

  ${CHILD_FRAGMENT_SHALLOW}
`

export const GET_CHILD = gql`
  query GetChild($input: GetChildInput!) {
    child(input: $input) {
      ...ChildInfoDeep
    }
  }

  ${CHILD_FRAGMENT_DEEP}
`

export const CREATE_CHILD = gql`
  mutation CreateChild($input: CreateChildInput!) {
    createChild(input: $input) {
      ...ChildInfoDeep
    }
  }

  ${CHILD_FRAGMENT_DEEP}
`

export const UPDATE_CHILD = gql`
  mutation UpdateChild($input: UpdateChildInput!) {
    updateChild(input: $input) {
      ...ChildInfoDeep
    }
  }

  ${CHILD_FRAGMENT_DEEP}
`

export const GET_CHILD_LOGS = gql`
  query GetChildLogs($input: GetChildLogsInput!) {
    childLogs(input: $input) {
      items {
        ...ChildLogFragment
      }
      pageInfo {
        cursor
        hasNextPage
        count
      }
    }
  }

  ${CHILD_LOG_FRAGMENT}
`

export const GET_CHILDREN_LOGS = gql`
  query GetChildrenLogs($input: GetChildrenLogsInput!) {
    childrenLogs(input: $input) {
      items {
        ...ChildLogFragment
      }
      pageInfo {
        cursor
        hasNextPage
        count
      }
    }
  }

  ${CHILD_LOG_FRAGMENT}
`

export const GET_LOG = gql`
  query GetChildLog($input: GetChildLogInput!) {
    childLog(input: $input) {
      ...ChildLogFragment
      submittedBy
    }
  }

  ${CHILD_LOG_FRAGMENT}
`

export const GET_CHILDREN_MED_LOGS = gql`
  query GetMedLogs($input: GetMedLogsInput!) {
    medLogs(input: $input) {
      items {
        id
        child {
          firstName
          lastName
        },
        childSex
        prescriptionDate
        month
        year
      }
      pageInfo {
        cursor
        hasNextPage
        count
      }
    }
  }
`

export const GET_CHILDREN_MED_LOG = gql`
  query GetMedLog($input: GetMedLogInput!) {
    medLog(input: $input) {
      id
      child {
        firstName
        lastName
      }
      family {
        firstName
        lastName
      }
      childSex
      prescriptionDate
      month
      year
      allergies
      signingStatus
      isSubmitted
      medications {
        id
        medicationName
        reason
        dosage
        strength
        notes {
          id
          content
          enteredBy
        }
      },
      createdAt
    }
  }
`

export const GET_MED_LOG_MEDICATION_LIST = gql`
  query GetMedLog($input: GetMedLogInput!) {
    medLog(input: $input) {
      id
      medications {
        id
        medicationName
        reason
        dosage
        strength
        prescriptionDate
        physicianName
        notes {
          id
          content
          enteredBy
        }
      }
    }
  }
`

export const GET_MED_LOG_DOCUMENT = gql`
  query GetMedLog($input: GetMedLogInput!) {
    medLog(input: $input) {
      id
      documentUrl
    }
  }
`

export const GET_MEDLOG_ENTRIES = gql`
  query GetMedLogEntries($input: GetMedLogEntriesInput!) {
    medLogEntries(input: $input) {
      items {
        id
        dateTime
        dateString
        timeString
        isFailure
        given
        failureReason
        failureDescription
        enteredBy
        medication {
          medicationName
        }
        notesCount
        notes {
          id
          content
          enteredBy
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

export const GET_RECREATION_LOGS = gql`
  query GetRecreationLogs($input: GetRecreationLogsInput!) {
    recreationLogs(input: $input) {
      items {
        id
        createdAt
        activityComment
        familyActivity
        date
        child {
          firstName
          lastName
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

export const GET_RECREATION_LOG = gql`
  query GetRecreationLog($input: GetRecreationLogInput!) {
    recreationLog(input: $input) {
      id
      createdAt
      activityComment
      dailyIndoorOutdoorActivity
      individualFreeTimeActivity
      communityActivity
      familyActivity
      date
      child {
        firstName
        lastName
      }
      family {
        firstName
        lastName
      }
    }
  }
`