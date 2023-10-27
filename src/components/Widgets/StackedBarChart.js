import React from 'react'
import _ from 'lodash'

import useStyles from '~/components/Widgets/StackedBarChart.styles'

const StackedBarChart = (props) => {
  const classes = useStyles()

  const barLabels = []
  const barItems = []
  const legendLabels = []
  let isPercentageChart = false
  const percentLabel = _.get(props, ['data', 0, 'label'], 'Data Value')
  let percentValue = 0.0
  const totalValue = _.sumBy(props.data, (d) => d.value)

  if (props.data.length === 1) {
    isPercentageChart = true
    percentValue = props.data[0].value
  }

  for (const item of props.data) {
    const value = isPercentageChart ? percentValue * 100 : item.value
    legendLabels.push(
      <div key={item.label} className="legend-label">
        <div className="circle" style={{ backgroundColor: item.color }} />
        <div className="label">{item.label}</div>
      </div>
    )
    // skip zero values
    if (!isPercentageChart && parseInt(value) === 0) {
      continue
    }
    barLabels.push(
      <div
        key={item.label}
        className="bar-value-label"
        style={{
          flexGrow: 0,
          flexShrink: 1,
          flexBasis: `${(value / totalValue) * 100}%`,
        }}
      >
        {item.value}
      </div>
    )
    barItems.push(
      <div
        key={item.label}
        className="bar-box"
        style={{
          flexGrow: 0,
          flexShrink: 1,
          flexBasis: `${(value / totalValue) * 100}%`,
          backgroundColor: item.color,
        }}
      ></div>
    )
  }

  if (isPercentageChart === true) {
    // fill the remaining space up to 100%
    barItems.push(
      <div
        key="percentage-chart-fill"
        className="bar-item"
        style={{
          flexGrow: 0,
          flexShrink: 1,
          flexBasis: `${100 - percentValue * 100}%`,
        }}
      >
        <div className="bar-box" style={{ backgroundColor: '#DBE2E7' }}>
          &nbsp;
        </div>
      </div>
    )
  }

  let legend = null
  if (isPercentageChart !== true) {
    // add the legend describing the chart labels
    legend = <div className="chart-legend">{legendLabels}</div>
  }

  return (
    <div className={classes.stackedBarChart}>
      {isPercentageChart === true ? null : (
        <div className="bar-labels">{barLabels}</div>
      )}
      <div className="bar-items">{barItems}</div>
      {isPercentageChart === true ? (
        <div className="percent-chart-label">
          <div className="left">{percentLabel}</div>
          <div className="right">{Math.round(percentValue * 100)}&#37;</div>
        </div>
      ) : (
        legend
      )}
    </div>
  )
}

export default StackedBarChart
