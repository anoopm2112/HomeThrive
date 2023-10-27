import { gql } from '@apollo/client'

export const CURSOR_PAGE_INFO_FRAGMENT = gql`
  fragment CursorPageInfo on CursorPageInfo {
    cursor
    hasNextPage
    count
  }
`

export const PAGE_INFO_FRAGMENT = gql`
  fragment PageInfo on PageInfo {
    cursor
    hasNextPage
    count
  }
`
