import { gql } from '@apollo/client'

//                        _
//  __ _ ___ _ _  ___ _ _(_)__   _  _ ___ ___ _ _
// / _` / -_) ' \/ -_) '_| / _| | || (_-</ -_) '_|
// \__, \___|_||_\___|_| |_\__|  \_,_/__/\___|_|
// |___/
//

export const USER_PROFILE_FRAGMENT = gql`
  fragment UserProfileShallow on User {
    agencyId
    agencyName
    cognitoId
    email
    enabled
    firstName
    id
    image
    lastName
    phoneNumber
    role
  }
`

export const UPDATE_PROFILE = gql`
  mutation UpdateProfile($input: UpdateProfileInput!) {
    updateProfile(input: $input) {
      ...UserProfileShallow
    }
  }

  ${USER_PROFILE_FRAGMENT}
`

export const GET_PROFILE = gql`
  query GetProfile {
    profile {
      ...UserProfileShallow
    }
  }

  ${USER_PROFILE_FRAGMENT}
`

export const CREATE_USER = gql`
  mutation CreateUser($input: CreateUserInput!) {
    createUser(input: $input) {
      ...UserProfileShallow
    }
  }

  ${USER_PROFILE_FRAGMENT}
`

export const GET_USERS = gql`
  query GetUsers($input: GetUsersInput!) {
    users(input: $input) {
      items {
        ...UserProfileShallow
      }
      pageInfo {
        cursor
        hasNextPage
        count
      }
    }
  }

  ${USER_PROFILE_FRAGMENT}
`

export const GET_USERS_VARIABLES = (term, limit, cursor = 0) => ({
  input: {
    search: term,
    pagination: {
      cursor: cursor,
      limit: limit,
    },
  },
})

export const ENABLE_USER = gql`
  mutation EnableUser($input: EnableUserInput!) {
    enableUser(input: $input) {
      id
      cognitoId
      enabled
    }
  }
`

export function ENABLE_USER_VARIABLES(id, enabled) {
  return {
    input: {
      id,
      enabled,
    },
  }
}

export const UPDATE_USER = gql`
  mutation UpdateUser($input: UpdateUserInput!) {
    updateUser(input: $input) {
      ...UserProfileShallow
    }
  }

  ${USER_PROFILE_FRAGMENT}
`

//                               __                         _
//  __ _ __ _ ___ _ _  __ _  _  / _|___   __ _ __ _ ___ _ _| |_ ___
// / _` / _` / -_) ' \/ _| || | > _|_ _| / _` / _` / -_) ' \  _(_-<
// \__,_\__, \___|_||_\__|\_, | \_____|  \__,_\__, \___|_||_\__/__/
//      |___/             |__/                |___/
//

export const AGENCY_ADMIN_FRAGMENT = gql`
  fragment AgencyAdminInfo on AgencyAdmin {
    id
    email
    firstName
    lastName
    phoneNumber
  }
`

export const AGENT_INFO_FRAGMENT = gql`
  fragment AgentInfo on CaseAgent {
    id
    firstName
    lastName
    childrenCount
    email
    familiesCount
    phoneNumber
  }
`

export const GET_AGENTS = gql`
  query GetAgents($input: GetAgentsInput!) {
    agents(input: $input) {
      items {
        ...AgentInfo
      }
      pageInfo {
        cursor
        hasNextPage
        count
      }
    }
  }

  ${AGENT_INFO_FRAGMENT}
`

export const CREATE_AGENT = gql`
  mutation CreateAgent($input: CreateAgencyUserInput!) {
    createAgent(input: $input) {
      ...AgentInfo
    }
  }
  ${AGENT_INFO_FRAGMENT}
`

export const UPDATE_AGENT = gql`
  mutation UpdateAgent($input: UpdateAgencyUserInput!) {
    updateAgent(input: $input) {
      ...AgentInfo
    }
  }
  ${AGENT_INFO_FRAGMENT}
`

export const GET_AGENT = gql`
  query GetAgent($input: GetAgentInput!) {
    agent(input: $input) {
      ...AgentInfo
    }
  }
  ${AGENT_INFO_FRAGMENT}
`

export const CREATE_AGENCY_ADMIN = gql`
  mutation CreateAgencyAdmin($input: CreateAgencyUserInput!) {
    ...AgencyAdminInfo
  }
  ${AGENCY_ADMIN_FRAGMENT}
`

// {
// 	"input": {
// 		"email": "jose+3@jackrabbitmobile.com",
// 		"clientId": "4dhsf30f07n2ht2d7kr42u43lr"
// 	}
// }
export const FORGOT_PASSWORD = gql`
  mutation ForgotPassword($input: ForgotPasswordInput!) {
    forgotPassword(input: $input)
  }
`
