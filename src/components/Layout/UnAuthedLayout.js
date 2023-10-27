import React from 'react'
import Paper from '@material-ui/core/Paper'
import Link from 'next/link'
import Button from '@material-ui/core/Button'
import Hidden from '@material-ui/core/Hidden'
import Grid from '@material-ui/core/Grid'
import Logo from '~/components/Logo'
import useStyles from './Layout.styles'
import T from '~/lib/text'

function UnAuthedLayout({ children, showImage }) {
  const classes = useStyles()

  return (
    <div className="unauthed-wrapper">
      <Paper className={`header ${classes.header}`} elevation={3}>
        <Logo />
        <nav className={`unauthed-nav ${classes.headerNav}`}>
          {/* <Link href="/">
            <Button color="primary">{T('Home')}</Button>
          </Link> */}
          {/* <Link href="/about">
            <Button color="primary">{T('About')}</Button>
          </Link> */}
          <a href="https://fostershare.zendesk.com/hc/en-us" target="_blank" style={{marginRight: 10}}>
            <Button color="secondary">Help Center</Button>
          </a>
          <Link href="/auth/login">
            <Button variant="contained" color="secondary">
              {T('Login')}
            </Button>
          </Link>
        </nav>
      </Paper>
      <main className={`main-content ${classes.content}`}>
        <Grid container spacing={3}>
          {showImage && (
            <Hidden smDown>
              <Grid item sm={3} md={5} lg={4} className={classes.homePageImage}>
                {/* <img
                  className={classes.mobileImage}
                  src="/images/FosterShare_Mobile.png"
                  alt="Resource Image"
                /> */}
                <div
                  className={`image-container ${classes.imageContainer}`}
                ></div>
              </Grid>
            </Hidden>
          )}
          <Grid item xs={12} sm={9} md={7} lg={8}>
            {children}
          </Grid>
        </Grid>
      </main>
    </div>
  )
}

UnAuthedLayout.defaultProps = {
  showImage: true,
}

export default UnAuthedLayout
