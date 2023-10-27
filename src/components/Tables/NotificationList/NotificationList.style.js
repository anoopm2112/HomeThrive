import { makeStyles } from '@material-ui/core/styles'
export default makeStyles((theme) => {
  console.log(theme)
  return {
    root: {
      width: 400,
    },
    header: {
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'center',
      padding: theme.spacing(1),
      paddingBottom: 0,
    },
    notificationCardContent: {
      width: '100%',
    },
    notificationCard: {
      display: 'flex',
      flexFlow: 'row nowrap',
      alignItems: 'flex-start',
      justifyContent: 'flex-start',
      width: '100%',
      padding: theme.spacing(1),
      marginTop: theme.spacing(1) / 2,
      border: '2px solid transparent',
      cursor: 'pointer',
      '&:hover': {
        backgroundColor: theme.palette.grey[200],
      },
      '&:active': {
        border: `2px solid ${theme.palette.secondary['400']}`,
      },
    },
    notificationCardHeader: {
      display: 'flex',
      flexFlow: 'row nowrap',
      justifyContent: 'space-between',
    },
    notificationHeaderText: {
      fontSize: 12,
    },
    notificationIsNew: {
      fontWeight: theme.typography.fontWeightBold,
      color: theme.palette.primary['400'],
      backgroundColor: theme.palette.grey[100],
    },
    notificationTime: {
      color: 'grey',
    },
    notificationDescription: {
      fontSize: 12,
      color: 'grey',
    },
    bullet: {
      backgroundColor: theme.palette.secondary[400],
      borderRadius: '50%',
      marginRight: theme.spacing(1) / 2,
      marginTop: theme.spacing(1) / 2,
    },
    loading: {
      marginTop: theme.spacing(1) / 2,
      marginRight: theme.spacing(1) / 2,
    },
    link: {
      cursor: 'pointer',
    },
  }
})
