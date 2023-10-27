import React, { useContext, useState, useEffect } from 'react'
import { useRouter } from 'next/router'
import { logEvent } from '~/lib/firebaseConfig'
import Snackbar from '@material-ui/core/Snackbar'
import MuiAlert from '@material-ui/lab/Alert'
import LinearProgress from '@material-ui/core/LinearProgress'
import {
  NotificationContext,
  initialNotificationState,
} from '~/components/Contexts/NotificationContext'
import useStyles from './Layout.styles'

function MainLayout({ children }) {
  const [loading, setLoading] = useState(false)

  const notification = useContext(NotificationContext)
  function handleSnackbarClose() {
    notification.set({ ...initialNotificationState })
  }
  const classes = useStyles()
  const router = useRouter()

  useEffect(() => {
    router.events.on('routeChangeStart', () => setLoading(true))
    router.events.on('routeChangeComplete', () => {
      logEvent(window.location.pathname)
      setLoading(false)
    })
  }, [])

  return (
    <div className={`wrapper ${classes.root}`}>
      <LinearProgress style={{ opacity: loading ? 1 : 0 }} />
      <Snackbar
        open={notification.open}
        onClose={handleSnackbarClose}
        autoHideDuration={4000}
        anchorOrigin={{
          vertical: 'top',
          horizontal: 'right',
        }}
      >
        <MuiAlert
          variant="filled"
          onClose={handleSnackbarClose}
          severity={notification.error ? 'error' : 'info'}
        >
          {notification.message}
        </MuiAlert>
      </Snackbar>
      {children}
    </div>
  )
}

export default MainLayout
