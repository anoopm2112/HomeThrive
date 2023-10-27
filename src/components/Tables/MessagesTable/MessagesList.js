import React, { useState } from 'react'
import Link from 'next/link'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import MessageForm from '~/components/Forms/MessageForm'
import Button from '@material-ui/core/Button'
import Typography from '@material-ui/core/Typography'
import { GET_MESSAGES } from '~/lib/queries/messages'
import { useUser } from '~/lib/amplifyAuth'
import { PlaceholderMessages } from '~/components/Tables/Placeholders'
import T from '~/lib/text'

function MessagesList({ familyId }) {
  const [showForm, setShowForm] = useState(false)
  const user = useUser()
  const role = user?.attributes
    ? parseInt(user?.attributes['custom:role'])
    : undefined

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
      id: 'sender',
      disablePadding: false,
      accessor: (d) => d.senderName,
      render: (d) => d.senderName,
      label: T('SentBy'),
      hiddenOn: ['xs', 'sm'],
    },
    {
      id: 'createdAt',
      disablePadding: false,
      accessor: (d) => new Date(d.createdAt),
      render: (d) => new Date(d.createdAt).toLocaleDateString(),
      label: T('SentAt'),
    },
  ]

  function variableBuilder({ router, searchTerm, rowsPerPage, cursor }) {
    return {
      input: {
        parentId: familyId,
        pagination: {
          limit: 5,
        },
      },
    }
  }

  function Footer() {
    return (
      <Link href="/messages">
        <Button color="primary">{T('SeeAllNotifications')}</Button>
      </Link>
    )
  }

  return (
    <>
      <MessageForm show={showForm} handleClose={() => setShowForm(false)} />
      <GenericTable
        title={'messsages'}
        query={GET_MESSAGES}
        variableBuilder={variableBuilder}
        cellLayout={cellLayout}
        dataAccessor={(d) => d?.messages?.items || []}
        pageInfoAccessor={(d) => d?.messages?.pageInfo}
        allowSelect={false}
        showToolbar={false}
        showPagination={false}
        defaultRowsPerPage={4}
        footer={Footer}
        paperHeader={
          <>
            <Typography variant="h3">{T('MessageListHeader')}</Typography>
            <div className="subheading">{T('MessageListSubheader')}</div>
          </>
        }
        placeholderZeroTableRows={<PlaceholderMessages />}
      />
    </>
  )
}

export default MessagesList
