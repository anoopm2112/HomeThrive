import React, { useState, useEffect, useContext } from 'react'
import { useMutation } from '@apollo/client'
import { CREATE_MESSAGE, MESSAGE_FRAGMENT, CREATE_SCHEDULED_MESSAGE, SCHEDULED_MESSAGE_FRAGMENT } from '~/lib/queries/messages'
import { GET_FAMILIES } from '~/lib/queries/families'
import { NotificationContext } from '~/components/Contexts/NotificationContext'
import { useValidator, checkForScheduleDateErrors } from '~/lib/validators'
import Typography from '@material-ui/core/Typography'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button'
import FormGroup from '@material-ui/core/FormGroup'
import FormControlLabel from '@material-ui/core/FormControlLabel'
import Checkbox from '@material-ui/core/Checkbox'
import Alert from '@material-ui/lab/Alert'
import Dialog from '@material-ui/core/Dialog'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import CircularProgress from '@material-ui/core/CircularProgress'
import MenuItem from '@material-ui/core/MenuItem';
import AsyncSearchSelect from '~/components/CustomFields/AsyncSearchSelect'
import PropTypes from 'prop-types'
import { useGenericFormStyles } from '~/components/Forms/Form.styles'
import { 
  updateCache, 
  trimStringsInObject, 
  formatDateTimeToISOString, 
  formatDateForMaterialUIsStupidComponents, 
  formatTimeForMaterialUIsStupidComponents 
} from '~/lib/utils'
import T from '~/lib/text'
import rules from './MessageScheduleForm.rules'
import { TimePicker } from 'antd';
// import moment from 'moment';

export const emptyFormState = {
  title: '',
  body: '',
  parentId: '',
  // date: '',
  time: '',
  recurringType: 'once',
  initialTime: '',
}

