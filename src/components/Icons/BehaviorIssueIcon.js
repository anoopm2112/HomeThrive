import React from 'react'
import BedWetting from '~/lib/assets/icons/incident_bedWet.svg'
import Depression from '~/lib/assets/icons/incident_depression.svg'
import Stealing from '~/lib/assets/icons/incident_stealing.svg'
import FoodIssue from '~/lib/assets/icons/incident_food.svg'
import Anxiety from '~/lib/assets/icons/incident_anxiety.svg'
import Violence from '~/lib/assets/icons/incident_violence.svg'
import School from '~/lib/assets/icons/incident_school.svg'
import Other from '~/lib/assets/icons/incident.svg'
import PropTypes from 'prop-types'

function BehaviorIssueIcon({ issue }) {
  // console.log('ISSUE', issue)
  switch (issue) {
    case 'BEDWETTING':
      return <BedWetting />
    case 'AGRESSION':
      return <Violence />
    case 'FOODISSUES':
      return <FoodIssue />
    case 'ANXIETY':
      return <Anxiety />
    case 'SCHOOLISSUES':
      return <School />
    case 'STEALING':
      return <Stealing />
    case 'DEPRESSION':
      return <Depression />
    default:
      return <Other />
  }
}

BehaviorIssueIcon.propTypes = {
  rating: PropTypes.string,
}

export default BehaviorIssueIcon
