import { makeStyles } from '@material-ui/core/styles'

export const useGenericFormStyles = makeStyles((theme) => ({
  root: {
    width: '100%',
  },
  field: {
    width: '100%',
    marginTop: theme.spacing(1),
    zIndex: 1000
  },
  divider: {
    marginTop: theme.spacing(1),
    marginBottom: theme.spacing(1),
  },
  button: {
    marginTop: theme.spacing(1),
    marginBottom: theme.spacing(1),
    width: 200,
  },
  spaceBetween: {
    backgroundColor: 'red',
    display: 'flex',
    flexFlow: 'row nowrap',
    justifyContent: 'space-between',
  },
  title: {
    marginBottom: theme.spacing(2),
  },
  categoriesDropDown: {
    display: 'flex',
    flexFlow: 'row nowrap',
    alignItems: 'center',
  },
  helpIcon: {
    marginLeft: theme.spacing(1),
  },
  popover: {
    maxWidth: 250,
  },
  paper: {
    padding: theme.spacing(1),
  },
}))
