/**
 *
 *  _____ _   ___ _    ___   ___ _   _ _  _  ___ _____ ___ ___  _  _ ___
 * |_   _/_\ | _ ) |  | __| | __| | | | \| |/ __|_   _|_ _/ _ \| \| / __|
 *   | |/ _ \| _ \ |__| _|  | _|| |_| | .` | (__  | |  | | (_) | .` \__ \
 *   |_/_/ \_\___/____|___| |_|  \___/|_|\_|\___| |_| |___\___/|_|\_|___/
 *
 *
 *
 */

export function descendingComparator(a, b, orderBy) {
  if (b[orderBy] < a[orderBy]) {
    return -1
  }
  if (b[orderBy] > a[orderBy]) {
    return 1
  }
  return 0
}

export function getComparator(order, orderBy) {
  return order === 'desc'
    ? (a, b) => descendingComparator(a, b, orderBy)
    : (a, b) => -descendingComparator(a, b, orderBy)
}

export function stableSort(array, comparator) {
  const stabilizedThis = array.map((el, index) => [el, index])
  stabilizedThis.sort((a, b) => {
    const order = comparator(a[0], b[0])
    if (order !== 0) return order
    return a[1] - b[1]
  })
  return stabilizedThis.map((el) => el[0])
}

export function createTableHelperFunctions({
  order,
  orderBy,
  rows,
  selected,
  setOrder,
  setOrderBy,
  setSelected,
}) {
  return {
    handleRequestSort: (event, property) => {
      const isAsc = orderBy === property && order === 'asc'
      setOrder(isAsc ? 'desc' : 'asc')
      setOrderBy(property)
    },

    handleSelectAllClick: (event) => {
      if (event.target.checked) {
        const newSelecteds = rows.map((n) => n.id)
        setSelected(newSelecteds)
        return
      }
      setSelected([])
    },

    handleClick: (event, id) => {
      const selectedIndex = selected.indexOf(id)
      let newSelected = []

      if (selectedIndex === -1) {
        newSelected = newSelected.concat(selected, id)
      } else if (selectedIndex === 0) {
        newSelected = newSelected.concat(selected.slice(1))
      } else if (selectedIndex === selected.length - 1) {
        newSelected = newSelected.concat(selected.slice(0, -1))
      } else if (selectedIndex > 0) {
        newSelected = newSelected.concat(
          selected.slice(0, selectedIndex),
          selected.slice(selectedIndex + 1)
        )
      }

      setSelected(newSelected)
    },

    // determines if the item is selected
    isSelected: (id) => {
      return selected.indexOf(id) !== -1
    },
  }
}

export const initialPageInfoState = {
  cursor: undefined,
  hasNextPage: false,
  count: 0,
  page: 0,
  rowsPerPage: 10,
  highestPage: 0,
  highestNumRows: 10,
}
