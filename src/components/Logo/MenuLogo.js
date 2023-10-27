import React from 'react'
import Typography from '@material-ui/core/Typography'
import { useStyles } from './Logo.styles'

function Logo() {
  const classes = useStyles()
  return (
    <div className={classes.root}>
      <img
        className={classes.menuLogo}
        src="/images/FosterShareLogo_white.svg"
      />
      {/* <div className={classes.menuLogoText}>
        <Typography variant="h4">FosterShare</Typography>
        <Typography variant="body2" className={classes.menuSubheading}>
          Powered by Miracle Foundation
        </Typography>
      </div> */}
    </div>
  )
}

export default Logo
