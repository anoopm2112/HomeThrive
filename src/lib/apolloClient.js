import { useMemo } from 'react'
import { ApolloClient, createHttpLink, InMemoryCache } from '@apollo/client'
import { setContext } from '@apollo/client/link/context'
import {
  mergeObjectWithItems,
  keyArgsForSearchOnly,
  keyArgsForSearchAndAgentId,
  keyArgsForSearchAndChildId,
  keyArgsForSearchChildIdAndFamilyId,
  keyArgsForSearchAndFamilyId,
  keyArgsForSearchAndParentId,
  keyArgsForSearchAndEventId,
  keyArgsForSearchEventIdAndType,
  keyArgsForSearchAndLimit,
} from '~/lib/utils'
import merge from 'deepmerge'
import isEqual from 'lodash/isEqual'
import { LOCAL_STORAGE_TOKEN_NAME } from '~/lib/config'

import ls from 'local-storage'
import { getCurrentSession } from '~/lib/amplifyAuth'

export const APOLLO_STATE_PROP_NAME = '__APOLLO_STATE__'

let apolloClient

const authLink = setContext(async (_, { headers }) => {
  // get the current session
  const user = await getCurrentSession()
  const sessionToken = user?.idToken?.jwtToken
  // get the authentication token from local storage if it exists
  const lsToken = ls.get(LOCAL_STORAGE_TOKEN_NAME)

  if (sessionToken !== lsToken) {
    // console.log('NEW TOKEN')
    ls.set(LOCAL_STORAGE_TOKEN_NAME, sessionToken)
  }
  // return the headers to the context so httpLink can read them
  return {
    headers: {
      ...headers,
      authorization: sessionToken, // || lsToken,
    },
  }
})

const httpLink = createHttpLink({
  uri: process.env.NEXT_PUBLIC_GRAPHQL_ENDPOINT,
  fetchOptions: {
    mode: 'cors',
  },
})

function createApolloClient() {
  return new ApolloClient({
    // ssrMode: typeof window === 'undefined',
    link: authLink.concat(httpLink),
    queryDeduplication: true,
    cache: new InMemoryCache({
      typePolicies: {
        Query: {
          fields: {
            resources: {
              keyArgs: keyArgsForSearchOnly,
              merge: mergeObjectWithItems,
            },
            agencies: {
              keyArgs: keyArgsForSearchOnly,
              merge: mergeObjectWithItems,
            },
            users: {
              keyArgs: keyArgsForSearchOnly,
              merge: mergeObjectWithItems,
            },
            agents: {
              keyArgs: keyArgsForSearchOnly,
              merge: mergeObjectWithItems,
            },
            families: {
              keyArgs: keyArgsForSearchAndAgentId,
              merge: mergeObjectWithItems,
            },
            children: {
              keyArgs: keyArgsForSearchChildIdAndFamilyId,
              merge: mergeObjectWithItems,
            },
            childLogs: {
              keyArgs: keyArgsForSearchAndChildId,
              merge: mergeObjectWithItems,
            },
            childrenLogs: {
              keyArgs: keyArgsForSearchAndFamilyId,
              merge: mergeObjectWithItems,
            },
            child: {
              keyArgs: keyArgsForSearchAndChildId,
            },
            event: {
              keyArgs: keyArgsForSearchEventIdAndType,
            },
            events: {
              keyArgs: keyArgsForSearchEventIdAndType,
              merge: mergeObjectWithItems,
            },
            eventParticipants: {
              keyArgs: keyArgsForSearchAndEventId,
              merge: mergeObjectWithItems,
            },
            messages: {
              keyArgs: keyArgsForSearchAndParentId,
              merge: mergeObjectWithItems,
            },
            notifications: {
              keyArgs: keyArgsForSearchAndLimit,
              merge: mergeObjectWithItems,
            },
            localresources: {
              keyArgs: keyArgsForSearchOnly,
              merge: mergeObjectWithItems,
            },
            medlogs: {
              keyArgs: keyArgsForSearchOnly,
              merge: mergeObjectWithItems,
            },
          },
        },
      },
    }),
  })
}

export function initializeApollo(initialState = null) {
  const _apolloClient = apolloClient ?? createApolloClient()

  // If your page has Next.js data fetching methods that use Apollo Client, the initial state
  // gets hydrated here
  if (initialState) {
    // Get existing cache, loaded during client side data fetching
    const existingCache = _apolloClient.extract()

    // Merge the existing cache into data passed from getStaticProps/getServerSideProps
    const data = merge(initialState, existingCache, {
      // combine arrays using object equality (like in sets)
      arrayMerge: (destinationArray, sourceArray) => [
        ...sourceArray,
        ...destinationArray.filter((d) =>
          sourceArray.every((s) => !isEqual(d, s))
        ),
      ],
    })

    // Restore the cache with the merged data
    _apolloClient.cache.restore(data)
  }
  // For SSG and SSR always create a new Apollo Client
  if (typeof window === 'undefined') return _apolloClient
  // Create the Apollo Client once in the client
  if (!apolloClient) apolloClient = _apolloClient

  return _apolloClient
}

export function addApolloState(client, pageProps) {
  if (pageProps?.props) {
    pageProps.props[APOLLO_STATE_PROP_NAME] = client.cache.extract()
  }

  return pageProps
}

export function useApollo(pageProps) {
  const state = pageProps[APOLLO_STATE_PROP_NAME]
  const store = useMemo(() => initializeApollo(state), [state])
  return store
}
