import { makeStyles } from '@material-ui/core/styles'

export default makeStyles((theme) => ({
  placeholder: {
    '& .placeholder-flex': {
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      textAlign: 'center',
      padding: '3rem',
      '& .spacer': {
        height: `${theme.spacing(2)}px`,
      },
      '& .subheading': {
        color: '#778791',
        fontSize: '0.75rem',
        fontWeight: 'bold',
      },
    },
  },
}))
