import React, { useState } from 'react'
import { useMutation } from '@apollo/client'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import Typography from '@material-ui/core/Typography'
import { Dialog } from '@material-ui/core'
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import MessageScheduleForm from '~/components/Forms/MessageScheduleForm'
import Button from '@material-ui/core/Button'
import { GET_SCHEDULED_MESSAGES, DISABLE_SCHEDULED_MESSAGE, SCHEDULED_MESSAGE_FRAGMENT } from '~/lib/queries/messages'
import { useUser } from '~/lib/amplifyAuth'
import { updateCache, trimStringsInObject } from '~/lib/utils'
import T from '~/lib/text'

function ScheduledMessagesTable() {
  const [showForm, setShowForm] = useState(false)
  const [isDisableOpen, setIsDisableOpen] = useState(false);
  const [selectedNotification, setSelectedNotification] = useState(null);
  const user = useUser()
  const role = user?.attributes
    ? parseInt(user?.attributes['custom:role'])
    : undefined

  const [disableScheduledMessage, { loading, data: updatedData, error }] = useMutation(
    DISABLE_SCHEDULED_MESSAGE,
    {
      update(cache, { data: { disableScheduledMessage } }) {
        // updates the cache when a resource is created
        const result = cache.writeFragment({
          id: `ScheduledMessage:${selectedNotification.id}`,
          fragment: SCHEDULED_MESSAGE_FRAGMENT,
          data: disableScheduledMessage,
        })
  
        return result
      },
    }
  )

  const cellLayout = [
    {
      id: 'title',
      disablePadding: true,
      accessor: (d) => d.title,
      render: (d) => d.title,
      label: T('Title'),
    },
    {
      id: 'description',
      disablePadding: false,
      accessor: (d) => d.body,
      render: (d) => d.body,
      label: T('Body'),
      hiddenOn: ['xs', 'sm'],
    },
    {
      id: 'recipient',
      disablePadding: false,
      accessor: (d) => d.recipientName,
      render: (d) => d.recipientName,
      label: T('Recipient'),
      hiddenOn: ['xs', 'sm'],
    },
    {
      id: 'createdAt',
      disablePadding: false,
      accessor: (d) => new Date(d.schedule),
      render: (d) => new Date(d.schedule).toLocaleDateString(),
      label: 'Scheduled At',
    },
    {
      id: 'time',
      disablePadding: false,
      accessor: (d) => new Date(d.schedule),
      render: (d) =>
        new Date(d.schedule).toLocaleTimeString([], {
          hour: '2-digit',
          minute: '2-digit',
        }) || '--',
      label: T('Time'),
    },
    // {
    //   id: 'status',
    //   disablePadding: false,
    //   accessor: (d) => d.isActive,
    //   render: (d) => d.isActive ? 'Active' : 'InActive',
    //   label: T('Status'),
    //   hiddenOn: ['xs', 'sm', 'md'],
    // },
    {
      id: 'frequency',
      disablePadding: false,
      accessor: (d) => d.frequency,
      render: (d) => d.frequency || '-',
      label: 'Frequency',
    },
    {
      id: 'disable',
      disablePadding: false,
      accessor: (d) => d.status,
      render: (d) => d.status != 'active' ? <>{d.status.charAt(0).toUpperCase() + d.status.slice(1)}</> : 
      <Button
        variant="contained"
        color="primary"
        // onClick={() => disableMessage(d.id)}
        onClick={() => handleDisableMessage(d)}
      >
        Disable
      </Button>,
      label: '',
    }
  ]

  function disableMessage() {
    const payload = {
      input: {
        id: selectedNotification.id
      },
    }
    disableScheduledMessage({ variables: trimStringsInObject(payload) })
    setIsDisableOpen(false)
  }

  function handleDisableMessage(value) {
    setSelectedNotification(value)
    setIsDisableOpen(true)
  }

  function Buttons() {
    return (
      <Button
        variant="contained"
        color="primary"
        onClick={() => setShowForm(true)}
      >
        Create
      </Button>
    )
  }

  function variableBuilder({ router, searchTerm, rowsPerPage, cursor }) {
    return {
      input: {
        search: searchTerm,
        pagination: {
          cursor: cursor,
          limit: rowsPerPage,
        },
      },
    }
  }

  return (
    <>
      <MessageScheduleForm show={showForm} handleClose={() => setShowForm(false)} />
      <GenericTable
          title={'scheduledMessages'}
          query={GET_SCHEDULED_MESSAGES}
          variableBuilder={variableBuilder}
          cellLayout={cellLayout}
          dataAccessor={(d) => d?.scheduledMessages?.items || []}
          pageInfoAccessor={(d) => d?.scheduledMessages?.pageInfo}
          allowSelect={false}
          showToolbar={true}
          showPagination={true}
          buttons={Buttons}
          paperHeader={
            <>
              <Typography variant="h3">Scheduled Messages</Typography>
              <div className="subheading">This is a list of scheduled messages.</div>
            </>
          }
      />
      <Dialog aria-labelledby="simple-dialog-title" open={isDisableOpen}>
        <DialogTitle id="simple-dialog-title">Disable Notification</DialogTitle>
        <DialogContent>
          <DialogContentText id="alert-dialog-description">
          Are you sure you want to disable the notification {selectedNotification?.title}?<br></br>
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button onClick={()=>disableMessage()} color="primary">
            Yes
          </Button>
          <Button onClick={()=>setIsDisableOpen(false)} color="primary"autoFocus>
            No
          </Button>
        </DialogActions>
      </Dialog>
    </>
  )
}

export default ScheduledMessagesTable
