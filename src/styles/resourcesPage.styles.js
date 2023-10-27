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
  resourceImage: {
    maxWidth: 600,
    width: '100%',
    marginTop: theme.spacing(3),
    marginBottom: theme.spacing(3),
  },
  iframe: {
    width: '100%',
    height: '100%',
    border: 0,
  },
  block: {
    display: 'flex',
    flexFlow: 'row nowrap',
    justifyContent: 'space-between',
    width: '100%',
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
  articleDetailsTitle: {
    marginBottom: theme.spacing(2),
  },
  articleDetailsAuthor: {
    marginBottom: theme.spacing(2),
  },
  formControl: {
    margin: theme.spacing(1),
    minWidth: 120,
  },
  selectEmpty: {
    marginTop: theme.spacing(2),
  },
  articleHeader: {
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
}))
