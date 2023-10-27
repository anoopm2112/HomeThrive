import React from 'react'
import Typography from '@material-ui/core/Typography'
import { useStyles } from './Logo.styles'

function Logo() {
  const classes = useStyles()
  return (
    <div className={classes.root}>
      <img className={classes.logo} src="/images/FosterShareLogo.svg" />
      <div className={classes.logoText}>
        <Typography variant="h4">FosterShare</Typography>
        <Typography variant="body2" className={classes.subheading}>
          Powered by Miracle Foundation
        </Typography>
      </div>
    </div>
  )
}

export default Logo
