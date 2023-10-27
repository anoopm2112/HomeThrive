import { makeStyles } from '@material-ui/core/styles'

export default makeStyles((theme) => ({
  root: {
    display: 'flex',
    flexFlow: 'row nowrap',
    justifyContent: 'space-between',
    marginBottom: theme.spacing(3),
  },
  activeBreadcrumb: {
    color: theme.palette.grey.black[600],
  },
  link: {
    cursor: 'pointer',
  },
  buttonGroup: {
    maxHeight: 40,
  },
  smallText: {
    fontSize: 10,
    color: theme.palette.grey.gray[400],
  },
  left: {
    display: 'flex',
    flexFlow: 'column nowrap',
    alignItems: 'flex-end',
  },
}))
