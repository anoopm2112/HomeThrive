import React, { useState } from 'react'
import Link from 'next/link'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import Visibility from '@material-ui/icons/Visibility'
import EventForm from '~/components/Forms/EventForm'
import Button from '@material-ui/core/Button'
import { GET_EVENTS } from '~/lib/queries/events'
import { useUser } from '~/lib/amplifyAuth'
import T from '~/lib/text'
const maxDescriptionLength = 15

function EventsTable() {
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
      accessor: (d) => d.description,
      render: (d) => {
        const descriptionWordsArray = d?.description.split(' ')
        const description =
          descriptionWordsArray.length > maxDescriptionLength
            ? descriptionWordsArray.slice(0, maxDescriptionLength).join(' ') +
              '...'
            : d?.description
        return description
      },
      label: T('Description'),
      hiddenOn: ['xs', 'sm'],
    },
    {
      id: 'invited',
      disablePadding: false,
      accessor: (d) => d.invitationsCount,
      render: (d) => d.invitationsCount,
      label: T('Invited'),
      hiddenOn: ['xs', 'sm', 'md'],
    },
    {
      id: 'rsvp',
      disablePadding: false,
      accessor: (d) => d.rsvpCount,
      render: (d) => d.rsvpCount,
      label: T('RSVPd'),
      hiddenOn: ['xs', 'sm', 'md'],
    },
    {
      id: 'date',
      disablePadding: false,
      accessor: (d) => new Date(d.startsAt),
      render: (d) => new Date(d.startsAt).toLocaleDateString() || '--',
      label: T('Date'),
    },
    {
      id: 'time',
      disablePadding: false,
      accessor: (d) => new Date(d.startsAt),
      render: (d) =>
        new Date(d.startsAt).toLocaleTimeString([], {
          hour: '2-digit',
          minute: '2-digit',
        }) || '--',
      label: T('Time'),
    },
    {
      id: 'action',
      render: function Action(d) {
        return (
          <Link href={`/events/${d.id}`}>
            <Visibility />
          </Link>
        )
      },
      label: '',
    },
  ]

  function Buttons() {
    return (
      <Button
        variant="contained"
        color="primary"
        onClick={() => setShowForm(true)}
      >
        {T('Create')}
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
      <EventForm show={showForm} handleClose={() => setShowForm(false)} />
      <GenericTable
        title={'families'}
        query={GET_EVENTS}
        variableBuilder={variableBuilder}
        cellLayout={cellLayout}
        dataAccessor={(d) => d?.events?.items || []}
        pageInfoAccessor={(d) => d?.events?.pageInfo}
        allowSelect={false}
        showToolbar={true}
        showPagination={true}
        buttons={Buttons}
      />
    </>
  )
}

export default EventsTable
