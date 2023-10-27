import React from 'react'
import Link from 'next/link'
import List from '@material-ui/core/List'
import ListItem from '@material-ui/core/ListItem'
import ListItemIcon from '@material-ui/core/ListItemIcon'
import Agency from '~/lib/assets/icons/Agencies@2x.svg'
import Agents from '~/lib/assets/icons/Agents@2x.svg'
import Children from '~/lib/assets/icons/children@2x.svg'
import Calendar from '~/lib/assets/icons/calendar@2x.svg'
import Alert from '~/lib/assets/icons/incidentalert@.svg'
import Family from '~/lib/assets/icons/family@2x.svg'
import Home from '~/lib/assets/icons/home@2x.svg'
import Resources from '~/lib/assets/icons/resources@2x.svg'
import LocalResources from '~/lib/assets/icons/local-resources.svg'
import MenuLogo from '~/components/Logo/MenuLogo'
import ListItemText from '@material-ui/core/ListItemText'
import T from '~/lib/text'
import useStyles from './Layout.styles'

function Navigation({ role }) {
  const classes = useStyles()
  return (
    <List>
      <ListItem className={classes.drawerButton} key="MenuLogo">
        <ListItemIcon>
          <MenuLogo />
        </ListItemIcon>
        {/* <ListItemText primary="FosterShare" /> */}
      </ListItem>
      <Link href="/dashboard">
        <ListItem className={classes.drawerButton} button key="Home">
          <ListItemIcon>
            <Home />
          </ListItemIcon>
          <ListItemText primary={T('Home')} />
        </ListItem>
      </Link>
      {role === '0' && (
        <Link href="/agencies">
          <ListItem className={classes.drawerButton} button key="Agencies">
            <ListItemIcon>
              <Agency />
            </ListItemIcon>
            <ListItemText primary={T('Agencies')} />
          </ListItem>
        </Link>
      )}
      {(role === '0' || role === '1') && (
        <Link href={role === '0' ? '/users' : '/agents'}>
          <ListItem className={classes.drawerButton} button key="Agents">
            <ListItemIcon>
              <Agents />
            </ListItemIcon>
            <ListItemText primary={role === '0' ? T('Users') : T('Agents')} />
          </ListItem>
        </Link>
      )}
      {(role === '1' || role === '2') && (
        <Link href="/families">
          <ListItem className={classes.drawerButton} button key="Family">
            <ListItemIcon>
              <Family />
            </ListItemIcon>
            <ListItemText primary={T('Families')} />
          </ListItem>
        </Link>
      )}
      {(role === '1' || role === '2') && (
        <Link href="/children">
          <ListItem className={classes.drawerButton} button key="Children">
            <ListItemIcon>
              <Children />
            </ListItemIcon>
            <ListItemText primary={T('Children')} />
          </ListItem>
        </Link>
      )}
      {role === '0' && (
        <Link href="/resources">
          <ListItem className={classes.drawerButton} button key="Resources">
            <ListItemIcon>
              <Resources />
            </ListItemIcon>
            <ListItemText primary={T('Resources')} />
          </ListItem>
        </Link>
      )}
      {(role === '1' || role === '2') && (
        <Link href="/events">
          <ListItem className={classes.drawerButton} button key="Calendar">
            <ListItemIcon>
              <Calendar />
            </ListItemIcon>
            <ListItemText primary={T('Events')} />
          </ListItem>
        </Link>
      )}
      {(role === '1' || role === '2') && (
        <Link href="/messages">
          <ListItem className={classes.drawerButton} button key="Alerts">
            <ListItemIcon>
              <Alert />
            </ListItemIcon>
            <ListItemText primary={T('Messages')} />
          </ListItem>
        </Link>
      )}
      {(role === '0' || role === '1') && (
        <Link href="/localresources">
          <ListItem className={classes.drawerButton} button key="Support Services">
            <ListItemIcon>
              <LocalResources />
            </ListItemIcon>
            <ListItemText primary={T('LocalResources')} />
          </ListItem>
        </Link>
      )}
    </List>
  )
}

export default Navigation
