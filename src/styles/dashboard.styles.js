import { makeStyles } from '@material-ui/core/styles'

const headingFontFamily = 'Playfair Display'
const headingHeightOne = '2rem'
const headingHeightTwo = '1.25rem'

export default makeStyles((theme) => ({
  // default breakpoints: {xs: 0, sm: 600, md: 960, lg: 1280, xl: 1920}
  tileNotifications: {},
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
  },
  dashboardTable: {
    '& .paper-header': {
      padding: `${theme.spacing(2)}px ${theme.spacing(2)}px 0 ${theme.spacing(
        2
      )}px`,
      marginBottom: theme.spacing(0),
      '& .subheading': {
        color: '#778791',
        fontSize: '0.75rem',
        fontWeight: 'bold',
      },
    },
    '& .empty-table-row': {
      display: 'none',
    },
  },
  dashboardTile: {
    padding: theme.spacing(2),
    '& .heading': {
      fontFamily: headingFontFamily,
      fontSize: headingHeightOne,
      fontWeight: 'bold',
    },
    '& .subheading': {
      fontWeight: 'bold',
      color: '#778791',
      fontSize: '0.75rem',
    },
    '& svg': {
      height: '54px',
      width: '54px',
    },
    '& .icon': {
      alignSelf: 'flex-start',
    },
  },
  fsCaseManager: {
    '& .flex-left-right': {
      display: 'flex',
      flexDirection: 'row',
      justifyContent: 'space-between',
      alignItems: 'flex-start',
      '& > .spacer': {
        width: theme.spacing(2),
        flexGrow: 0,
        flexShrink: 0,
      },
      '& .left': {
        flex: '2 1 1px',
      },
      '& .right': {
        flex: '3 1 1px',
      },
      [theme.breakpoints.down('md')]: {
        display: 'block',
      },
    },
    '& $dashboardTable': {
      '& .heading': {
        fontFamily: headingFontFamily,
        fontSize: headingHeightTwo,
        fontWeight: 'bold',
      },
      height: 'auto',
    },
    '& $tileNotifications': {
      '& .subheading': {
        color: '#778791',
        fontSize: '0.75rem',
      },
      '& .heading': {
        fontFamily: headingFontFamily,
        fontSize: headingHeightOne,
        fontWeight: 'bold',
      },
      '& .text': {
        color: '#778791',
        fontSize: '0.75rem',
      },
      '& .button': {
        margin: '0.5rem 0',
        backgroundColor: '#223149',
        borderRadius: '0.25rem',
        color: '#ffffff',
        fontWeight: 'bold',
        cursor: 'pointer',
        width: '120px',
        padding: theme.spacing(1),
        textAlign: 'center',
        whiteSpace: 'nowrap',
      },
    },
  },
  fsAgency: {
    '& .flex-thirds': {
      marginBottom: theme.spacing(3),
      display: 'flex',
      flexDirection: 'row',
      justifyContent: 'space-between',
      '& > .spacer': {
        width: theme.spacing(3),
        flexGrow: 0,
        flexShrink: 0,
      },
      [theme.breakpoints.down('sm')]: {
        marginBottom: theme.spacing(2),
        display: 'block',
        '& $dashboardTile': {
          marginBottom: theme.spacing(2),
          '&:last-child': {
            marginBottom: 0,
          },
        },
      },
    },
    '& .flex-tables': {
      display: 'flex',
      flexDirection: 'row',
      justifyContent: 'space-between',
      alignItems: 'flex-start',
      overflowX: 'hidden',
      '& > .spacer': {
        width: theme.spacing(3),
        flexGrow: 0,
        flexShrink: 0,
        backgroundColor: 'blue',
      },
      '& .upcoming-visits-table': {
        flex: '2 1 1px',
      },
      '& .children-logs-table': {
        flex: '3 1 2px',
      },
      [theme.breakpoints.down('sm')]: {
        display: 'block',
      },
    },
    '& $dashboardTile': {
      flex: '1 1 0px',
      display: 'flex',
      flexDirection: 'column',
      '& .flex-half': {
        display: 'flex',
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
      },
    },
    '& $dashboardTable': {
      '& .heading': {
        fontFamily: headingFontFamily,
        fontSize: headingHeightTwo,
        fontWeight: 'bold',
      },
      height: 'auto',
    },
  },
  fsAdmin: {
    '& .charts': {
      '& svg': {
        height: '54px',
        width: '54px',
      },
      '& > .flex-half': {
        display: 'flex',
        flexDirection: 'row',
        '& .spacer': {
          width: theme.spacing(3),
        },
      },
    },
    '& $dashboardTable': {
      '& .heading': {
        fontFamily: headingFontFamily,
        fontSize: headingHeightOne,
        fontWeight: 'bold',
      },
      height: 'auto',
    },
  },
  flexHeadingWithIcon: {
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    '& .heading': {
      fontFamily: headingFontFamily,
      fontSize: headingHeightOne,
      fontWeight: 'bold',
    },
    '& .subheading': {
      color: '#778791',
      fontSize: '0.75rem',
    },
  },
  dashFamilies: {
    '& .flex-half': {
      display: 'flex',
      flexDirection: 'row',
      '& > *': {
        flexBasis: '100%',
      },
      '& > .spacer': {
        flexBasis: 'auto',
        flexShrink: 0,
        width: theme.spacing(3),
      },
    },
  },
}))
