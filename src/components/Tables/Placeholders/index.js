import React from 'react'

// styles
import useStyles from '~/components/Tables/Placeholders/placeholders.styles'

// assets
import ImageWomanAndComputerScreens from '~/lib/assets/img/woman-and-pc-screens.svg'
import EmptyMailbox from '~/lib/assets/img/empty-mailbox.svg'
import T from '~/lib/text'

export const PlaceholderChildrenLogs = (props) => {
  const classes = useStyles()

  return (
    <div className={classes.placeholder}>
      <div className="placeholder-flex">
        <ImageWomanAndComputerScreens />
        <div className="spacer" />
        <div className="subheading">{T('NoLogs')}</div>
      </div>
    </div>
  )
}

export const PlaceholderUpcomingVisits = (props) => {
  const classes = useStyles()

  return (
    <div className={classes.placeholder}>
      <div className="placeholder-flex">
        <EmptyMailbox />
        <div className="spacer" />
        <div className="subheading">{T('NoUpcomingVisits')}</div>
      </div>
    </div>
  )
}

export const PlaceholderMessages = (props) => {
  const classes = useStyles()

  return (
    <div className={classes.placeholder}>
      <div className="placeholder-flex">
        <EmptyMailbox />
        <div className="spacer" />
        <div className="subheading">{T('NoMessages')}</div>
      </div>
    </div>
  )
}
