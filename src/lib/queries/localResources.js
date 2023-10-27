import { gql } from '@apollo/client'

export const LOCAL_RESOURCE_FRAGMENT_SHALLOW = gql`
  fragment LocalResourceInfoShallow on SupportService {
    id
    name
    description
    email
    phoneNumber
    website
    agencyId
    agencyName
  }
`

export const GET_LOCAL_RESOURCES = gql`
  query GetLocalResources($input: GetSupportServicesInput!) {
    supportServices(input: $input) {
      items {
        ...LocalResourceInfoShallow
      }
      pageInfo {
        cursor
        hasNextPage
        count
      }
    }
  }

  ${LOCAL_RESOURCE_FRAGMENT_SHALLOW}
`

export const GET_LOCAL_RESOURCE = gql`
  query GetSupportService($input: GetSupportServiceInput!) {
    supportService(input: $input) {
      ...LocalResourceInfoShallow
    }
  }
  ${LOCAL_RESOURCE_FRAGMENT_SHALLOW}
`

export const CREATE_LOCAL_RESOURCE = gql`
  mutation CreateSupportService($input: CreateSupportServiceInput!) {
    createSupportService(input: $input) {
      ...LocalResourceInfoShallow
    }
  }
  ${LOCAL_RESOURCE_FRAGMENT_SHALLOW}
`

export const UPDATE_LOCAL_RESOURCE = gql`
  mutation UpdateSupportService($input: UpdateSupportServiceInput!) {
    updateSupportService(input: $input) {
      ...LocalResourceInfoShallow
    }
  }
  ${LOCAL_RESOURCE_FRAGMENT_SHALLOW}
`

export const GET_RESOURCES_CATEGORIES = gql`
  query GetResourcesCategoriesAndAgencies {
    resourceCategories {
      id
      name
    }
  }
`