import React, { useEffect, useState, useRef } from 'react'
import { useLazyQuery } from '@apollo/client'
import TextField from '@material-ui/core/TextField'
import Typography from '@material-ui/core/Typography'
import Checkbox from '@material-ui/core/Checkbox'
import Button from '@material-ui/core/Button'
import List from '@material-ui/core/List'
import ListItem from '@material-ui/core/ListItem'
import ListItemIcon from '@material-ui/core/ListItemIcon'
import ListItemText from '@material-ui/core/ListItemText'
import Grid from '@material-ui/core/Grid'
import Popover from '@material-ui/core/Popover'
import CircularProgress from '@material-ui/core/CircularProgress'
import FindReplaceIcon from '@material-ui/icons/FindReplace'
import { useDebounce } from '~/lib/utils'
import PropTypes from 'prop-types'
import { useStyles } from '~/components/CustomFields/AsyncSearchSelect.styles'
import T from '~/lib/text'
import clsx from 'clsx'

/**
 *  Provides an asychronous search for any given query.
 *
 * @param {object} props :
 *     query - gql query to load
 *     label - label to display on the search component
 *     dataAccessor - func that tells how to get the relevant array of
 *          options from the data returned from the query
 *     labelAccessor - func that tells how to get the label from an individual item
 *          returned from `dataAccessor`
 *     pageInfoAccessor - function to get the pageInfo related to the query
 *     onSelect - what to do when a value is selected
 *     defaultValue - the default value (obj) to have.
 *     idProp - the default property of the options object to use to compare equality of (defaults to "id")
 *
 */
function InviteeSelect({
  query,
  label,
  dataAccessor,
  labelAccessor,
  pageInfoAccessor,
  idProp,
  limit,
  onChange,
  invitees = [],
  inviteeLabelAccessor,
  participantLimit,
}) {
  const [term, setTerm] = useState('')
  const [selected, setSelected] = useState([])
  const [selectAll, setSelectAll] = useState(false)
  const [cursor, setCursor] = useState(0)
  const [popoverOpen, setPopoverOpen] = useState(false)
  const [showParticipantLimitError, setShowParticipantLimitError] = useState(
    false
  )
  const popoverAnchor = useRef(null)
  const classes = useStyles()

  const [
    searchQuery,
    { loading: searchLoading, data: searchData, error: searchError, fetchMore },
  ] = useLazyQuery(query, {
    notifyOnNetworkStatusChange: true,
  })

  const searchTerm = useDebounce(term, 500)

  //     _      _
  //  __| |__ _| |_ __ _   _ __ _ _ ___ _ __
  // / _` / _` |  _/ _` | | '_ \ '_/ -_) '_ \
  // \__,_\__,_|\__\__,_| | .__/_| \___| .__/
  //                      |_|          |_|

  function createOptions(data) {
    return data.map((e, i) => (
      <CheckboxOption
        key={`${e[idProp]}.${i}`}
        classes={classes}
        data={e}
        idProp={idProp}
        handleSelect={handleSelect}
        isSelected={isSelected}
        isInvited={isInvited}
        labelAccessor={labelAccessor}
        disabled={selectAll}
      />
    ))
  }

  const data = dataAccessor(searchData) || []
  const pageInfo = pageInfoAccessor(searchData) || {}
  const possibleEls = createOptions(data)
  const selectedEls = selectAll
    ? [
        <CheckboxOption
          key="All Families"
          classes={classes}
          data={{ id: '', firstName: T('AllFamilies'), lastName: '' }}
          idProp={idProp}
          handleSelect={handleSelectAll}
          isSelected={() => true}
          isInvited={isInvited}
          labelAccessor={labelAccessor}
        />,
      ]
    : createOptions(selected)

  /**
   *
   *  _                 _ _
   * | |_  __ _ _ _  __| | |___ _ _ ___
   * | ' \/ _` | ' \/ _` | / -_) '_(_-<
   * |_||_\__,_|_||_\__,_|_\___|_| /__/
   *
   */

  function handleSearchChange(e) {
    setTerm(e.target.value)
  }

  function loadMore() {
    fetchMore({
      variables: {
        input: {
          search: searchTerm || '',
          pagination: {
            limit: limit,
            cursor: cursor,
          },
        },
      },
    })
  }

  function handleSelect(value) {
    // limits participants
    const selectedIndex = selected.findIndex((e) => e[idProp] === value[idProp])
    if (
      selectedIndex === -1 &&
      selected.length !== 0 &&
      participantLimit !== 0 &&
      selected.length >= participantLimit
    ) {
      setShowParticipantLimitError(true)
      return
    }

    const newChecked = [...selected]

    if (selectedIndex === -1) {
      newChecked.push(value)
    } else {
      newChecked.splice(selectedIndex, 1)
    }

    setSelected(newChecked)
    onChange(newChecked)
  }

  function isSelected(a) {
    const index = selected.findIndex((e) => e.id === a.id)
    return index !== -1
  }

  function isInvited(a) {
    const index = invitees.findIndex((e) => e.parentId == a.id) // eslint-disable-line
    return index !== -1
  }

  function handleSelectAll() {
    !selectAll ? onChange([]) : onChange(selected)
    setSelectAll(!selectAll)
  }

  /**
   *
   *  _ _    _
   * | (_)__| |_ ___ _ _  ___ _ _ ___
   * | | (_-<  _/ -_) ' \/ -_) '_(_-<
   * |_|_/__/\__\___|_||_\___|_| /__/
   *
   */

  useEffect(() => {
    searchQuery({
      variables: {
        input: {
          search: term,
          pagination: {
            limit,
          },
        },
      },
    })
  }, [searchTerm])

  useEffect(() => {
    setCursor(pageInfo.cursor)
  }, [pageInfo])

  return (
    <Grid className={classes.root} container item xs={12} spacing={2}>
      <Grid item xs={12}>
        <TextField
          size="small"
          className={classes.searchContainer}
          id="search"
          variant="outlined"
          label={`${T('Search')} ${label}`}
          value={term}
          helperText={!!showParticipantLimitError && T('ParticipantLimitError')}
          onChange={handleSearchChange}
          InputProps={{
            endAdornment: searchLoading ? (
              <CircularProgress color="inherit" size={20} />
            ) : (
              pageInfo.hasNextPage && (
                <FindReplaceIcon
                  className={classes.loadMore}
                  onClick={loadMore}
                />
              )
            ),
          }}
        />
      </Grid>
      {participantLimit === 0 && (
        <Grid item xs={12}>
          <Button
            size="small"
            variant="contained"
            color="secondary"
            onClick={handleSelectAll}
          >
            {selectAll ? T('Deselect') : T('Select')} {T('AllFamilies')}
          </Button>
        </Grid>
      )}

      <Grid item xs={12}>
        <List className={classes.scrollList} dense component="div" role="list">
          {possibleEls}
        </List>
      </Grid>
      <Grid item xs={12}>
        <div className={classes.spaceBetween}>
          <Typography variant="h4">{T('SelectedParticipants')}</Typography>
          <Typography variant="body1">
            {selected.length} {T('Families')}.
          </Typography>
        </div>
        <List
          className={clsx([classes.scrollList, classes.smallScrollList])}
          dense
          component="div"
          role="list"
        >
          {selectedEls}
        </List>
      </Grid>
      {invitees.length > 0 && (
        <Grid item xs={12} className={classes.spaceBetween}>
          <Typography variant="h4">{T('Invited')}.</Typography>

          <Typography
            variant="body1"
            className={classes.popoverTrigger}
            ref={popoverAnchor}
            aria-owns={popoverOpen ? 'mouse-over-popover' : undefined}
            aria-haspopup="true"
            onMouseEnter={() => setPopoverOpen(true)}
            onMouseLeave={() => setPopoverOpen(false)}
          >
            {invitees.length} {T('Families')}
          </Typography>
          <Popover
            id="mouse-over-popover"
            open={popoverOpen}
            anchorEl={popoverAnchor.current}
            className={classes.popover}
            classes={{
              paper: classes.padding,
            }}
            onClose={() => setPopoverOpen(false)}
            disableRestoreFocus
            anchorOrigin={{
              vertical: 'top',
              horizontal: 'right',
            }}
            transformOrigin={{
              vertical: 'bottom',
              horizontal: 'left',
            }}
          >
            <InvitedList
              invitees={invitees}
              idProp={idProp}
              classes={classes}
              labelAccessor={inviteeLabelAccessor}
            />
          </Popover>
        </Grid>
      )}
    </Grid>
  )
}

