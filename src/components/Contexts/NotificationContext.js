import React from 'react'
export const initialNotificationState = {
  error: null,
  message: '',
  open: false,
}

export const NotificationContext = React.createContext(initialNotificationState)
