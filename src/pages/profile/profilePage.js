import React, { useContext } from 'react'
import { useRouter } from 'next/router'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import { AuthContext } from '~/components/Contexts/AuthContext'
import Grid from '@material-ui/core/Grid'
import T from '~/lib/text'
import Button from '@material-ui/core/Button'
import ProfileDetails from '~/components/Details/ProfileDetails'
import AgencyDetails from '~/components/Details/AgencyDetails'
import { useUser } from '~/lib/amplifyAuth'

function ProfilePage() {
  const router = useRouter()
  const authState = useContext(AuthContext)

  // gets currently logged in user
  const user = useUser()
  const role = user?.attributes['custom:role']

  return (
    <AuthedLayout>
      <div className="profile-page">
        <Grid container spacing={2}>
          <Grid item sm={10} md={7}>
            <ProfileDetails role={role} />
            <Button
              variant="contained"
              color="secondary"
              onClick={async () => {
                authState.logout()
                router.push('/auth/login')
              }}
            >
              {T('Logout')}
            </Button>
          </Grid>

          {role > 0 && (
            <Grid item sm={10} md={7}>
              <AgencyDetails role={role} />
            </Grid>
          )}
        </Grid>
      </div>
    </AuthedLayout>
  )
}

export default ProfilePage