function MessageScheduleForm({ show, handleClose, initialState }) {
  // const initialFormState = {
  //   ...emptyFormState,
  //   ...initialState,
  // }
  let date, time
  if (initialState) {
    date = formatDateForMaterialUIsStupidComponents(initialState.initialTime)
    time = formatTimeForMaterialUIsStupidComponents(initialState.time)
  }
  const stateToUse = {
    ...emptyFormState,
    ...initialState,
    date,
    time
  }
  const [formState, setFormState] = useState(stateToUse)
  const [submitClicked, setSubmitClicked] = useState(false)
  const [scheduleMessage, setScheduleMessage] = useState(false)
  const notificationState = useContext(NotificationContext)
  const { showErrors, setShowErrors, validation } = useValidator(
    formState,
    rules
  )

  const recurringTypeList = [{
    id: '0',
    type: 'Do not Repeat',
    value: 'once'
  },{
    id: '1',
    type: 'Daily',
    value: 'daily'
  },{
    id: '2',
    type: 'Weekly',
    value: 'weekly'
  },{
    id: '3',
    type: 'Monthly',
    value: 'monthly'
  }]

  const dateErrors = checkForScheduleDateErrors(formatDateTimeToISOString(formState.date, formState.time))

  /*                __       __  _
   *   __ _  __ __/ /____ _/ /_(_)__  ___
   *  /  ' \/ // / __/ _ `/ __/ / _ \/ _ \
   * /_/_/_/\_,_/\__/\_,_/\__/_/\___/_//_/
   *
   **/
  const [createMessage, { loading: msgloading, data: createMsgData, msgError }] = useMutation(
    CREATE_MESSAGE,
    {
      update(cache, { data: { createMessage } }) {
        // updates the cache when a resource is created
        updateCache('messages', createMessage, cache, MESSAGE_FRAGMENT)
      },
    }
  )
  
  const [createScheduledMessage, { loading, data: createData, error }] = useMutation(
    CREATE_SCHEDULED_MESSAGE,
    {
      update(cache, { data: { createScheduledMessage } }) {
        // updates the cache when a resource is created
        updateCache('scheduledMessages', createScheduledMessage, cache, SCHEDULED_MESSAGE_FRAGMENT)
      },
    }
  )

  /**
   *
   *  _                 _ _
   * | |_  __ _ _ _  __| | |___ _ _ ___
   * | ' \/ _` | ' \/ _` | / -_) '_(_-<
   * |_||_\__,_|_||_\__,_|_\___|_| /__/
   *
   */

  function handleAsyncChange(id, v) {
    setFormState({ ...formState, [id]: v })
  }

  function handleChange(e) {
    const id = e.target.id || e.target.name
    const value = e.target.value
    setFormState({ ...formState, [id]: value })
  }

  function handleTimeValues(time, timeValue){
    const id = 'time'
    // const value = moment(time)
    setFormState({ ...formState, [id]: timeValue })
    setSubmitClicked(false)
  }

  // dont know why this is necessary but without it validation wont appear
  validation.passes()

  function handleSubmit(e) {
    if(scheduleMessage){
      setSubmitClicked(true)
      e.preventDefault()
      if (validation.fails() || !!dateErrors || (!formState.time || formState.time == 'NaN:NaN')) {
        setShowErrors(true)
      } else {
        const data = formState
        const scheduledTime = formatDateTimeToISOString(formState.date, formState.time)
        const payload = {
          input: {
            title: data?.title,
            body: data?.body,
            parentId: parseInt(data?.parentId),
            // schedule: data?.date,
            schedule: scheduledTime,
            repeat: data?.recurringType != 'once' ? true : false,
            frequency: data?.recurringType != 'once' ? data?.recurringType : null,
          },
        }
        console.log('payload***********', payload);
        createScheduledMessage({ variables: trimStringsInObject(payload) })
      }
    } else {
      e.preventDefault()
      if (validation.fails()) {
        setShowErrors(true)
      } else {
        const data = formState
        const payload = {
          input: {
            title: data?.title,
            body: data?.body,
            parentId: parseInt(data?.parentId),
          },
        }
        createMessage({ variables: trimStringsInObject(payload) })
      }
    }
  }

  function close() {
    setScheduleMessage(false)
    setShowErrors(false)
    setFormState(emptyFormState)
    handleClose()
  }

  function getWarningText() {
    const warningType = formState.recurringType
    var days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
    var d = new Date(formState.date);
    var day = d.getDate();
    var weekDay = days[d.getDay()];
    let warningText = ''
    if( warningType == 'daily'){
      warningText = 'The notification will be sent daily.'
    } else if ( warningType == 'weekly'){
      warningText = `The notification will be sent every ${weekDay}.`
    } else {
      if([29, 30, 31].includes(day)){
        warningText = `The notification will be sent on the ${day} of every month or on the last day of the month.`
      } else {
        warningText = `The notification will be sent on the ${day} of every month.`
      }
    }
    return warningText
  }
  
  function showTimeValidationError() {
    if(submitClicked && (!formState.time || formState.time == 'NaN:NaN')){
      return true
    } else {
      return false
    }
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
    setFormState({
      ...formState,
      ...initialState,
    })
  }, [initialState])

  // listener to close dialog box
  useEffect(() => {
    if (createData && !loading) {
      notificationState.set({
        open: true,
        // message: T('MessageSent'),
        message: 'Message Scheduled',
      })
      close()
      setScheduleMessage(false)
    }
  }, [loading, createData])

  // listener to close dialog box
  useEffect(() => {
    if (createMsgData && !msgloading) {
      notificationState.set({
        open: true,
        message: T('MessageSent'),
      })
      close()
      setScheduleMessage(false)
    }
  }, [msgloading, createMsgData])

  useEffect(() => {
    if (error) {
      console.log(
        'ERROR',
        error,
        Object.keys(error),
        error?.networkError?.result,
        error?.graphQLErrors
      )
    }
  }, [error])

  useEffect(() => {
    if (msgError) {
      console.log(
        'ERROR',
        msgError,
        Object.keys(msgError),
        msgError?.networkError?.result,
        msgError?.graphQLErrors
      )
    }
  }, [msgError])
  
  function changeScheduleValue (e) {
    setScheduleMessage(e.target.checked)
  }

  const classes = useGenericFormStyles()
  return (
    <Dialog open={show} onClose={close} aria-labelledby="create-message-dialog">
      <form onSubmit={handleSubmit} autoComplete="off">
        <DialogContent>
          <div className={`create-message-form ${classes.root}`}>
            <Typography variant="h3">{T('MessageHeader')}</Typography>
            {!!error && (
              <Alert severity="error">
                {error.message ? error.message : JSON.stringify(error)}
              </Alert>
            )}
            <TextField
              id="title"
              className={classes.field}
              variant="outlined"
              label={T('Title')}
              required
              value={formState.title}
              onChange={handleChange}
              error={!!(showErrors && !!validation.errors.first('title'))}
              helperText={showErrors && validation.errors.first('title')}
              disabled={loading || msgloading}
            />
            <TextField
              id="body"
              className={classes.field}
              variant="outlined"
              label={T('Body')}
              required
              value={formState.body}
              onChange={handleChange}
              error={!!(showErrors && !!validation.errors.first('body'))}
              helperText={showErrors && validation.errors.first('body')}
              multiline={true}
              rows={3}
              disabled={loading || msgloading}
            />
            <AsyncSearchSelect
              id="agency_id"
              className={classes.field}
              required
              query={GET_FAMILIES}
              label={T('Family')}
              dataAccessor={(v) => v?.families?.items || []}
              labelAccessor={(v) => `${v.lastName}, ${v.firstName}` || ''}
              onSelect={(v) => handleAsyncChange('parentId', v?.id || '')}
              value={{ id: formState?.parentId || '' }}
              pageInfoAccessor={(v) => v?.families?.pageInfo}
              disabled={loading || msgloading}
            />
            <FormGroup>
              <FormControlLabel control={<Checkbox onChange={changeScheduleValue} disabled={loading || msgloading} />} label="Schedule" />
            </FormGroup>
            {scheduleMessage ?
            <>
            <Typography variant="h4">Schedule notification</Typography>
            <TextField
              className={classes.field}
              id="date"
              required
              variant="outlined"
              label={T('Date')}
              type="date"
              onChange={handleChange}
              value={formState.date}
              error={!!showErrors && dateErrors?.date}
              helperText={!!showErrors && dateErrors?.date}
              // inputProps={{ min: "2022-01-07" }}
              InputLabelProps={{
                shrink: true,
              }}
              disabled={loading || msgloading}
            />
            {/* <TextField
              className={classes.field}
              id="time"
              required
              variant="outlined"
              label="Time"
              type="time"
              onChange={handleChange}
              value={formState.time}
              error={!!showErrors && dateErrors?.time}
              helperText={!!showErrors && dateErrors?.time}
              // inputProps={{
              //   step: "1800", // 5 min
              //   // min: "16:00",
              //   // max: "18:00"
              // }}
              InputLabelProps={{
                shrink: true,
              }}
              disabled={loading}
            /> */}
            <div style={{zIndex: 99999}}>
              <TimePicker 
                className={classes.field} 
                id="timeValue"
                // defaultValue={moment('12:08', 'HH:mm')} 
                // value={formState.timeValue}
                onChange={(time, timeString) => handleTimeValues(time, timeString)}
                format='h:mm A' 
                use12Hours
                minuteStep={30}
                disabled={loading || msgloading}
                style={{
                  zIndex: 55555,
                  position: 'relative'
                }} 
                placeholder="Select time*"
                required
              />
              {showTimeValidationError() &&
              <p class="timeFieldError">
                Select time
              </p>
              }
              {!!showErrors && dateErrors?.time && !showTimeValidationError() &&
              <p class="timeFieldError">
                {dateErrors?.time}
              </p>}
            </div>
            <TextField
              className={classes.field}
              id="recurringType"
              // required
              variant="outlined"
              label="Recurring Type"
              name="recurringType"
              onChange={handleChange}
              value={formState.recurringType}
              select
              disabled={loading}
            >
              {recurringTypeList  && recurringTypeList.length &&  recurringTypeList.map((item)=>{
                return(
                <MenuItem key={item.id} value={item.value}>{item.type}</MenuItem>
                );
              }
              )}
            </TextField>
            {!dateErrors && formState.recurringType != 'once' && formState.date && formState.time &&
              <p class="scheduleWarningText">
                {getWarningText()}
              </p>}
            </> : <></> }
          </div>
        </DialogContent>
        <DialogActions>
          <Button onClick={close} color="primary" disabled={loading || msgloading}>
            {T('Cancel')}
          </Button>
          <Button
            type="submit"
            variant="contained"
            disabled={loading || msgloading}
            color="primary"
            endIcon={
              (loading || msgloading) && (
                <CircularProgress style={{ color: 'white' }} size={12} />
              )
            }
          >
            {T('Submit')}
          </Button>
        </DialogActions>
      </form>
    </Dialog>
  )
}

MessageScheduleForm.defaultProps = {
  initialState: {},
}

MessageScheduleForm.propTypes = {
  show: PropTypes.bool.isRequired,
  handleClose: PropTypes.func.isRequired,
}

export default MessageScheduleForm
