import React, { useEffect, useState } from 'react'
import { useLazyQuery } from '@apollo/client'
import TextField from '@material-ui/core/TextField'
import Autocomplete from '@material-ui/lab/Autocomplete'
import CircularProgress from '@material-ui/core/CircularProgress'
import FindReplaceIcon from '@material-ui/icons/FindReplace'
import { useDebounce } from '~/lib/utils'
import PropTypes from 'prop-types'
import T from '~/lib/text'
import { useStyles } from './AsyncSearchSelect.styles'

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
function AsyncSearchSelect({
  className,
  label,
  query,
  onSelect,
  dataAccessor,
  labelAccessor,
  pageInfoAccessor,
  defaultValue,
  idProp,
  limit,
  required,
  disabled,
  allSelection,
  onSearchComplete,
  helperText,
  agencyId
}) {
  const [term, setTerm] = useState('')
  const [open, setOpen] = useState(false)
  const [selected, setSelected] = useState(defaultValue)
  const [cursor, setCursor] = useState(0)
  const [
    searchQuery,
    { loading: searchLoading, data: searchData, error: searchError, fetchMore },
  ] = useLazyQuery(query, {
    notifyOnNetworkStatusChange: true,
    fetchPolicy: agencyId ? "no-cache" : "network-only",
    onCompleted: (d) => {
      if (onSearchComplete) onSearchComplete(d)
    },
  })

  const searchTerm = useDebounce(term, 500)

  /**
   *
   *  _                 _ _
   * | |_  __ _ _ _  __| | |___ _ _ ___
   * | ' \/ _` | ' \/ _` | / -_) '_(_-<
   * |_||_\__,_|_||_\__,_|_\___|_| /__/
   *
   */

  function handleSearchChange(v) {
    setTerm(v.target.value)
  }

  function handleSelectChange(e, v) {
    // console.log(v)
    setSelected(v)
    onSelect(v)
  }

  function loadMore() {
    fetchMore({
      variables: {
        input: agencyId ? {
          search: searchTerm || '',
          agencyId: agencyId,
          pagination: {
            limit: limit,
            cursor: cursor,
          },
        } : {
          search: searchTerm || '',
          pagination: {
            limit: limit,
            cursor: cursor,
          },
        },
      },
    })
  }

  //     _      _
  //  __| |__ _| |_ __ _   _ __ _ _ ___ _ __
  // / _` / _` |  _/ _` | | '_ \ '_/ -_) '_ \
  // \__,_\__,_|\__\__,_| | .__/_| \___| .__/
  //                      |_|          |_|

  const data = dataAccessor(searchData) || []
  const pageInfo = pageInfoAccessor(searchData) || {}
  const options = [...data]
  const isError = !!searchError
  const helpText = searchError ? T('ErrorFetching') : helperText || ''

  // if the default value isnt in the options provided by the query, add it.
  if (
    defaultValue &&
    !options.find((e) => e[idProp] === defaultValue[idProp])
  ) {
    options.push(defaultValue)
  }

  if (
    allSelection &&
    !options.find((e) => e[idProp] === allSelection[idProp])
  ) {
    options.push(allSelection)
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
        input: agencyId ? {
          search: term,
          agencyId: agencyId,
          pagination: {
            limit,
          },
        } : {
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

  const classes = useStyles()
  return (
    <Autocomplete
      className={className}
      open={open}
      onOpen={() => {
        setOpen(true)
      }}
      onClose={() => {
        setOpen(false)
      }}
      getOptionSelected={(option, value) => option[idProp] == value[idProp]} // eslint-disable-line
      getOptionLabel={labelAccessor}
      options={options}
      onChange={handleSelectChange}
      loading={searchLoading}
      value={selected}
      disabled={disabled}
      renderInput={(params) => (
        <TextField
          {...params}
          error={isError}
          label={label}
          onChange={handleSearchChange}
          helperText={helpText}
          variant="outlined"
          disabled={disabled}
          required={required}
          InputProps={{
            ...params.InputProps,
            endAdornment: (
              <>
                {searchLoading ? (
                  <CircularProgress color="inherit" size={20} />
                ) : null}
                {!searchLoading && pageInfo.hasNextPage && (
                  <FindReplaceIcon
                    disabled={disabled}
                    className={classes.loadMore}
                    onClick={loadMore}
                  />
                )}
                {params.InputProps.endAdornment}
              </>
            ),
          }}
        />
      )}
    />
  )
}

AsyncSearchSelect.defaultProps = {
  idProp: 'id',
  listProp: 'items',
  limit: 10,
  disabled: false,
}

AsyncSearchSelect.propTypes = {
  idProp: PropTypes.string,
  query: PropTypes.object.isRequired, // should be graphql query
  label: PropTypes.string.isRequired,
  dataAccessor: PropTypes.func.isRequired,
  labelAccessor: PropTypes.func.isRequired,
  onSelect: PropTypes.func.isRequired,
  defaultValue: PropTypes.object,
  limit: PropTypes.number,
  disabled: PropTypes.bool,
}

export default AsyncSearchSelect
