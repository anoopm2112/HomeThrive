import { useEffect, useState } from 'react'
import Amplify, { Auth } from 'aws-amplify'

export const config = {
  Auth: {
    identityPoolId: process.env.NEXT_PUBLIC_IDENTITY_POOL_ID,
    // REQUIRED - Amazon Cognito Region
    region: process.env.NEXT_PUBLIC_REGION,
    identityPoolRegion: process.env.NEXT_PUBLIC_IDENTITY_POOL_REGION,
    // OPTIONAL - Amazon Cognito User Pool ID
    userPoolId: process.env.NEXT_PUBLIC_USER_POOL_ID,
    // OPTIONAL - Amazon Cognito Web Client ID (26-char alphanumeric string)
    userPoolWebClientId: process.env.NEXT_PUBLIC_USER_POOL_WEB_CLIENT_ID,
    // OPTIONAL - Manually set the authentication flow type. Default is 'USER_SRP_AUTH'
    authenticationFlowType: process.env.NEXT_PUBLIC_AUTHENTICATION_FLOW_TYPE,
  },
}

Amplify.configure({ ...config, ssr: true })

export async function signIn(email, password, completeNewPassword, user) {
  if (!completeNewPassword) {
    return await Auth.signIn(email, password)
  } else {
    return await Auth.completeNewPassword(user, password)
  }
}

export async function signOut() {
  await Auth.signOut()
}

/**
 * Submits the request to send a confirmation email to the email
 * for password reset
 * @param {string} email
 */
export async function forgotPassword(email) {
  const response = await Auth.forgotPassword(email)
  if (response.code === 'CodeMismatchException') throw Error(r.message)
  if (response.code === 'LimitExceededException') throw Error(r.message)
  return response
}

/**
 * Submits the request to ACTUALLY reset the email
 * @param {string} email
 * @param {string} code
 * @param {string} password
 */
export async function forgotPasswordReset(email, code, password) {
  const response = await Auth.forgotPasswordSubmit(email, code, password)
  return response
}

/**
 * Hook to check if the user is logged in or not
 * If the user is not logged in, redirects to login.
 */
export function useUser() {
  const [user, setUser] = useState(null)
  useEffect(async () => {
    try {
      const r = await Auth.currentAuthenticatedUser()
      setUser(r)
      return user
    } catch (err) {
      console.error(err)
      setUser(false)
    }
  }, [])
  return user
}

export async function getCurrentSession() {
  try {
    const r = await Auth.currentSession()
    return r
  } catch (err) {
    console.error(err)
    return null
  }
}

export async function sendAccessCodeToVerifyEmail() {
  return await Auth.verifyCurrentUserAttribute('email')
}

export async function verifyEmailWithAccessCode(code) {
  return await Auth.verifyCurrentUserAttributeSubmit('email', code)
}
