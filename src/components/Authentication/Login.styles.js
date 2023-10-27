import { makeStyles } from '@material-ui/core/styles'

export default makeStyles((theme) => ({
  root: {
    width: '100%',
  },
  field: {
    width: '100%',
    marginTop: theme.spacing(2),
  },
  flexEnd: {
    display: 'flex',
    justifyContent: 'flex-end',
  },
  loggedInButton: {
    marginTop: theme.spacing(2),
    marginRight: theme.spacing(2),
  },
  spaceOut: {
    marginLeft: theme.spacing(1),
  },
  newHeading: {
    fontFamily: 'Montserrat',
    marginBottom: theme.spacing(3),
    color: '#002244'
  },
  newHeadingSub: {
    fontFamily: 'Montserrat',
    marginBottom: theme.spacing(3),
    fontSize: '26px',
    fontWeight: 500,
    color: '#002244'
  },
  newSubHeading: {
    fontFamily: 'Montserrat',
    marginBottom: theme.spacing(1),
    fontWeight: 500,
    color: '#002244'
  },
  loginDiv: {
    marginTop: theme.spacing(3),
  },
  familyImage: {
    height: 'auto',
    width: '60vh',
    position: 'absolute',
    right: '0',
    marginTop: '-420px',
    display: 'block',
    marginLeft: 'auto',
    transform: 'scaleX(-1)',
    // marginRight: '-80px'
  },
  loggedFamilyImage: {
    height: 'auto',
    width: '60vh',
    position: 'absolute',
    right: '0',
    marginTop: '-290px',
    display: 'block',
    marginLeft: 'auto',
    transform: 'scaleX(-1)',
    // marginRight: '-80px'
  },
}))
