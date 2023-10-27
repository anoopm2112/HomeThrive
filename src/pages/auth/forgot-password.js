import React from 'react'
import UnAuthedLayout from '~/components/Layout/UnAuthedLayout'
import ForgotPassword from '~/components/Authentication/ForgotPassword'
import Container from '@material-ui/core/Container'

function ForgotPasswordPage() {
  return (
    <UnAuthedLayout>
      <Container maxWidth="sm" style={{ marginTop: '3rem' }}>
        <ForgotPassword />
      </Container>
    </UnAuthedLayout>
  )
}

export default ForgotPasswordPage
