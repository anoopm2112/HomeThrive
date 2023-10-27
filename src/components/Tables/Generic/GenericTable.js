import React, { useState, useEffect } from 'react'
import { useRouter } from 'next/router'
import { useLazyQuery, useQuery } from '@apollo/client'
import Alert from '@material-ui/lab/Alert'
import Checkbox from '@material-ui/core/Checkbox'
import Paper from '@material-ui/core/Paper'
import Typography from '@material-ui/core/Typography'
import TextField from '@material-ui/core/TextField'
import Table from '@material-ui/core/Table'
import TableBody from '@material-ui/core/TableBody'
import TableHead from '@material-ui/core/TableHead'
import TableCell from '@material-ui/core/TableCell'
import TableContainer from '@material-ui/core/TableContainer'
import TableSortLabel from '@material-ui/core/TableSortLabel'
import TablePagination from '@material-ui/core/TablePagination'
import Toolbar from '@material-ui/core/Toolbar'
import Hidden from '@material-ui/core/Hidden'
import CircularProgress from '@material-ui/core/CircularProgress'
import TableRow from '@material-ui/core/TableRow'
import CancelIcon from '@material-ui/icons/Cancel'
import SearchIcon from '@material-ui/icons/Search'
import Grid from '@material-ui/core/Grid'
import AsyncSearchSelect from '~/components/CustomFields/AsyncSearchSelect'
import { GET_AGENCIES } from '~/lib/queries/agencies'
import PropTypes from 'prop-types'
import useStyles from './GenericTable.styles'
import { EMPTY_TABLE_ROW_HEIGHT, LOCAL_STORAGE_UI_STATE } from '~/lib/config'
import T from '~/lib/text'
import clsx from 'clsx'
import ls from 'local-storage'

import withWidth from '@material-ui/core/withWidth'

const CustomHidden = (props) => {
  // dynamically hide based on whether left-drawer UI is open or closed
  const hiddenOn = props.drawerIsOpen
    ? props.hiddenOnDrawerOpen || props.hiddenOnDefault
    : props.hiddenOnDrawerClosed || props.hiddenOnDefault
  return <Hidden only={hiddenOn}>{props.children}</Hidden>
}

//   _____ ______ _   _ ______ _____  _____ _____   _______       ____  _      ______
//  / ____|  ____| \ | |  ____|  __ \|_   _/ ____| |__   __|/\   |  _ \| |    |  ____|
// | |  __| |__  |  \| | |__  | |__) | | || |         | |  /  \  | |_) | |    | |__
// | | |_ |  __| | . ` |  __| |  _  /  | || |         | | / /\ \ |  _ <| |    |  __|
// | |__| | |____| |\  | |____| | \ \ _| || |____     | |/ ____ \| |_) | |____| |____
//  \_____|______|_| \_|______|_|  \_\_____\_____|    |_/_/    \_\____/|______|______|
//

