import React from 'react'
import Link from 'next/link'
import { useQuery } from '@apollo/client'
import { GET_NOTIFICATIONS } from '~/lib/queries/notifications'
import Popover from '@material-ui/core/Popover'
import Typography from '@material-ui/core/Typography'
import PropTypes from 'prop-types'
import NotificationCard from './NotificationCard'
import useStyles from './NotificationList.style.js'
import T from '~/lib/text'

/**
 *
 * This component is used in the Header, when clicking the Bell Icon.
 * To display Notifications (Alerts).
 */

function NotificationList({ open, anchorEl, handleClose, onFetchCompleted }) {
  //
  //  __ _ _  _ ___ _ _ _  _
  // / _` | || / -_) '_| || |
  // \__, |\_,_\___|_|  \_, |
  //    |_|             |__/
  //

  const {
    loading: fetchLoading,
    data: fetchData,
    error: fetchError,
  } = useQuery(GET_NOTIFICATIONS, {
    notifyOnNetworkStatusChange: true,
    variables: {
      input: {
        pagination: {
          limit: 4,
        },
      },
    },
    onCompleted: (d) => {
      if (onFetchCompleted) onFetchCompleted(d)
    },
  })

  //     _      _
  //  __| |__ _| |_ __ _   _ __ _ _ ___ _ __
  // / _` / _` |  _/ _` | | '_ \ '_/ -_) '_ \
  // \__,_\__,_|\__\__,_| | .__/_| \___| .__/
  //                      |_|          |_|

  let dataToUse = fetchData?.notifications?.items || [] //eslint-disable-line
  const sorted = [...dataToUse].sort((d) => (d.read ? 1 : -1))

  const notificationCards = sorted.map((e, i) => (
    <NotificationCard key={`${e.id}.${i}`} notification={e} />
  ))

  const classes = useStyles()
  return (
    <Popover
      id={'Notifications'}
      open={open}
      anchorEl={anchorEl}
      onClose={handleClose}
      anchorOrigin={{
        vertical: 'bottom',
        horizontal: 'left',
      }}
      transformOrigin={{
        vertical: 'top',
        horizontal: 'right',
      }}
    >
      <div className={classes.root}>
        <div className={classes.header}>
          <Typography variant="h4">{T('Notifications')}</Typography>
          <Link href="/notifications">
            <Typography
              onClick={handleClose}
              className={classes.link}
              variant="body2"
              color="primary"
            >
              {T('ViewMore')}
            </Typography>
          </Link>
        </div>
        <div className={classes.notificationList}>{notificationCards}</div>
      </div>
    </Popover>
  )
}

NotificationList.propTypes = {
  open: PropTypes.bool.isRequired,
  // anchorEl: PropTypes.node,
  handleClose: PropTypes.func.isRequired,
}

export default NotificationList
