import React from 'react'
export const initialAuthState = {
  user: {},
  isLoggedIn: false,
}

export const AuthContext = React.createContext(initialAuthState)
