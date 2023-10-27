import { lighten, makeStyles } from '@material-ui/core/styles'
const headingFontFamily = 'Playfair Display'
const headingHeightOne = '2rem'
const headingHeightTwo = '1.25rem'
export default makeStyles((theme) => ({
  table: {
    minWidth: 750,
    '& td:last-child': {
      '& svg': {
        cursor: 'pointer',
      },
    },
  },
  paper: {
    width: '100%',
    marginBottom: theme.spacing(2),
  },
  headerClasses: {
    paddingLeft: theme.spacing(2),
    paddingTop: theme.spacing(2),
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
  visuallyHidden: {
    border: 0,
    clip: 'rect(0 0 0 0)',
    height: 1,
    margin: -1,
    overflow: 'hidden',
    padding: 0,
    position: 'absolute',
    top: 20,
    width: 1,
  },
  search: {
    display: 'flex',
    alignItems: 'center',
    width: '100%',
  },
  searchwithFilter: {
    display: 'flex',
    alignItems: 'center',
    width: '75%',
  },
  searchField: {
    width: '100%',
  },
  searchFieldwithFilter: {
    width: '100%',
  },
  searchTextField: {
    width: '100%',
  },
  filter: {
    width: '100%',
    height: '40px',
    '& label': {
      fontSize: '14px',
      transform: 'translate(14px, 13px) scale(1)'
    },
    '& .MuiAutocomplete-inputRoot': {
      height: '40px',
      padding: '0',
      paddingRight: '60px !important'
    },
    '& .MuiAutocomplete-endAdornment': {
      backgroundColor: 'white',
      zIndex: 1
    },
    '& .MuiSvgIcon-root': {
      backgroundColor: 'white',
      zIndex: 2
    }
  },
  toolbar: {
    display: 'flex',
    justifyContent: 'space-between',
    paddingTop: theme.spacing(1),
    paddingLeft: theme.spacing(2),
    paddingRight: theme.spacing(1),
  },
  toolbarHighlight:
    theme.palette.type === 'light'
      ? {
          color: theme.palette.secondary.main,
          backgroundColor: lighten(theme.palette.secondary.light, 0.85),
        }
      : {
          color: theme.palette.text.primary,
          backgroundColor: theme.palette.secondary.dark,
        },
  toolbarTitle: {
    flex: '1 1 100%',
  },
  loading: {
    marginRight: theme.spacing(2),
  },
  buttons: {
    '& button': {
      marginLeft: theme.spacing(1),
    },
  },
}))
