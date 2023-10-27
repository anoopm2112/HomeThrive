import { gql } from '@apollo/client'

export const RESOURCE_FRAGMENT_SHALLOW = gql`
  fragment ResourceInfoShallow on Resource {
    id
    createdAt
    updatedAt
    title
    summary
    url
    image
    published
    categories {
      id
      name
    }
    agency {
      id
      name
    }
    author {
      firstName
      lastName
    }
  }
`

export const GET_RESOURCES = gql`
  query GetResources($input: GetResourcesInput!) {
    resources(input: $input) {
      items {
        ...ResourceInfoShallow
      }
      pageInfo {
        cursor
        hasNextPage
        count
      }
    }
  }

  ${RESOURCE_FRAGMENT_SHALLOW}
`

export const GET_RESOURCE = gql`
  query GetResource($input: GetResourceInput!) {
    resource(input: $input) {
      ...ResourceInfoShallow
    }
  }
  ${RESOURCE_FRAGMENT_SHALLOW}
`

export const GET_RESOURCES_CATEGORIES = gql`
  query GetResourcesCategoriesAndAgencies {
    resourceCategories {
      id
      name
    }
  }
`

export const CREATE_RESOURCE = gql`
  mutation CreateResource($input: CreateResourceInput!) {
    createResource(input: $input) {
      id
      title
      summary
      image
      published
    }
  }
`

export const UPDATE_RESOURCE = gql`
  mutation UpdateResource($input: UpdateResourceInput!) {
    updateResource(input: $input) {
      ...ResourceInfoShallow
    }
  }
  ${RESOURCE_FRAGMENT_SHALLOW}
`

export const DELETE_RESOURCES = gql`
  mutation DeleteManyResources($input: DeleteManyResourcesInput!) {
    deleteManyResources(input: $input)
  }
`
