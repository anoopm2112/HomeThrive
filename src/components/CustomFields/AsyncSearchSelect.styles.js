import { makeStyles } from '@material-ui/core/styles'

export const useStyles = makeStyles((theme) => ({
  root: {
    width: '100%',
    // display: 'flex',
    // flexFlow: 'colum nowrap',
  },
  scrollList: {
    overflow: 'scroll',
    height: 300,
    minWidth: 100,
    border: `1px solid lightgrey`,
    borderRadius: 5,
  },
  smallScrollList: {
    overflow: 'scroll',
    height: 200,
    minWidth: 100,
  },
  searchContainer: {
    marginTop: theme.spacing(1),
    width: '100%',
  },
  field: {
    width: '100%',
    marginTop: theme.spacing(1),
  },
  loadMore: {
    color: theme.palette.primary,
    cursor: 'pointer',
  },
  buttons: {
    display: 'flex',
    flexFlow: 'column nowrap',
    justifyContent: 'center',
  },
  multiSelectButton: {
    marginTop: theme.spacing(2),
  },
  spaceBetween: {
    width: '100%',
    display: 'flex',
    flexFlow: 'row nowrap',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
  },
  listItem: {
    paddingLeft: 0,
  },

  popover: {
    pointerEvents: 'none',
  },
  padding: {
    padding: theme.spacing(1),
  },
  popoverTrigger: {
    cursor: 'pointer',
  },
}))