function GenericTable({
  title,
  query: FETCH_QUERY,
  variableBuilder,
  cellLayout,
  dataAccessor,
  pageInfoAccessor,
  allowSelect,
  defaultSortBy,
  defaultSortDirection,
  showToolbar,
  showPagination,
  buttons: Buttons,
  selectedButtons: SelectedButtons,
  footer: Footer,
  defaultRowsPerPage,
  onFetchComplete,
  paperHeader,
  paperClasses,
  placeholderZeroTableRows,
  fetchConfig,
  width: screenWidth,
  skip,
  refetch,
  onRefetchComplete,
  showFilter,
  setAgencyValue
}) {
  //  ___ ___ _____ _   _ ___
  // / __| __|_   _| | | | _ \
  // \__ \ _|  | | | |_| |  _/
  // |___/___| |_|  \___/|_|
  //
  const router = useRouter()
  const classes = useStyles()
  const [rowsPerPage, setRowsPerPage] = useState(defaultRowsPerPage)
  const [familyList, setFamilyList] = useState(null)
  const [tempData, setTempData] = useState(null)
  const [selectedAgency, setSelectedAgency] = useState(null)
  const [cursor, setCursor] = useState(null)
  const [extraCursor, setExtraCursor] = useState(null)
  const [cursorSet, setCursorSet] = useState(false)
  const [page, setPage] = useState(0)
  const [savedData, setSavedData] = useState(null)
  const [maxNumberOfRows, setMaxNumberOfRows] = useState(0)
  const [sortDirection, setSortDirection] = useState(defaultSortDirection)
  const [sortBy, setSortBy] = useState(defaultSortBy)
  const [selected, setSelected] = useState([])
  const [searchTerm, setSearchTerm] = useState('')
  const [filterSearchTerm, setFilterSearchTerm] = useState('')
  const [highestPage, setHighestPage] = useState(0)
  const [highestRowCount, setHighestRowCount] = useState(10)
  const [pageLoading, setPageLoading] = useState(false)
  const [searchHighestPage, setSearchHighestPage] = useState(0)
  const [searchCursor, setSearchCursor] = useState()
  const [filterCursor, setFilterCursor] = useState()
  const uiState = ls.get(LOCAL_STORAGE_UI_STATE) || {}

  //   ___  _   _ ___ _____   __
  //  / _ \| | | | __| _ \ \ / /
  // | (_) | |_| | _||   /\ V /
  //  \__\_\\___/|___|_|_\ |_|
  //
  const {
    loading: fetchLoading,
    data: fetchData,
    error: fetchError,
    fetchMore: fetchFetchMore,
    refetch: fetchRefetch,
  } = useQuery(FETCH_QUERY, {
    skip: !router || !classes || skip,
    notifyOnNetworkStatusChange: true,
    variables: selectedAgency ? variableBuilder({
      router,
      rowsPerPage,
      cursor: filterCursor,
      agencyId: selectedAgency
    }) : variableBuilder({
      router,
      rowsPerPage,
      cursor,
    }),
    onCompleted: (d) => {
      if((title == 'supportServices' || title == 'scheduledMessages' || title == 'med-logs') && !page){
        const pageInfoz = pageInfoAccessor(d)
        setExtraCursor(pageInfoz?.cursor)
        const newData = dataAccessor(d)
        if(tempData && tempData.length){
          let newFinalData = [...tempData, ...newData]
          newFinalData = newFinalData.filter((v,i,a)=>a.findIndex(t=>(t.id===v.id))===i)
          setTempData(newFinalData)
        } else{
          setTempData(newData)
        }
      }
      if (refetch && onRefetchComplete) onRefetchComplete(d)
      else if (onFetchComplete) onFetchComplete(d)
    },
    ...fetchConfig,
  })

  // SEARCH QUERY
  const [
    searchQuery,
    {
      loading: searchLoading,
      data: searchData,
      error: searchError,
      fetchMore: searchFetchMore,
    },
  ] = useLazyQuery(FETCH_QUERY, {
    notifyOnNetworkStatusChange: true,
    onCompleted: (d) => {
      if((title == 'supportServices' || title == 'scheduledMessages' || title == 'med-logs') && !page){
        const pageInfoz = pageInfoAccessor(d)
        setExtraCursor(pageInfoz?.cursor)
        const newData = dataAccessor(d)
        setTempData(newData)
      }
    }
  })

  //  _  _   _   _  _ ___  _    ___ ___  ___
  // | || | /_\ | \| |   \| |  | __| _ \/ __|
  // | __ |/ _ \| .` | |) | |__| _||   /\__ \
  // |_||_/_/ \_\_|\_|___/|____|___|_|_\|___/
  //

  // Calls the the LAZY QUERY search function,
  // to ping the API.
  function handleSearch(e, v) {
    e.preventDefault()
    setPage(0)
    setCursorSet(false)
    setSearchHighestPage(0)
    setFilterSearchTerm(searchTerm)
    if(selectedAgency){
      fetchFetchMore({
        variables: variableBuilder({
          router,
          rowsPerPage: 10,
          cursor: undefined,
          searchTerm: searchTerm,
          agencyId: selectedAgency
        }),
      }).then(res => {
        setFamilyList(selectedAgency ? res.data : null)
        const filteredPageInfo = pageInfoAccessor(res.data)
        setMaxNumberOfRows(filteredPageInfo?.count)
        setFilterCursor(filteredPageInfo?.cursor)
        const families = dataAccessor(res.data)
        const slicedData = families.slice(
          rowsPerPage * 0,
          rowsPerPage * 0 + rowsPerPage
        )
        const sortedData = sortBy ? sortDataByProperty(slicedData) : slicedData
        setSavedData(sortedData)
        setRowsPerPage(10)
      })
      setHighestPage(0)
      setHighestRowCount(10)
    } else{
      searchQuery({
        variables: variableBuilder({
          router,
          rowsPerPage,
          cursor: undefined,
          searchTerm: searchTerm,
        }),
      })
      setHighestPage(0)
      setHighestRowCount(10)   
    }
  }

  // increments or decrements the page
  function handleChangePage(e, page) {
    setPage(page)
    setCursorSet(false)
    if (searchTerm !== '') {
      if (page > searchHighestPage) {
        searchFetchMore({
          variables: selectedAgency ? variableBuilder({
            router,
            rowsPerPage,
            cursor: filterCursor,
            searchTerm,
            agencyId: selectedAgency
          }) : variableBuilder({
            router,
            rowsPerPage,
            cursor: searchCursor,
            searchTerm,
          }),
        })
        .then(res => {
          if(selectedAgency){
            const families = [...dataAccessor(familyList), ...dataAccessor(res.data)]
            let newFamilyList = familyList
            if(title == 'children'){
              newFamilyList.children.items = families
            } else {
              newFamilyList.families.items = families
            }
            setFamilyList(newFamilyList)
            const filteredPageInfo = pageInfoAccessor(res.data)
            setFilterCursor(filteredPageInfo?.cursor)
            const slicedData = families.slice(
              rowsPerPage * page,
              rowsPerPage * page + rowsPerPage
            )
            const sortedData = sortBy ? sortDataByProperty(slicedData) : slicedData
            setSavedData(sortedData)
          }
        })
      }
    } else if (page > highestPage) {
      setHighestPage(page)
      fetchFetchMore({
        variables: selectedAgency ? variableBuilder({
          router,
          rowsPerPage,
          cursor: filterCursor,
          agencyId: selectedAgency
        }) : variableBuilder({
          router,
          rowsPerPage,
          cursor: (title == 'supportServices' || title == 'scheduledMessages' || title == 'med-logs') ? (page ? extraCursor :cursor) : cursor,
        }),
      })
      .then(res => {
        if(title == 'supportServices' || title == 'scheduledMessages' || title == 'med-logs'){
          const pageInfoz = pageInfoAccessor(res.data)
          setExtraCursor(pageInfoz?.cursor)
          const newData = dataAccessor(res.data)
          if(tempData && tempData.length){
            if(pageInfoz.count != tempData.length){
              let newFinalData = [...tempData, ...newData]
              newFinalData.filter((v,i,a)=>a.findIndex(t=>(t.id===v.id))===i)
              setTempData(newFinalData)
            }
          } else{
            setTempData(newData)
          }
        }
        if(selectedAgency){
          const families = [...dataAccessor(familyList), ...dataAccessor(res.data)]
          let newFamilyList = familyList
          if(title == 'children'){
            newFamilyList.children.items = families
          } else {
            newFamilyList.families.items = families
          }
          setFamilyList(newFamilyList)
          const filteredPageInfo = pageInfoAccessor(res.data)
          setFilterCursor(filteredPageInfo?.cursor)
          const slicedData = families.slice(
            rowsPerPage * page,
            rowsPerPage * page + rowsPerPage
          )
          const sortedData = sortBy ? sortDataByProperty(slicedData) : slicedData
          setSavedData(sortedData)
        }
      })
    } else if (page <= highestPage) {
      const filteredPageInfo = pageInfoAccessor(familyList)
      setFilterCursor(filteredPageInfo?.cursor)
      const families = dataAccessor(familyList);
      const slicedData = families.slice(
        rowsPerPage * page,
        rowsPerPage * page + rowsPerPage
      )
      const sortedData = sortBy ? sortDataByProperty(slicedData) : slicedData
      setSavedData(sortedData)
    }
  }

  // changes the number of rows visible in the table
  function handleChangeRowsPerPage(e) {
    const val = parseInt(e?.target?.value)
    setPage(0)
    setCursorSet(false)
    setRowsPerPage(val)
    setPageLoading(true)
    if (val > highestRowCount) {
      setHighestRowCount(val)
      fetchFetchMore({
        variables: selectedAgency ? variableBuilder({
          router,
          rowsPerPage: val,
          cursor: filterCursor,
          agencyId: selectedAgency
        }) : variableBuilder({
          router,
          rowsPerPage: val,
          cursor: (title == 'supportServices' || title == 'scheduledMessages' || title == 'med-logs') ? (page ? extraCursor :cursor) : cursor,
        }),
      }).then(res => {
        if(selectedAgency){
          if(pageInfoAccessor(res.data).count > dataAccessor(familyList).length) {
            const families = [...dataAccessor(familyList), ...dataAccessor(res.data)]
            let newFamilyList = familyList
            if(title == 'children'){
              newFamilyList.children.items = families
            } else {
              newFamilyList.families.items = families
            }
            setFamilyList(newFamilyList)
            const filteredPageInfo = pageInfoAccessor(res.data)
            setFilterCursor(filteredPageInfo?.cursor)
            const slicedData = families.slice(
              val * 0,
              val * 0 + val
            )
            const sortedData = sortBy ? sortDataByProperty(slicedData) : slicedData
            setSavedData(sortedData)
            setPage(0)
          } else {
            const filteredPageInfo = pageInfoAccessor(familyList)
            setFilterCursor(filteredPageInfo?.cursor)
            const families = dataAccessor(familyList);
            const slicedData = families.slice(
              val * 0,
              val * 0 + val
            )
            const sortedData = sortBy ? sortDataByProperty(slicedData) : slicedData
            setSavedData(sortedData)
            setPage(0)
          }
          setPageLoading(false)
        } else{
          setPageLoading(false)
        }
      })
    } else if (val <= highestRowCount) {
        if(selectedAgency){
          const filteredPageInfo = pageInfoAccessor(familyList)
          setFilterCursor(filteredPageInfo?.cursor)
          const families = dataAccessor(familyList);
          const slicedData = families.slice(
            val * 0,
            val * 0 + val
          )
          const sortedData = sortBy ? sortDataByProperty(slicedData) : slicedData
          setSavedData(sortedData)
          setPage(0)
        }
        setPageLoading(false)
    }
  }

  // changes what to sort the table by
  function handleRequestSort(property) {
    const isAsc = sortBy === property && sortDirection === 'asc'
    setSortDirection(isAsc ? 'desc' : 'asc')
    setSortBy(property)
  }

  // sorts data
  function sortDataByProperty(data) {
    const accessor = cellLayout.find((e) => e?.id === sortBy).accessor
    const dataCopy = [...data]
    dataCopy.sort((a, b) => {
      const sortVal = sortDirection === 'desc' ? -1 : 1
      const valA = accessor(a) || ''
      const valB = accessor(b) || ''
      const A = typeof valA === 'string' ? valA.toLowerCase() : valA
      const B = typeof valB === 'string' ? valB.toLowerCase() : valB
      if (A < B) return -1 * sortVal
      if (A > B) return 1 * sortVal
      return 0
    })
    return dataCopy
  }

  // selects the row when the checkbox is clicked
  function handleRowSelect(d) {
    const i = selected.findIndex((e) => e === d)
    // add it to selected
    if (i === -1) setSelected([...selected, d])
    // remove it from selected
    else {
      const start = selected.slice(0, i)
      const end = selected.slice(i + 1)
      setSelected([...start, ...end])
    }
  }

  // selects all visible rows
  function handleSelectAll() {
    if (selected < rowsPerPage) {
      const dataToUse = searchData || fetchData
      const rawDataArray = dataAccessor(dataToUse)
      const slicedData = rawDataArray.slice(
        rowsPerPage * page,
        rowsPerPage * page + rowsPerPage
      )
      setSelected(slicedData)
    } else setSelected([])
  }

  // cancels a search query and resets the rows
  function clearSearch() {
    setSearchTerm('')
    setPage(0)
    setExtraCursor(null)
    setCursorSet(false)
    setRowsPerPage(10)
    setFilterSearchTerm('')
    if(selectedAgency){
      fetchFetchMore({
        variables: variableBuilder({
          router,
          rowsPerPage: 10,
          cursor: undefined,
          searchTerm: '',
          agencyId: selectedAgency
        }),
      }).then(res => {
        setFamilyList(selectedAgency ? res.data : null)
        const filteredPageInfo = pageInfoAccessor(res.data)
        setMaxNumberOfRows(filteredPageInfo?.count)
        setFilterCursor(filteredPageInfo?.cursor)
        const families = dataAccessor(res.data)
        const slicedData = families.slice(
          rowsPerPage * 0,
          rowsPerPage * 0 + rowsPerPage
        )
        const sortedData = sortBy ? sortDataByProperty(slicedData) : slicedData
        setSavedData(sortedData)
        setRowsPerPage(10)
      })
      setHighestPage(0)
      setHighestRowCount(10)
    } else {
      searchQuery({
        variables: variableBuilder({
          router,
          rowsPerPage: 10,
          cursor: undefined,
          searchTerm: '',
        }),
      }) // reloads original data
    }
  }

  function handleFilterChange(value) {
    setSearchTerm('')
    setPage(0)
    setCursorSet(false)
  }

  //  ___   _ _____ _     ___ ___ ___ ___
  // |   \ /_\_   _/_\   | _ \ _ \ __| _ \
  // | |) / _ \| |/ _ \  |  _/   / _||  _/
  // |___/_/ \_\_/_/ \_\ |_| |_|_\___|_|
  //

  // make sure only display the number of rowsPerPage
  const numSelected = selected.length
  const dataToUse = searchData || fetchData
  const pageInfo = pageInfoAccessor(dataToUse)

  const rawDataArray = dataAccessor(dataToUse)
  const slicedData = ((title == 'supportServices' || title == 'scheduledMessages' || title == 'med-logs') ? tempData : rawDataArray)?.slice(
    rowsPerPage * page,
    rowsPerPage * page + rowsPerPage
  )
  const sortedData = sortBy ? sortDataByProperty(slicedData) : slicedData
  const finalData = sortedData
  const loading = pageLoading || fetchLoading || searchLoading
  const error = fetchError || searchError
  const emptyRows = rowsPerPage - (selectedAgency ? savedData : finalData)?.length
  const isZeroTableRows = loading === false && rawDataArray?.length === 0

  function isSelected(d) {
    const i = selected.findIndex((e) => e === d)
    return i !== -1
  }

  const columnHeaders = cellLayout.map((layout, i) => {
    const direction = sortBy === layout.id ? sortDirection : false
    const isActiveSort = sortBy === layout.id
    return (
      <CustomHidden
        key={`${layout.id}.${i}`}
        screenWidth={screenWidth}
        drawerIsOpen={uiState.drawerIsOpen}
        hiddenOnDefault={layout.hiddenOn}
        hiddenOnDrawerOpen={layout.hiddenOnDrawerOpen}
        hiddenOnDrawerClosed={layout.hiddenOnDrawerClosed}
      >
        <TableCell
          align={layout.labelAlign || 'left'}
          padding="default"
          sortDirection={direction}
        >
          <TableSortLabel
            active={isActiveSort}
            direction={sortDirection}
            onClick={() => handleRequestSort(layout.id)}
          >
            <strong>{layout.label}</strong>
          </TableSortLabel>
        </TableCell>
      </CustomHidden>
    )
  })
  const headers = allowSelect
    ? [
        <TableCell padding="checkbox" key="select-checkbox">
          <Checkbox
            indeterminate={numSelected > 0 && numSelected < maxNumberOfRows}
            checked={maxNumberOfRows > 0 && numSelected === maxNumberOfRows}
            onChange={handleSelectAll}
            inputProps={{ 'aria-label': 'select all' }}
          />
        </TableCell>,
        ...columnHeaders,
      ]
    : [...columnHeaders]

  const rows = (selectedAgency ? savedData : finalData)?.map((d, index) => (
    <TableRow key={`${d.id}.${index}`} hover tabIndex={-1} selected={false}>
      {allowSelect && (
        <TableCell padding="checkbox">
          <Checkbox
            onClick={() => handleRowSelect(d)}
            checked={isSelected(d)}
            inputProps={{ 'aria-labelledby': `${d.id}.${index}` }}
          />
        </TableCell>
      )}
      {cellLayout.map((layout, i) => (
        <CustomHidden
          key={`${d.id}.${layout.id}.${index}.${i}`}
          screenWidth={screenWidth}
          drawerIsOpen={uiState.drawerIsOpen}
          hiddenOnDefault={layout.hiddenOn}
          hiddenOnDrawerOpen={layout.hiddenOnDrawerOpen}
          hiddenOnDrawerClosed={layout.hiddenOnDrawerClosed}
        >
          <TableCell>{layout.render(d, router)}</TableCell>
        </CustomHidden>
      ))}
    </TableRow>
  ))

  //  _    ___ ___ _____ ___ _  _ ___ ___  ___
  // | |  |_ _/ __|_   _| __| \| | __| _ \/ __|
  // | |__ | |\__ \ | | | _|| .` | _||   /\__ \
  // |____|___|___/ |_| |___|_|\_|___|_|_\|___/
  //

  useEffect(() => {
    if (pageInfo && !cursorSet) {
      if (searchTerm !== '') {
        setSearchCursor(pageInfo?.cursor)
      } else {
        if(!page){
          setCursor(pageInfo?.cursor)
          setCursorSet(true)
        }
      }
      setMaxNumberOfRows(pageInfo?.count)
    }
  }, [pageInfo])

  useEffect(() => {
    if(!loading){
      setPage(0)
      setCursor(undefined)
      setCursorSet(false)
      fetchFetchMore({
        variables: variableBuilder({ router, rowsPerPage, cursor: undefined }),
        fetchPolicy: 'network-only',
      })
    }
  }, [refetch])

  // useEffect(() => {
  //   setPage(0)
  //   setCursor(undefined)
  //   setSearchTerm('')
  //   setFilterSearchTerm('')
  //   if(showFilter){
  //     setAgencyValue(selectedAgency)
  //   }
  //   fetchFetchMore({
  //     variables: selectedAgency ? variableBuilder({
  //       router,
  //       rowsPerPage: 10,
  //       cursor: undefined,
  //       searchTerm: searchTerm,
  //       agencyId: selectedAgency
  //     }) : variableBuilder({
  //       router,
  //       rowsPerPage: 10,
  //       cursor: undefined,
  //       searchTerm: searchTerm,
  //     }),
  //   }).then(res => {
  //     setFamilyList(selectedAgency ? res.data : null)
  //     const filteredPageInfo = pageInfoAccessor(res.data)
  //     setMaxNumberOfRows(filteredPageInfo?.count)
  //     setFilterCursor(filteredPageInfo?.cursor)
  //     const families = dataAccessor(res.data)
  //     const slicedData = families.slice(
  //       rowsPerPage * page,
  //       rowsPerPage * page + rowsPerPage
  //     )
  //     const sortedData = sortBy ? sortDataByProperty(slicedData) : slicedData
  //     setSavedData(sortedData)
  //     setRowsPerPage(10)
  //   })
  //   setHighestPage(0)
  //   setHighestRowCount(10)
  // }, [selectedAgency])

  //  ___ ___ _  _ ___  ___ ___
  // | _ \ __| \| |   \| __| _ \
  // |   / _|| .` | |) | _||   /
  // |_|_\___|_|\_|___/|___|_|_\
  //
  if (isZeroTableRows === true && placeholderZeroTableRows !== null) {
    return (
      <div className={`${title}-table`}>
        <Paper className={paperClasses || classes.paper}>
          {paperHeader && (
            <div className={classes.headerClasses}>{paperHeader}</div>
          )}
          <GenericToolbar
            title={title}
            showToolbar={showToolbar}
            classes={classes}
            numSelected={numSelected}
            handleSearch={handleSearch}
            searchTerm={searchTerm}
            setSearchTerm={setSearchTerm}
            loading={loading}
            clearSearch={clearSearch}
            selected={selected}
            SelectedButtons={SelectedButtons}
            finalData={finalData}
            Buttons={Buttons}
            setFilterValue={handleFilterChange}
            setSelectedAgency={setSelectedAgency}
            showFilter={showFilter}
          />
          {placeholderZeroTableRows}
        </Paper>
      </div>
    )
  }

  return (
    <div className={`${title}-table`}>
      <Paper className={paperClasses || classes.paper}>
        {paperHeader && (
          <div className={classes.headerClasses}>{paperHeader}</div>
        )}
        <GenericToolbar
          title={title}
          showToolbar={showToolbar}
          classes={classes}
          numSelected={numSelected}
          handleSearch={handleSearch}
          searchTerm={searchTerm}
          setSearchTerm={setSearchTerm}
          loading={loading}
          clearSearch={clearSearch}
          selected={selected}
          SelectedButtons={SelectedButtons}
          finalData={finalData}
          Buttons={Buttons}
          setFilterValue={handleFilterChange}
          setSelectedAgency={setSelectedAgency}
          showFilter={showFilter}
        />
        <TableContainer className={classes.tableContainer}>
          {!!error && (
            <Alert severity="error">
              {error?.message ? error.message : JSON.stringify(error)}
            </Alert>
          )}
          <Table
            aria-labelledby="Table"
            size="medium"
            aria-label={`${title} table`}
          >
            <TableHead>
              <TableRow>{headers}</TableRow>
            </TableHead>
            <TableBody>
              {loading ? (
                <TableRow>
                  <TableCell
                    colSpan={cellLayout.length}
                    style={{ textAlign: 'center' }}
                  >
                    <CircularProgress />
                  </TableCell>
                </TableRow>
              ) : (
                <>
                  {rows}
                  {emptyRows > 0 && (
                    <TableRow
                      className="empty-table-row"
                      style={{ height: EMPTY_TABLE_ROW_HEIGHT * emptyRows }}
                    >
                      <TableCell colSpan={8} />
                    </TableRow>
                  )}
                </>
              )}
            </TableBody>
          </Table>
        </TableContainer>
        {showPagination && (
          <TablePagination
            rowsPerPageOptions={[10, 25, 50]}
            component="div"
            count={maxNumberOfRows}
            rowsPerPage={rowsPerPage}
            page={page}
            onChangePage={handleChangePage}
            onChangeRowsPerPage={handleChangeRowsPerPage}
            labelRowsPerPage={T('RowsPerPage')}
          />
        )}
        {Footer && <Footer />}
      </Paper>
    </div>
  )
}

