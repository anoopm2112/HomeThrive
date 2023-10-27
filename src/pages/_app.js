import '~/lib/assets/fonts/fonts.css'
import React, { useEffect, useState } from 'react'
import { useAnalytics } from '~/lib/firebaseConfig'
import Head from 'next/head'
import { ApolloProvider } from '@apollo/client'
import { ThemeProvider } from '@material-ui/core'
import Layout from '~/components/Layout/MainLayout'
import {
  NotificationContext,
  initialNotificationState,
} from '~/components/Contexts/NotificationContext'
import {
  AuthContext,
  initialAuthState,
} from '~/components/Contexts/AuthContext'
import { useApollo } from '../lib/apolloClient'
import CssBaseline from '@material-ui/core/CssBaseline'
import lightTheme from '~/components/Theme/LightTheme'
import T from '~/lib/text'
import { LOCAL_STORAGE_TOKEN_NAME } from '~/lib/config'
import {
  signIn,
  signOut,
  getCurrentSession,
  completeNewPassword,
} from '~/lib/amplifyAuth'
import ls from 'local-storage'
import '../components/Forms/MessageScheduleForm/index.css'

export default function App({ Component, pageProps }) {
  const apolloClient = useApollo(pageProps)

  const [notificationState, setNotificationState] = useState(
    initialNotificationState
  )
  const lsUser = ls.get(LOCAL_STORAGE_TOKEN_NAME)

  const [authState, setAuthState] = useState({
    ...initialAuthState,
    user: lsUser,
    isLoggedIn: !!lsUser,
  })

  if (notificationState?.error)
    console.error('NOTIFICATION ERROR', notificationState.error)

  // define some authentication logic for easy use in other components
  // TODO: move this login/logout logic somewhere else

  async function login(
    email,
    password,
    completeNewPassword = false,
    userToUpdate
  ) {
    console.log('COMPLETE NEW PASSWORD', completeNewPassword)
    const user = await signIn(
      email,
      password,
      completeNewPassword,
      userToUpdate
    )
    const { signInUserSession } = user

    // disallow parents from logging in.
    let role
    if (user && user.attributes && user.attributes['custom:role'])
      role = user.attributes['custom:role']
    else if (user && user.challengeParam && user.challengeParam['custom:role'])
      role = user.challengeParam['custom:role']
    if (role === '3') {
      await signOut()
      return {
        success: false,
        message: T('CantLoginAsParent'),
        data: signInUserSession,
      }
    }

    if (user.challengeName === 'NEW_PASSWORD_REQUIRED') {
      // needs to login because has initial temporary password
      return { success: false, message: 'NEW_PASSWORD_REQUIRED', data: user }
    } else {
      // user can login
      ls.set(LOCAL_STORAGE_TOKEN_NAME, signInUserSession?.idToken?.jwtToken)
      setAuthState({ ...authState, user: signInUserSession, isLoggedIn: true })
      return {
        success: true,
        message: T('UserLoggedIn'),
        data: signInUserSession,
      }
    }
  }

  async function logout() {
    const response = await signOut()
    ls.set(LOCAL_STORAGE_TOKEN_NAME, null)
    setNotificationState({
      ...notificationState,
      open: true,
      message: T('SigningOut'),
    })
    setAuthState({ ...authState, user: null, isLoggedIn: false })
    await apolloClient.clearStore()
    return true
  }

  // inject styles from server side
  useEffect(() => {
    // get current session and update
    const getSession = async () => {
      const user = await getCurrentSession()
      if (user) {
        ls.set(LOCAL_STORAGE_TOKEN_NAME, user?.idToken?.jwtToken)
        setAuthState({ ...authState, user, isLoggedIn: true })
      }
    }

    getSession()

    // Remove the server-side injected CSS.
    const jssStyles = document.querySelector('#jss-server-side')
    if (jssStyles) {
      jssStyles.parentElement.removeChild(jssStyles)
    }
  }, [])

  useAnalytics()

  return (
    <>
      <Head>
        <meta
          name="viewport"
          content="minimum-scale=1, initial-scale=1, width=device-width"
        />
        <title>FosterShare</title>
        {/* <!-- Start of fostershare Zendesk Widget script --> */}
        <script id="ze-snippet" src="https://static.zdassets.com/ekr/snippet.js?key=7193ea18-debe-4459-86f2-4ad10e60fc84"> </script>
        {/* <!-- End of fostershare Zendesk Widget script --> */}
      </Head>
      <ApolloProvider client={apolloClient}>
        <AuthContext.Provider
          value={{
            ...authState,
            login,
            logout,
          }}
        >
          <NotificationContext.Provider
            value={{
              ...notificationState,
              set: (e) => setNotificationState({ ...notificationState, ...e }),
            }}
          >
            <ThemeProvider theme={lightTheme}>
              <Layout>
                <CssBaseline />
                <Component {...pageProps} />
              </Layout>
            </ThemeProvider>
          </NotificationContext.Provider>
        </AuthContext.Provider>
      </ApolloProvider>
    </>
  )
}