InviteeSelect.defaultProps = {
  idProp: 'id',
  listProp: 'items',
  limit: 30,
  invitees: [],
}

InviteeSelect.propTypes = {
  idProp: PropTypes.string,
  query: PropTypes.object.isRequired, // should be graphql query
  label: PropTypes.string.isRequired,
  dataAccessor: PropTypes.func.isRequired,
  labelAccessor: PropTypes.func.isRequired,
  onChange: PropTypes.func.isRequired,
  limit: PropTypes.number,
  invitees: PropTypes.array,
  participantLimit: PropTypes.number,
}

export default InviteeSelect

//  _        _                                                     _
// | |_  ___| |_ __  ___ _ _   __ ___ _ __  _ __  ___ _ _  ___ _ _| |_ ___
// | ' \/ -_) | '_ \/ -_) '_| / _/ _ \ '  \| '_ \/ _ \ ' \/ -_) ' \  _(_-<
// |_||_\___|_| .__/\___|_|   \__\___/_|_|_| .__/\___/_||_\___|_||_\__/__/
//            |_|                          |_|
//

function CheckboxOption({
  classes,
  data,
  isSelected,
  idProp,
  labelAccessor,
  handleSelect,
  isInvited,
  disabled,
}) {
  return (
    <ListItem
      className={classes.listItem}
      key={data[idProp]}
      role="listitem"
      button
      onClick={() => handleSelect(data)}
      disabled={isInvited(data) || disabled}
    >
      <ListItemIcon>
        <Checkbox
          className={classes.checkbox}
          checked={isSelected(data) || isInvited(data)}
          tabIndex={-1}
          disableRipple
          inputProps={{ 'aria-labelledby': `list-item-${data[idProp]}` }}
        />
      </ListItemIcon>
      <ListItemText
        id={`list-item-${data[idProp]}`}
        primary={labelAccessor(data)}
      />
    </ListItem>
  )
}

function InvitedList({ classes, labelAccessor, idProp, invitees = [] }) {
  const listItems = invitees.map((data) => (
    <ListItem className={classes.listItem} key={data[idProp]} role="listitem">
      <ListItemText
        id={`list-item-${data[idProp]}`}
        primary={labelAccessor(data)}
      />
    </ListItem>
  ))

  return (
    <List className={classes.padding} dense component="div" role="list">
      {listItems}
    </List>
  )
}
