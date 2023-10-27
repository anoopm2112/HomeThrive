import React from 'react'
import Register from '~/components/Authentication/Register'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import Container from '@material-ui/core/Container'

function RegisterPage(props) {
  return (
    <AuthedLayout>
      <Container maxWidth="sm" style={{ marginTop: '3rem' }}>
        <Register />
      </Container>
    </AuthedLayout>
  )
}

export default RegisterPage
