import { gql } from '@apollo/client'

export const FAMILY_FRAGMENT_SHALLOW = gql`
  fragment FamilyInfoShallow on Family {
    id
    address
    agencyId
    agentId
    agentName
    childrenCount
    city
    email
    firstName
    lastName
    licenseNumber
    occupation
    phoneNumber
    primaryLanguage
    state
    zipCode
    secondaryParents {
      id
      firstName
      lastName
      email
      phoneNumber
      occupation
    }
  }
`

export const GET_FAMILIES = gql`
  query GetFamilies($input: GetFamiliesInput!) {
    families(input: $input) {
      items {
        ...FamilyInfoShallow
      }
      pageInfo {
        cursor
        hasNextPage
        count
      }
    }
  }

  ${FAMILY_FRAGMENT_SHALLOW}
`

export const GET_FAMILY = gql`
  query GetFamily($input: GetFamilyInput!) {
    family(input: $input) {
      ...FamilyInfoShallow
      canResendInvitation{
        primaryParent
        secondaryParent
      }
    }
  }

  ${FAMILY_FRAGMENT_SHALLOW}
`

export const CREATE_FAMILY = gql`
  mutation CreateFamily($input: CreateFamilyInput!) {
    createFamily(input: $input) {
      ...FamilyInfoShallow
    }
  }
  ${FAMILY_FRAGMENT_SHALLOW}
`

export const UPDATE_FAMILY = gql`
  mutation UpdateFamily($input: UpdateFamilyInput!) {
    updateFamily(input: $input) {
      ...FamilyInfoShallow
      canResendInvitation{
        primaryParent
        secondaryParent
      }
    }
  }
  ${FAMILY_FRAGMENT_SHALLOW}
`
export const GET_FAMILY_IMAGES = gql`
  query FamilyImages($input: GetFamilyImagesInput!) {
    familyImages(input: $input) {
      items {
        id
        url
        name
        file
      }
      pageInfo {
        cursor
        hasNextPage
        count
      }
    }
  }
`
