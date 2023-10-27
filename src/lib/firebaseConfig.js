import { useEffect } from 'react'
import firebase from 'firebase'
import 'firebase/analytics'

const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_API_KEY,
  authDomain: process.env.NEXT_PUBLIC_AUTH_DOMAIN,
  projectId: process.env.NEXT_PUBLIC_PROJECT_ID,
  storageBucket: process.env.NEXT_PUBLIC_STORAGE_BUCKET,
  messagingSenderId: process.env.NEXT_PUBLIC_MESSAGING_SENDER_ID,
  appId: process.env.NEXT_PUBLIC_APP_ID,
  measurementId: process.env.NEXT_PUBLIC_MEASUREMENT_ID,
}

try {
  // check if already initialized
  if (!firebase.apps.length) {
    firebase.initializeApp(firebaseConfig)
  }
} catch (err) {
  if (!/already exists/.test(err.message)) {
    console.error('Firebase initialization error', err.stack)
  }
}

const analytics = firebase.analytics
function useAnalytics() {
  useEffect(() => {
    if (process.env.NODE_ENV === 'production') {
      analytics()
    }
  }, [])
}

function logEvent(url, event) {
  if (process.env.NODE_ENV === 'production') {
    analytics().setCurrentScreen(url)
    analytics().logEvent(event || 'screen_view')
  }
}

export { firebase, useAnalytics, analytics, logEvent }
