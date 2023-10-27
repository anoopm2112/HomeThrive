import { useState } from 'react'
import Validator from 'validatorjs'
import validator from 'validator'
import moment from 'moment';
import T from '~/lib/text'

/**
 *
 * @param {obj} data - form state of data to validate
 * @param {obj} strategy - obj with keys as the key of the data to validate and the value
 *  as an array of properties to validate
 */

Validator.register(
  'phone',
  (value) => {
    const isMobilePhone = validator.isMobilePhone(value, 'any')
    return isMobilePhone
  },
  T('ValidatorPhoneNumber')
)

Validator.register(
  'regular',
  (value) => {
    const match = value.match(/[^a-zA-Z0-9- '.,]+/gim)
    return !(match && match.length > 0)
  },
  T('ValidatorRegular')
)

Validator.register(
  'regularExtended',
  (value) => {
    const match = value.match(/[^a-zA-Z0-9- '.,+&%$!:?]+/gim)
    return !(match && match.length > 0)
  },
  T('ValidatorExtended')
)

Validator.register(
  'link',
  (value) => {
    return validator.isURL(value)
  },
  T('ValidatorLink')
)

Validator.register(
  'password',
  (value) => {
    return value.length >= 8
  },
  T('ValidatorPassword')
)

export function useValidator(data, rules) {
  const [showErrors, setShowErrors] = useState(false)
  const validation = new Validator(data, rules)
  return {
    showErrors,
    setShowErrors,
    validation,
  }
}

export function checkForDateErrors(d, s, e, future) {
  if (!d) return
  const date = new Date(d)
  const start = new Date(s)
  const end = new Date(e)
  let foundError = false

  const result = {
    start: '',
    end: '',
    date: '',
  }

  if (future === 'future' && new Date() > date) {
    foundError = true
    result.date = T('ValidatorFutureDates')
  } else if (future === 'past' && new Date() < date) {
    foundError = true
    result.date = T('ValidatorFutureDates')
  }
  if (start && new Date() > start) {
    foundError = true
    result.start = T('ValidatorFutureStart')
  }
  if (end && end < start) {
    foundError = true
    result.start = T('ValidatorStartBeforeEnd')
    result.end = T('ValidatorStartBeforeEnd')
  }

  if (foundError) return result
}

export function checkForPastDateErrors(date) {
  if (!date) return
  const d = date instanceof Date ? date : new Date(date)
  if (new Date() < d) return T('ValidatorPastDates')
}

export function checkForScheduleDateErrors(dateValue) {
  if (!dateValue) return
  const time = new Date(dateValue)
  const today = new Date()
  let foundError = false

  const result = {
    time: '',
    date: '',
  }

  if(!moment(time).isAfter(today)){
    foundError = true
    if(moment(time).isSame(today, "day")){
      foundError = true
      result.time = T('ValidatorFutureTime')
    } else{
      result.date = T('ValidatorFutureDates')
      result.time = T('ValidatorFutureTime')
    }
  }

  if (foundError) return result
}
