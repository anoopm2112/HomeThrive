import { useEffect, useRef, useState } from 'react'
import phone from 'phone'
import { array } from 'prop-types'

export function snakeCaseToProperCase(string) {
  const split = string.split('_')
  const caps = split.map((e) => e[0].toUpperCase() + e.slice(1).toLowerCase())
  return caps.join(' ')
}

export function properCaseToSnakeCase(string) {
  const split = string.split(' ')
  const caps = split.map((e) => e[0].toUpperCase() + e.slice(1))
  return caps.join('_')
}

export function replaceBadCharacters(string) {
  const result = string.replace(/’/g, "'")
  return result
}

export function onlyUnique(array) {
  const dic = {}
  array.forEach((e) => (dic[e.__ref] = e))
  return Object.values(dic)
}

export function onlyUpdatedObjectProperties(ob1, ob2) {
  const result = {}
  Object.entries(ob1).forEach(([key, value]) => {
    if (JSON.stringify(value) !== JSON.stringify(ob2[key]))
      result[key] = ob2[key]
  })
  return result
}

export function recursiveOnlyUpdatedObjectProperties(ob1, ob2) {
  const result = {}
  Object.entries(ob1).forEach(([key, value]) => {
    if (value !== null && typeof value === 'object') {
      result[key] = recursiveOnlyUpdatedObjectProperties(value, ob2[key])
    } else if (JSON.stringify(value) !== JSON.stringify(ob2[key]))
      result[key] = ob2[key]
  })
  return result
}

export function useDebounce(value, delay) {
  // State and setters for debounced value
  const [debouncedValue, setDebouncedValue] = useState(value)

  useEffect(
    () => {
      // Update debounced value after delay
      const handler = setTimeout(() => {
        setDebouncedValue(value)
      }, delay)

      // Cancel the timeout if value changes (also on delay change or unmount)
      // This is how we prevent debounced value from updating if value is changed ...
      // .. within the delay period. Timeout gets cleared and restarted.
      return () => {
        clearTimeout(handler)
      }
    },
    [value, delay] // Only re-call effect if value or delay changes
  )

  return debouncedValue
}

export function formatDateForMaterialUIsStupidComponents(date) {
  const d = new Date(new Date(date).toLocaleString())
  let month = '' + (d.getMonth() + 1)
  let day = '' + d.getDate()
  const year = d.getFullYear()

  if (month.length < 2) month = '0' + month
  if (day.length < 2) day = '0' + day

  return [year, month, day].join('-')
}

export function formatTimeForMaterialUIsStupidComponents(date) {
  const d = new Date(new Date(date).toLocaleString())
  let hours = d.getHours()
  let minutes = d.getMinutes()

  hours = hours < 10 ? `0${hours}` : hours
  minutes = minutes < 10 ? `0${minutes}` : minutes

  return [hours, minutes].join(':')
}

export function formatDateTimeToISOString(date, time) {
  const nd = `${date} ${time}`
  try {
    return new Date(nd).toISOString()
  } catch (e) {}
}

export function formatPhoneNumber(phoneNumberString) {
  const result = phone(phoneNumberString, 'USA')
  return result[0]
}

export function not(a, b, idProp = 'id') {
  return a.filter((av) => b.findIndex((bv) => bv[idProp] === av[idProp]) === -1)
}

export function intersection(a, b, idProp = 'id') {
  return a.filter((av) => b.findIndex((bv) => bv[idProp] === av[idProp]) !== -1)
}

// trims all whitespace from string s in an object.
export function trimStringsInObject(obj) {
  // is string
  if (typeof obj === 'string') return obj.trim()
  else if (typeof obj === 'object' || Array.isArray(obj)) {
    // is array
    if (Array.isArray(obj)) return trimStringsInArray(obj)
    // is object
    else {
      const entries = Object.entries(obj)
      const result = {}
      for (const [key, value] of entries) {
        if (
          typeof value === 'object' &&
          value !== null &&
          !Array.isArray(value)
        ) {
          result[key] = trimStringsInObject(value)
        } else if (Array.isArray(value)) {
          result[key] = trimStringsInArray(value)
        } else if (typeof value === 'string') {
          result[key] = value.trim()
        } else {
          result[key] = value
        }
      }
      return result
    }
    // is anything else
  } else {
    return obj
  }
}

export function trimStringsInArray(arr) {
  return arr.map((e) => trimStringsInObject(e))
}

export function get(object, path, value) {
  const pathArray = Array.isArray(path)
    ? path
    : path.split('.').filter((key) => key)
  const pathArrayFlat = pathArray.flatMap((part) =>
    typeof part === 'string' ? part.split('.') : part
  )
  const checkValue = pathArrayFlat.reduce((obj, key) => obj && obj[key], object)
  return checkValue === undefined ? value : checkValue
}

