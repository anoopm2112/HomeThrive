import React, { useState, useEffect, useContext } from 'react'
import { useMutation } from '@apollo/client'
import { CREATE_MESSAGE, MESSAGE_FRAGMENT } from '~/lib/queries/messages'
import { GET_FAMILIES } from '~/lib/queries/families'
import { NotificationContext } from '~/components/Contexts/NotificationContext'
import { useValidator } from '~/lib/validators'
import Typography from '@material-ui/core/Typography'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button'
import Alert from '@material-ui/lab/Alert'
import Dialog from '@material-ui/core/Dialog'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import CircularProgress from '@material-ui/core/CircularProgress'
import AsyncSearchSelect from '~/components/CustomFields/AsyncSearchSelect'
import PropTypes from 'prop-types'
import { useGenericFormStyles } from '~/components/Forms/Form.styles'
import { updateCache, trimStringsInObject } from '~/lib/utils'
import T from '~/lib/text'
import rules from './MessageForm.rules'

export const emptyFormState = {
  title: '',
  body: '',
  parentId: '',
}

function MessageForm({ show, handleClose, initialState }) {
  const initialFormState = {
    ...emptyFormState,
    ...initialState,
  }
  const [formState, setFormState] = useState(initialFormState)
  const notificationState = useContext(NotificationContext)
  const { showErrors, setShowErrors, validation } = useValidator(
    formState,
    rules
  )

  /*                __       __  _
   *   __ _  __ __/ /____ _/ /_(_)__  ___
   *  /  ' \/ // / __/ _ `/ __/ / _ \/ _ \
   * /_/_/_/\_,_/\__/\_,_/\__/_/\___/_//_/
   *
   **/
  const [createMessage, { loading, data: createData, error }] = useMutation(
    CREATE_MESSAGE,
    {
      update(cache, { data: { createMessage } }) {
        // updates the cache when a resource is created
        updateCache('messages', createMessage, cache, MESSAGE_FRAGMENT)
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

  // dont know why this is necessary but without it validation wont appear
  validation.passes()

  function handleSubmit(e) {
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

  function close() {
    setShowErrors(false)
    setFormState(initialFormState)
    handleClose()
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
        message: T('MessageSent'),
      })
      close()
    }
  }, [loading, createData])

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
              disabled={loading}
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
              disabled={loading}
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
              disabled={loading}
            />
          </div>
        </DialogContent>
        <DialogActions>
          <Button onClick={close} color="primary" disabled={loading}>
            {T('Cancel')}
          </Button>
          <Button
            type="submit"
            variant="contained"
            disabled={loading}
            color="primary"
            endIcon={
              loading && (
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

MessageForm.defaultProps = {
  initialState: {},
}

MessageForm.propTypes = {
  show: PropTypes.bool.isRequired,
  handleClose: PropTypes.func.isRequired,
}

export default MessageForm
