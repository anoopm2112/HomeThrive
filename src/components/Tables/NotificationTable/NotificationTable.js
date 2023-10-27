import React, { useState } from 'react'
import Link from 'next/link'
import Button from '@material-ui/core/Button'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import Visibility from '@material-ui/icons/Visibility'
import {
  GET_NOTIFICATIONS,
  MARK_NOTIFICATION_AS_READ,
} from '~/lib/queries/notifications'
import { useMutation } from '@apollo/client'
import T from '~/lib/text'
import CircularProgress from '@material-ui/core/CircularProgress'

function NotificationsTable() {
  const [loadingId, setLoadingId] = useState()
  const [markRead, { loading, data, error }] = useMutation(
    MARK_NOTIFICATION_AS_READ
  )

  const cellLayout = [
    {
      id: 'parentName',
      disablePadding: true,
      accessor: (d) => d.parentName,
      render: (d) => d.parentName,
      label: T('ParentName'),
    },
    {
      id: 'body',
      disablePadding: false,
      accessor: (d) => d.body,
      render: (d) => d.body,
      label: T('Body'),
      hiddenOn: ['xs', 'sm'],
    },
    {
      id: 'family',
      disablePadding: false,
      accessor: (d) => d.parentName,
      render: (d) => d.parentName,
      label: T('Family'),
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
      id: 'read',
      disablePadding: false,
      accessor: (d) => d.read,
      render: function Read(d) {
        return d.read ? (
          <span>&#10003;</span>
        ) : (
          loading && loadingId === d.id && <CircularProgress size={12} />
        )
      },
      label: T('Read'),
    },
    {
      id: 'action',
      disablePadding: false,
      accessor: (d) => d.read,
      render: function Action(d) {
        return !d.read ? (
          <>
            <Button
              color="primary"
              variant="contained"
              size="small"
              onClick={() => handleMarkRead(d)}
            >
              &#10003;
            </Button>
          </>
        ) : (
          ''
        )
      },
      label: '',
    },
    {
      id: 'action',
      render: function Action(d) {
        return (
          <Link href={`/families/${d.parentId}`}>
            <Visibility />
          </Link>
        )
      },
      label: '',
    },
  ]

  function handleMarkRead(d) {
    setLoadingId(d.id)
    markRead({
      variables: {
        input: {
          id: d.id,
        },
      },
    })
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
      <GenericTable
        title={'notifications'}
        query={GET_NOTIFICATIONS}
        variableBuilder={variableBuilder}
        cellLayout={cellLayout}
        dataAccessor={(d) => d?.notifications?.items || []}
        pageInfoAccessor={(d) => d?.notifications?.pageInfo}
        allowSelect={false}
        showToolbar={true}
        showPagination={true}
      />
    </>
  )
}

export default NotificationsTable
