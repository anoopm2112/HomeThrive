import { makeStyles, lighten } from '@material-ui/core/styles'
export default makeStyles((theme) => {
  return {
    logContent: {
      minWidth: '400px',
      minHeight: '300px',
    },
    logDate: {
      display: 'flex',
      justifyContent: 'flex-end',
      alignItems: 'center'
    },
    grayText: {
      color: theme.palette.grey.gray[400],
    },
    questionHeader: {
      color: theme.palette.grey.black[600],
      fontWeight: 600,
    },
    box: {
      color: theme.palette.grey.gray[100],
      backgroundColor: theme.palette.grey.black[600],
      fontWeight: 600,
      padding: theme.spacing(1),
      borderRadius: '5px',
    },
    notes: {
      width: '100%',
      border: `2px solid ${theme.palette.grey.gray[200]}`,
      borderRadius: '5px',
      marginTop: theme.spacing(1),
      '& > *:not(:first-child)': {
        borderTop: `2px solid ${theme.palette.grey.gray[200]}`,
      },
    },
    note: {
      padding: theme.spacing(1),
    },
    noteHeader: {
      display: 'flex',
      justifyContent: 'space-between',
    },
    noteTitle: {
      fontWeight: 900,
    },
    noteCreatedAt: {
      color: theme.palette.grey.gray[400],
      fontSize: '12px',
      fontWeight: 'bold',
    },
    noteText: {
      color: theme.palette.grey.black[400],
    },
    images: {
      display: 'flex',
      width: '100%',
      overflowX: 'scroll',
    },
    imagePaper: {
      padding: theme.spacing(1),
      width: 'auto',
    },
    image: {
      '&:not(:first-child)': {
        marginLeft: theme.spacing(1),
      },
      width: 90,
    },
    modalImage: {
      minWidth: 300,
      maxWidth: 700,
      marginLeft: '50%',
      marginTop: theme.spacing(2),
      transform: 'translateX(-50%)',
    },
    modalContent: {
      display: 'flex',
      flexFlow: 'column nowrap',
      alignItems: 'center',
      justifyContent: 'center',
    },
    modalButtons: {
      marginTop: theme.spacing(1),
    },
  }
})
