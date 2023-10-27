import React, { useState } from 'react'
import Link from 'next/link'
import clsx from 'clsx'
import { useRouter } from 'next/router'
import Typography from '@material-ui/core/Typography'
import ButtonGroup from '@material-ui/core/ButtonGroup'
import Button from '@material-ui/core/Button'
import Bell from '~/lib/assets/icons/Alerts@2x.svg'
import { PageTitles, RolesForDisplay } from '~/lib/assets/copy'
import Breadcrumbs from '@material-ui/core/Breadcrumbs'
import Badge from '@material-ui/core/Badge'
import NotificationList from '~/components/Tables/NotificationList'
import useStyles from './Header.styles'

import T from '~/lib/text'

function Header({ role }) {
  const router = useRouter()
  const [hasNotifications, setHasNotifications] = useState(false)
  const [notificationAnchor, setNotificationAnchor] = useState(false)
  const classes = useStyles()

  //     _      _
  //  __| |__ _| |_ __ _ _ __ _ _ ___ _ __
  // / _` / _` |  _/ _` | '_ \ '_/ -_) '_ \
  // \__,_\__,_|\__\__,_| .__/_| \___| .__/
  //                    |_|          |_|
  //
  const pathname = router.pathname
  const crumbs = pathname.split('/').slice(1)
  const main = crumbs[0]
  const links = crumbs.map((e, i) => {
    return (
      <Link
        key={`${e}.${i}`}
        href={`/${crumbs.slice(i, i + 1).join('/')}`}
        disabled={i === crumbs.length - 1}
      >
        <Typography
          variant="h2"
          className={clsx(classes.link, {
            [classes.activeBreadcrumb]: i === crumbs.length - 1,
          })}
        >
          {PageTitles[main][i]}
        </Typography>
      </Link>
    )
  })

  return (
    <div className={`authed-header ${classes.root}`}>
      <Breadcrumbs
        className={classes.breadcrumbs}
        aria-label="breadcrumb"
        separator="›"
      >
        {links}
      </Breadcrumbs>

      {role !== '0' && (
        <NotificationList
          open={!!notificationAnchor}
          handleClose={() => setNotificationAnchor(false)}
          anchorEl={notificationAnchor}
          onFetchCompleted={(d) => {
            const notifications = d?.notifications?.items || []
            const unread = notifications.filter((d) => !d.read)
            if (unread.length > 0) {
              setHasNotifications(true)
            }
          }}
        />
      )}

      <div className={classes.left}>
        <ButtonGroup
          className={classes.buttonGroup}
          variant="contained"
          aria-label="alerts, settings and accounts"
        >
          {role !== '0' && (
            <Button onClick={(e) => setNotificationAnchor(e.currentTarget)}>
              <Badge
                color="secondary"
                variant="dot"
                invisible={!hasNotifications}
              >
                <Bell />
              </Badge>
            </Button>
          )}
          <Link href="/profile">
            <Button>{T('Profile')}</Button>
          </Link>
        </ButtonGroup>
        <Typography className={classes.smallText}>
          {RolesForDisplay[parseInt(role)]}
        </Typography>
      </div>
    </div>
  )
}

export default Header