/**
 *  ___  ___ ___ _   _  ___   _  _ ___ _    ___ ___ ___  ___
 * |   \| __| _ ) | | |/ __| | || | __| |  | _ \ __| _ \/ __|
 * | |) | _|| _ \ |_| | (_ | | __ | _|| |__|  _/ _||   /\__ \
 * |___/|___|___/\___/ \___| |_||_|___|____|_| |___|_|_\|___/
 *
 */

export function useTraceUpdate(props) {
  const prev = useRef(props)
  useEffect(() => {
    const changedProps = Object.entries(props).reduce((ps, [k, v]) => {
      if (prev.current[k] !== v) {
        ps[k] = [prev.current[k], v]
      }
      return ps
    }, {})
    if (Object.keys(changedProps).length > 0) {
      console.log('Changed props:', changedProps)
    }
    prev.current = props
  })
}

/**
 *    _   ___  ___  _    _    ___     ___ _    ___ ___ _  _ _____   __  __ ___ ___  ___ ___   _   _ _____ ___ _    ___
 *   /_\ | _ \/ _ \| |  | |  / _ \   / __| |  |_ _| __| \| |_   _| |  \/  | __| _ \/ __| __| | | | |_   _|_ _| |  / __|
 *  / _ \|  _/ (_) | |__| |_| (_) | | (__| |__ | || _|| .` | | |   | |\/| | _||   / (_ | _|  | |_| | | |  | || |__\__ \
 * /_/ \_\_|  \___/|____|____\___/   \___|____|___|___|_|\_| |_|   |_|  |_|___|_|_\\___|___|  \___/  |_| |___|____|___/
 *
 */

export function mergeObjectWithItems(existing = {}, incoming = {}, { args }) {
  const result = {
    ...existing,
    ...incoming,
    items: onlyUnique([...(existing?.items || []), ...incoming.items]),
    pageInfo: { ...existing.pageInfo, ...incoming.pageInfo },
  }
  return result
}

export function keyArgsForSearchOnly(e) {
  return e?.input?.search ? `.SRCH:${e?.input?.search}` : ''
}

export function keyArgsForSearchAndAgentId(e) {
  let result = ''
  result += e?.input?.search ? `.SRCH:${e?.input?.search}` : ''
  result += e?.input?.agentId ? `.AGNT:${e?.input?.agentId}` : ''
  return result
}

export function keyArgsForSearchAndChildId(e) {
  let result = ''
  result += e?.input?.search ? `.SRCH:${e?.input?.search}` : ''
  result += e?.input?.id ? `.CHLD:${e?.input?.id}` : ''
  return result
}
export function keyArgsForSearchChildIdAndFamilyId(e) {
  let result = ''
  result += e?.input?.search ? `.SRCH:${e?.input?.search}` : ''
  result += e?.input?.id ? `.CHLD:${e?.input?.id}` : ''
  result += e?.input?.parentId ? `.FMLY:${e?.input?.parentId}` : ''
  return result
}

export function keyArgsForSearchAndFamilyId(e) {
  let result = ''
  result += e?.input?.search ? `.SRCH:${e?.input?.search}` : ''
  result += e?.input?.familyId ? `.FMLY:${e?.input?.familyId}` : ''
  return result
}

export function keyArgsForSearchAndParentId(e) {
  let result = ''
  result += e?.input?.search ? `.SRCH:${e?.input?.search}` : ''
  result += e?.input?.parentId ? `.FMLY:${e?.input?.parentId}` : ''
  return result
}

export function keyArgsForSearchAndEventId(e) {
  let result = ''
  result += e?.input?.search ? `.SRCH:${e?.input?.search}` : ''
  result += e?.input?.eventId ? `.EVNT:${e?.input?.eventId}` : ''
  return result
}

export function keyArgsForSearchEventIdAndType(e) {
  let result = ''
  result += e?.input?.search ? `.SRCH:${e?.input?.search}` : ''
  result += e?.input?.eventType ? `.EVNTTYPE:${e?.input?.eventType}` : ''
  result += e?.input?.id ? `.EVNT:${e?.input?.id}` : ''
  return result
}

export function keyArgsForSearchAndLimit(e) {
  let result = ''
  result += e?.input?.search ? `.SRCH:${e?.input?.search}` : ''
  result += e?.input?.pagination?.limit
    ? `.LIMIT:${e?.input?.pagination?.limit}`
    : ''
  return result
}
/**
 * Updates the cache with the new item
 * @param {string} field - string name of cache object to update
 * @param {obj} createData - the created data returned from the create query
 * @param {*} cache - the cache object
 * @param {*} fragment - the fragment object
 */
export function updateCache(field, createData, cache, fragment) {
  cache.modify({
    broadcast: true,
    fields: {
      [field]: (existing) => {
        const newRef = cache.writeFragment({
          data: createData,
          fragment,
        })
        const newItems = [...existing.items, newRef]
        const existingPageInfo = existing.pageInfo
        const newCacheObj = {
          ...existing,
          items: newItems,
          pageInfo: {
            ...existingPageInfo,
            count: existingPageInfo.count + 1,
          },
        }
        // console.log('NEW CACHE OBJ', newCacheObj)
        return newCacheObj
      },
    },
  })
}
