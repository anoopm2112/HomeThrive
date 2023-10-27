import React from 'react'
import UnAuthedLayout from '~/components/Layout/UnAuthedLayout'
import Typography from '@material-ui/core/Typography'
import Grid from '@material-ui/core/Grid'
import Container from '@material-ui/core/Container'
import Hidden from '@material-ui/core/Hidden'
import Link from 'next/link'
import Button from '@material-ui/core/Button'
import useStyles from '../components/Forms/Home.styles'
// import formHTML from '../components/Forms/formHTML'
import T from '~/lib/text'

function IndexPage() {
  const classes = useStyles()
  // const myHTML = `
  //   <p style="margin-top: 20px">
  //     Talk to your agency about adding&nbsp;<span style="word-spacing: normal;">FosterShare</span><sup style="word-spacing: normal; font-size: 16px">TM&nbsp;</sup> today!
  //   </p>
  // `;
  // const myTextHTML = () => <div dangerouslySetInnerHTML={{ __html: myHTML }} />;
  // const displayFromHTML = () => <div dangerouslySetInnerHTML={{ __html: formHTML }} />;

  return (
    <UnAuthedLayout>
      <Container maxWidth="md">
        <Grid item xs={12} style={{ marginTop: '1rem', position: 'relative', zIndex: 5 }}>
          {/* <Typography variant="h2" className={classes.newHeading}>
            {myTextHTML()}
          </Typography> */}
          <Typography variant="h4" className={classes.newHeadingTop}>
            Welcome to Foster Care's digital assistant,
          </Typography>
          <Typography variant="h4" className={classes.newHeading}>
            a revolutionary new app that is changing the way foster parents and case managers communicate.
          </Typography>
          {/* <Typography variant="h4" className={classes.newSubHeading}>
            Easier Logging ~ Resource Library ~ Push Notifications ~ {'Built-in Calendar & Scanner'} ~ And so much more
          </Typography> */}
          <Typography variant="h4" className={classes.newSubHeading}>Easier Logging</Typography>
          <Typography variant="h4" className={classes.newSubHeading}>Resource Library</Typography>
          <Typography variant="h4" className={classes.newSubHeading}>Push Notifications</Typography>
          <Typography variant="h4" className={classes.newSubHeading}>{'Built-in Calendar & Scanner'}</Typography>
          <Typography variant="h4" className={classes.newSubHeadingLast}>And so much more</Typography>
          <iframe 
            // src='https://www.youtube.com/embed/00V6npgSY-w?autoplay=1&loop=1&playlist=00V6npgSY-w&controls=0'
            src='https://www.youtube.com/embed/00V6npgSY-w?rel=0'
            frameborder='0'
            allow='autoplay; encrypted-media'
            allowfullscreen
            // listtype="playlist"
            // rel="0"
            title='video'
            height='250'
            width='444'
          />
          {/* {displayFromHTML()} */}
          <div className={classes.signInDiv}>
            <Link href="/auth/login">
              <Button variant="contained" color="secondary" className={classes.signInButton}>
                {T('Login')}
              </Button>
            </Link>
            <Typography variant="h4" className={classes.signInText}>
              Sign in for agencies and case managers. Family sign in is done through the FosterShare mobile app.
            </Typography>
          </div>
        </Grid>
        <Hidden xsDown>
          <img
            className={classes.familyImage}
            src="/images/Family.png"
            alt="Resource Image"
          />
        </Hidden>
      </Container>
    </UnAuthedLayout>
  )
}

export default IndexPage
