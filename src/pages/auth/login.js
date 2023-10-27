import React from 'react'
import UnAuthedLayout from '~/components/Layout/UnAuthedLayout'
import Login from '~/components/Authentication/Login'
import Container from '@material-ui/core/Container'

function LoginPage() {
  return (
    <UnAuthedLayout>
      <Container maxWidth="md" style={{ marginTop: '1rem', display: 'flex', justifyContent: 'flex-start', position: 'relative', zIndex: 5 }}>
        <Login />
      </Container>
    </UnAuthedLayout>
  )
}

export default LoginPage
