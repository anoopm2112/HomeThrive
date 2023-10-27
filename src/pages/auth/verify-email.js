import React from 'react'
import UnAuthedLayout from '~/components/Layout/UnAuthedLayout'
import LoginAccessCode from '~/components/Authentication/LoginAccessCode'
import Container from '@material-ui/core/Container'

function VerifyEmailPage() {
  return (
    <UnAuthedLayout>
      <Container maxWidth="sm" style={{ marginTop: '3rem' }}>
        <LoginAccessCode />
      </Container>
    </UnAuthedLayout>
  )
}

export default VerifyEmailPage
