import { gql } from '@apollo/client'

export const AGENCY_FRAGMENT_SHALLOW = gql`
  fragment AgencyInfoShallow on Agency {
    id
    createdAt
    name
    address
    city
    state
    zipCode
    licenseNumber
    agentsCount
    familiesCount
    childrenCount
    agencyCalendarUrl
    poc {
      id
      firstName
      lastName
      email
      title
      phoneNumber
    }
    createdAt
    updatedAt
  }
`

export const GET_AGENCIES = gql`
  query GetAgencies($input: GetAgenciesInput!) {
    agencies(input: $input) {
      items {
        ...AgencyInfoShallow
      }
      pageInfo {
        cursor
        count
        hasNextPage
      }
    }
  }

  ${AGENCY_FRAGMENT_SHALLOW}
`

export const GET_AGENCY = gql`
  query GetAgency($id: String!) {
    agency(id: $id) {
      ...AgencyInfoShallow
    }
  }
  ${AGENCY_FRAGMENT_SHALLOW}
`

export const GET_AGENCIES_VARIABLES = (term, limit, cursor = 0) => ({
  input: {
    search: term,
    pagination: {
      // cursor: cursor,
      limit: limit,
    },
  },
})

export const CREATE_AGENCY = gql`
  mutation CreateAgency($input: CreateAgencyInput!) {
    createAgency(input: $input) {
      ...AgencyInfoShallow
    }
  }

  ${AGENCY_FRAGMENT_SHALLOW}
`

export const UPDATE_AGENCY = gql`
  mutation UpdateAgency($input: UpdateAgencyInput!) {
    updateAgency(input: $input) {
      ...AgencyInfoShallow
    }
  }

  ${AGENCY_FRAGMENT_SHALLOW}
`

export const DELETE_AGENCIES = gql`
  mutation DeleteManyResources($input: DeleteManyResourcesInput!) {
    deleteManyResources(input: $input)
  }
`

export const GET_AGENCY_PROFILE = gql`
  query GetAgencyProfile {
    agencyProfile {
      ...AgencyInfoShallow
    }
  }
  ${AGENCY_FRAGMENT_SHALLOW}
`

export const UPDATE_AGENCY_PROFILE = gql`
  mutation UpdateAgencyProfile($input: UpdateAgencyProfileInput!) {
    updateAgencyProfile(input: $input) {
      ...AgencyInfoShallow
    }
  }
  ${AGENCY_FRAGMENT_SHALLOW}
`
