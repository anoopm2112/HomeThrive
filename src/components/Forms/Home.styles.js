import { makeStyles } from '@material-ui/core/styles'

export default makeStyles((theme) => ({
  newHeadingTop: {
    fontFamily: 'Montserrat',
    color: '#002244',
    fontSize: '31px',
  },
  newHeading: {
    fontFamily: 'Montserrat',
    marginBottom: theme.spacing(3),
    color: '#002244',
    fontSize: '31px',
  },
  newHeadingSub: {
    fontFamily: 'Montserrat',
    marginBottom: theme.spacing(3),
    fontSize: '21px',
    fontWeight: 500,
    color: '#002244',
    marginBottom: '15px',
    marginTop: '-15px'
  },
  newSubHeading: {
    fontFamily: 'Montserrat',
    marginBottom: theme.spacing(1),
    // fontSize: '16px',
    fontWeight: 500,
    color: '#002244',
    // marginBottom: '12px'
  },
  newSubHeadingLast: {
    fontFamily: 'Montserrat',
    marginBottom: theme.spacing(1),
    // fontSize: '16px',
    fontWeight: 500,
    color: '#002244',
    marginBottom: '20px'
  },
  familyImage: {
    height: 'auto',
    width: '60vh',
    position: 'absolute',
    right: '0',
    marginTop: '-425px',
    display: 'block',
    marginLeft: 'auto',
    transform: 'scaleX(-1)',
    marginRight: '30px'
  },
  signInDiv: {
    marginTop: '15px',
    maxWidth: '444px'
  },
  signInText: {
    fontFamily: 'Montserrat',
    marginBottom: theme.spacing(1),
    fontSize: '16px',
    fontStyle: 'italic',
    fontWeight: 500,
    color: '#002244',
    marginTop: '5px',
  },
  signInButton: {
    height: '45px',
    width: '120px',
    fontSize: '16px'
  }
}))
