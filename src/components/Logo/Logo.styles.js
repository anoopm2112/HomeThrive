import { makeStyles } from '@material-ui/core/styles'

export const useStyles = makeStyles((theme) => ({
  menuLogo: {
    width: 30,
  },
  root: {
    display: 'flex',
    flexFlow: 'row nowrap',
  },
  logo: {
    width: 40,
    marginRight: theme.spacing(1),
  },
  logoText: {
    display: 'flex',
    flexFlow: 'column nowrap',
  },
  subheading: {
    color: theme.palette.grey.gray[400],
    fontSize: '12px',
  },
  menuLogoText: {
    color: theme.palette.grey.gray[50],
    display: 'flex',
    flexFlow: 'column nowrap',
  },
  menuSubheading: {
    color: theme.palette.grey.gray[400],
    fontSize: '12px',
  },
}))
