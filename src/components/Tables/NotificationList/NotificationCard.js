import React from 'react'
import Link from 'next/link'
import Typography from '@material-ui/core/Typography'
import useStyle from './NotificationList.style'
import { useMutation } from '@apollo/client'
import { MARK_NOTIFICATION_AS_READ } from '~/lib/queries/notifications'
import T from '~/lib/text'
import clsx from 'clsx'
import { CircularProgress } from '@material-ui/core'

function NotificationCard({ notification }) {
  //            _        _   _
  //  _ __ _  _| |_ __ _| |_(_)___ _ _
  // | '  \ || |  _/ _` |  _| / _ \ ' \
  // |_|_|_\_,_|\__\__,_|\__|_\___/_||_|
  //
  const [markRead, { loading, data, error }] = useMutation(
    MARK_NOTIFICATION_AS_READ
  )

  //     _      _
  //  __| |__ _| |_ __ _   _ __ _ _ ___ _ __
  // / _` / _` |  _/ _` | | '_ \ '_/ -_) '_ \
  // \__,_\__,_|\__\__,_| | .__/_| \___| .__/
  //                      |_|          |_|
  const { read, title, createdAt, body } = notification
  const dateTime = new Date(createdAt)
  const dayString = dateTime.toLocaleDateString()
  const day =
    new Date().toLocaleDateString() === dayString ? T('Today') : dayString
  const time = dateTime.toLocaleTimeString([], {
    hour: '2-digit',
    minute: '2-digit',
  })

  //  _                 _ _
  // | |_  __ _ _ _  __| | |___ _ _ ___
  // | ' \/ _` | ' \/ _` | / -_) '_(_-<
  // |_||_\__,_|_||_\__,_|_\___|_| /__/
  //
  function handleMarkAsRead() {
    if (!read) {
      markRead({
        variables: {
          input: {
            id: notification.id,
          },
        },
      })
    }
  }

  //                  _
  //  _ _ ___ _ _  __| |___ _ _
  // | '_/ -_) ' \/ _` / -_) '_|
  // |_| \___|_||_\__,_\___|_|
  //
  const classes = useStyle()
  return (
    <div
      className={clsx([
        classes.notificationCard,
        !read && classes.notificationIsNew,
      ])}
      onClick={handleMarkAsRead}
    >
      {loading ? (
        <CircularProgress className={classes.loading} size={8} />
      ) : (
        <Bullet className={classes.bullet} size={8} show={!read} />
      )}
      <Link href={`/families/${notification.parentId}`}>
      <div className={classes.notificationCardContent}>
        <div className={classes.notificationCardHeader}>
          <Typography
            className={clsx([
              classes.notificationHeaderText,
              !read && classes.notificationIsNew,
            ])}
            variant="body1"
          >
            {title}
          </Typography>
          <Typography
            className={clsx(
              classes.notificationHeaderText,
              classes.notificationTime
            )}
            variant="body2"
          >
            {day} {time}
          </Typography>
        </div>
        <Typography className={classes.notificationDescription} variant="body1">
          {body}
        </Typography>
      </div>
      </Link>
    </div>
  )
}

function Bullet({ size, show }) {
  const classes = useStyle()
  return (
    <span
      style={{
        width: `${size}px`,
        height: `${size}px`,
        opacity: show ? 1 : 0,
      }}
      className={classes.bullet}
    ></span>
  )
}

export default NotificationCard
