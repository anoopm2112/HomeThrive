import { makeStyles } from '@material-ui/core/styles'
export default makeStyles((theme) => ({
  paper: {
    width: '100%',
    marginBottom: theme.spacing(2),
    padding: theme.spacing(3),
  },
  link: {
    marginTop: theme.spacing(1),
    textDecoration: 'none',
  },
  block: {
    display: 'flex',
    flexFlow: 'row nowrap',
    justifyContent: 'space-between',
    width: '100%',
    marginBottom: theme.spacing(1),
  },
  group: {
    display: 'flex',
    flexFlow: 'column nowrap',
    marginTop: theme.spacing(1),
  },
  groupTitle: {
    fontWeight: 'bold',
    color: '#95A1AC',
  },
  detailsTitle: {
    marginBottom: theme.spacing(2),
  },
  detailsAuthor: {
    marginBottom: theme.spacing(2),
  },
  formControl: {
    margin: theme.spacing(1),
    minWidth: 120,
  },
  selectEmpty: {
    marginTop: theme.spacing(2),
  },
  header: {
    display: 'flex',
    justifyContent: 'space-between',
  },
  divider: {
    margin: theme.spacing(1),
  },
  disableCursor: {
    cursor: 'not-allowed',
    pointerEvents: 'none',
  },
  dark: {
    fontWeight: 'bold',
    color: theme.palette.grey.black[600],
  },
}))
