import { makeStyles } from '@material-ui/core/styles'
import { DRAWER_WIDTH } from '~/lib/config'

export default makeStyles((theme) => ({
  root: {
    // display: 'flex',
    backgroundColor: 'rgb(236,237,238)',
    minHeight: '100vh',
  },
  appBar: {
    zIndex: theme.zIndex.drawer + 1,
    transition: theme.transitions.create(['width', 'margin'], {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.leavingScreen,
    }),
  },
  appBarShift: {
    marginLeft: DRAWER_WIDTH,
    width: `calc(100% - ${DRAWER_WIDTH}px)`,
    transition: theme.transitions.create(['width', 'margin'], {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.enteringScreen,
    }),
  },
  menuButton: {
    marginRight: 36,
  },
  hide: {
    display: 'none',
  },
  drawer: {
    width: DRAWER_WIDTH,
    flexShrink: 0,
    whiteSpace: 'nowrap',
    background: theme.palette.grey.black[600],
    borderTopRightRadius: 10,
    borderBottomRightRadius: 10,
    position: 'fixed',
  },
  dummyDrawer: {
    width: DRAWER_WIDTH,
    flexShrink: 0,
  },
  drawerButton: {
    color: '#ffffff',
  },
  drawerOpen: {
    width: DRAWER_WIDTH,
    transition: theme.transitions.create('width', {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.enteringScreen,
    }),
  },
  drawerClose: {
    transition: theme.transitions.create('width', {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.leavingScreen,
    }),
    overflowX: 'hidden',
    width: theme.spacing(7) + 1,
    [theme.breakpoints.up('sm')]: {
      width: theme.spacing(9) + 1,
    },
  },
  drawerToggle: {
    width: 50,
    height: 50,
    borderRadius: '50%',
    background: '#ffffff',
    position: 'fixed',
    top: 100,
    boxShadow: theme.shadows[3],
    transition: theme.transitions.create(['left'], {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.enteringScreen,
    }),
  },
  drawerToggleOpen: {
    left: DRAWER_WIDTH - 25,
  },
  drawerToggleClosed: {
    left: 50,
  },
  content: {
    flexGrow: 1,
    padding: theme.spacing(1),
    paddingTop: theme.spacing(4),
    transition: theme.transitions.create(['margin-left'], {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.enteringScreen,
    }),
  },
  contentOpen: {
    flexGrow: 1,
    padding: theme.spacing(1),
    marginLeft: DRAWER_WIDTH + 30,
  },
  contentClosed: {
    flexGrow: 1,
    padding: theme.spacing(1),
    marginLeft: '6.5rem',
  },
  header: {
    display: 'flex',
    justifyContent: 'space-between',
    padding: '0 1rem',
    alignItems: 'center',
    minHeight: '80px',
    margin: '0 0.5rem',
  },
  headerNav: {
    display: 'flex',
    justifyContent: 'flex-end',
    width: '280px',
    zIndex: 5
  },
  imageContainer: {
    width: '100%',
    minHeight: 'calc(100vh - 94px)',
    backgroundImage: `url(/images/FosterShare_Mobile.png)`,
    backgroundPosition: 'right',
    backgroundSize: 'contain',
    backgroundRepeat: 'no-repeat',
  },
  mobileImage: {
    height: '100vh',
  },
  homePageImage: {
    display: 'flex',
    justifyContent: 'flex-end'
  },
  backdrop: {
    zIndex: theme.zIndex.drawer + 1,
    color: '#fff',
  },
  center: {
    width: '100vw',
    height: '100vh',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
  },
}))
