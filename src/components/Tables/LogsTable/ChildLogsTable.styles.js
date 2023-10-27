import { makeStyles } from '@material-ui/core/styles'
const headingFontFamily = 'Playfair Display'
const headingHeightOne = '2rem'
const headingHeightTwo = '1.25rem'

export default makeStyles((theme) => ({
  // default breakpoints: {xs: 0, sm: 600, md: 960, lg: 1280, xl: 1920}

  paper: {
    width: '100%',
    marginBottom: theme.spacing(2),
    padding: theme.spacing(2),
    '& $table': {
      minWidth: '0px',
      overflowX: 'scroll',
    },
    '&$dashboardTable': {
      // remove padding for table so rows are full-width
      padding: 0,
    },
    '& .paper-header': {
      paddingLeft: theme.spacing(2),
      marginBottom: theme.spacing(0),
      '& .subheading': {
        color: '#778791',
        fontSize: '0.75rem',
        fontWeight: 'bold',
      },
      '& .heading': {
        fontFamily: headingFontFamily,
        fontSize: headingHeightOne,
        fontWeight: 'bold',
      },
    },
    '& .empty-table-row': {
      display: 'none',
    },
  },
}))
