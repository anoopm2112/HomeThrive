import React, { useState } from 'react'
import Link from 'next/link'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import Typography from '@material-ui/core/Typography'
import MessageForm from '~/components/Forms/MessageForm'
import Button from '@material-ui/core/Button'
import { GET_MESSAGES } from '~/lib/queries/messages'
import { useUser } from '~/lib/amplifyAuth'
import T from '~/lib/text'

function MessagesTable() {
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
      accessor: (d) => new Date(d.createdAt),
      render: (d) => new Date(d.createdAt).toLocaleDateString(),
      label: T('SentAt'),
    },
    {
      id: 'status',
      disablePadding: false,
      accessor: (d) => d.status,
      render: (d) => d.status,
      label: T('Status'),
      hiddenOn: ['xs', 'sm', 'md'],
    },
  ]

  function Buttons() {
    return (
      <Button
        variant="contained"
        color="primary"
        onClick={() => setShowForm(true)}
      >
        {T('CreateMessage')}
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
      <MessageForm show={showForm} handleClose={() => setShowForm(false)} />
      <GenericTable
        title={'messages'}
        query={GET_MESSAGES}
        variableBuilder={variableBuilder}
        cellLayout={cellLayout}
        dataAccessor={(d) => d?.messages?.items || []}
        pageInfoAccessor={(d) => d?.messages?.pageInfo}
        allowSelect={false}
        showToolbar={true}
        showPagination={true}
        // buttons={Buttons}
        paperHeader={
          <>
            {/* <Typography variant="h3">{T('LogTableHeader')}</Typography>
            <div className="subheading">{T('LogTableSubHeader')}</div> */}
            <Typography variant="h3">Sent Messages</Typography>
            <div className="subheading">This is a list of sent messages.</div>
          </>
        }
      />
    </>
  )
}

export default MessagesTable