function GenericToolbar({
  title,
  showToolbar,
  classes,
  numSelected,
  handleSearch,
  searchTerm,
  setSearchTerm,
  loading,
  clearSearch,
  selected,
  SelectedButtons,
  finalData,
  Buttons,
  setFilterValue,
  setSelectedAgency,
  showFilter
}) {
  return (
    <>
      {showToolbar && (
        <Toolbar
          className={clsx(classes.toolbar, {
            [classes.toolbarHighlight]: numSelected > 0,
          })}
        >
          {numSelected > 0 ? (
            <Typography
              className={classes.toolbarTitle}
              color="inherit"
              variant="subtitle1"
              component="div"
            >
              {numSelected} selected
            </Typography>
          ) : (
            <div
            className={showFilter ? classes.searchwithFilter : classes.search}>
            <Grid container spacing={2}>
              <Grid item sm={12} md={4}>
              <form
                noValidate
                autoComplete="off"
                className={showFilter ? classes.searchFieldwithFilter : classes.searchField}
                onSubmit={handleSearch}
              >
                <TextField
                  id={`${title}-search`}
                  variant="outlined"
                  className={classes.searchTextField}
                  size="small"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  disabled={loading}
                  InputProps={{
                    startAdornment: <SearchIcon />,
                    endAdornment: searchTerm.length ? (
                      <CancelIcon onClick={clearSearch} />
                    ) : null,
                  }}
                />
              </form>
              </Grid>
              <Grid item sm={12} md={4}>
              {showFilter && 
                <AsyncSearchSelect
                  className={classes.filter}
                  query={GET_AGENCIES}
                  label="Filter by Agencies"
                  dataAccessor={(v) => v?.agencies?.items}
                  pageInfoAccessor={(v) => v?.agencies?.pageInfo}
                  labelAccessor={(v) => `${v.name}, ${v.city}`}
                  onSelect={(v) => {
                    setSelectedAgency(v?.id)
                    setFilterValue(v?.id)}
                  }
                /> 
              }
              </Grid>
            </Grid>
            </div>
          )}
          <div className={classes.buttons}>
            {selected.length > 0
              ? SelectedButtons !== undefined && (
                  <SelectedButtons
                    selected={selected}
                    visibleData={finalData}
                  />
                )
              : Buttons !== undefined && <Buttons visibleData={finalData} />}
          </div>
        </Toolbar>
      )}
    </>
  )
}

GenericTable.defaultProps = {
  defaultSortBy: '',
  defaultSortDirection: 'desc',
  showToolbar: true,
  showPagination: true,
  defaultRowsPerPage: 10,
  fetchConfig: {},
  placeholderZeroTableRows: null,
  skip: false,
  refetch: false,
  onRefetchComplete: () => console.log('REFETCH COMPLETE'),
}

GenericTable.propTypes = {
  title: PropTypes.string.isRequired,
  query: PropTypes.object.isRequired,
  variableBuilder: PropTypes.func.isRequired,
  cellLayout: PropTypes.array.isRequired,
  dataAccessor: PropTypes.func.isRequired,
  pageInfoAccessor: PropTypes.func.isRequired,
  defaultSortBy: PropTypes.string,
  showToolbar: PropTypes.bool,
  showPagination: PropTypes.bool,
  onFetchComplete: PropTypes.func,
  // buttons: PropTypes.element,
  // selectedButtons: PropTypes.element,
  fetchConfig: PropTypes.object.isRequired,
  placeholderZeroTableRows: PropTypes.element,
  skip: PropTypes.bool,
  refetch: PropTypes.bool,
  onRefetchComplete: PropTypes.func,
}

export default withWidth()(GenericTable)
