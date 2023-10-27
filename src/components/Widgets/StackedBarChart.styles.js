import { makeStyles } from '@material-ui/core/styles'
export default makeStyles((theme) => ({
  stackedBarChart: {
    paddingTop: '40px', // this allows labels to be negative-margin'd for horizontal charts with percentages (no labels) and with labels (yes labels) to line up visually
    '& .bar-labels': {
      height: '40px',
      marginTop: '-40px',
    },
    '& .bar-items, .bar-labels': {
      display: 'flex',
      flexDirection: 'row',
      borderRadius: '0.25rem',
      overflow: 'hidden',
    },
    '& .bar-box': {
      height: '60px',
    },
    '& .bar-value-label': {
      fontSize: '0.7rem',
      textAlign: 'center',
      alignSelf: 'flex-end',
      color: '#778791',
    },
    '& .percent-chart-label': {
      display: 'flex',
      flexDirection: 'row',
      justifyContent: 'space-between',
      margin: '0.85rem 0',
      '& .left': {
        fontWeight: 'bold',
        whiteSpace: 'nowrap',
      },
      '& .right': {
        color: '#778791',
      },
    },
    '& .chart-legend': {
      display: 'flex',
      flexDirection: 'row',
      margin: '1rem 0',
      '& .legend-label': {
        display: 'flex',
        flexDirection: 'row',
        alignItems: 'center',
        margin: '0 0.5rem 0 0',
      },
      '& .circle': {
        height: '0.7rem',
        width: '0.7rem',
        borderRadius: '50%',
      },
      '& .label': {
        fontSize: '.7rem',
        marginLeft: '0.25rem',
        color: '#1E2429',
        fontWeight: 'bold',
      },
    },
  },
}))
