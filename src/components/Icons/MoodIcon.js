import React from 'react'
import Great from '~/lib/assets/icons/emoticon-great.svg'
import Good from '~/lib/assets/icons/emoticon-good.svg'
import Neutral from '~/lib/assets/icons/emoticon-neutral.svg'
import Soso from '~/lib/assets/icons/emoticon-soso.svg'
import HardDay from '~/lib/assets/icons/emoticon-bad.svg'
import HelpIcon from '@material-ui/icons/Help'
import PropTypes from 'prop-types'

function MoodIcon({ rating }) {
  switch (rating) {
    case 'GREAT':
      return <Great />
    case 'GOOD':
      return <Good />
    case 'AVERAGE':
    case 'NEUTRAL':
      return <Neutral />
    case 'SOSO':
      return <Soso />
    case 'HARDDAY':
      return <HardDay />
    default:
      return <HelpIcon />
  }
}

MoodIcon.propTypes = {
  rating: PropTypes.string,
}

export default MoodIcon
