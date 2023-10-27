import React, { useState } from 'react'
import Link from 'next/link'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import Visibility from '@material-ui/icons/Visibility'
import EventParticipantsForm from '~/components/Forms/EventForm/EventParticipantsForm'
import Button from '@material-ui/core/Button'
import { GET_EVENT_PARTICIPANTS } from '~/lib/queries/events'
import T from '~/lib/text'

function EventParticipantsTable({ eventId }) {
  const [needsRefetch, setNeedsRefetch] = useState(false)
  const [showAddParticipants, setShowAddParticipants] = useState(false)
  const [participantsResponse, setParticipantsResponse] = useState([])

  const cellLayout = [
    {
      id: 'name',
      disablePadding: true,
      accessor: (d) => d.name,
      render: (d) => d.name,
      label: T('Name'),
    },
    {
      id: 'email',
      disablePadding: false,
      accessor: (d) => d.email,
      render: (d) => d.email,
      label: T('Email'),
      hiddenOn: ['xs', 'sm'],
    },
    {
      id: 'location',
      disablePadding: false,
      accessor: (d) => d.location,
      render: (d) => d.location,
      label: T('Location'),
      hiddenOn: ['xs', 'sm', 'md'],
    },
    {
      id: 'children',
      disablePadding: false,
      accessor: (d) => d.childrenCount,
      render: (d) => d.childrenCount,
      label: T('Children'),
      hiddenOn: ['xs', 'sm', 'md'],
    },
    {
      id: 'status',
      disablePadding: false,
      accessor: (d) => d.status,
      render: (d) => d.status,
      label: T('InviteStatus'),
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

  function Buttons() {
    return (
      <Button
        variant="contained"
        color="secondary"
        onClick={() => setShowAddParticipants(true)}
      >
        {T('AddParticipants')}
      </Button>
    )
  }

  const participants = participantsResponse?.eventParticipants?.items || []

  function variableBuilder({ router, searchTerm, rowsPerPage, cursor }) {
    return {
      input: {
        eventId,
        search: searchTerm,
        pagination: {
          cursor: cursor,
          limit: 1000,
          // NOTE: This is set to a static HIGH number so that all the attending participants
          // will be marked in the "Add Participants" Dialog. Otherwise, only the _loaded_ participants
          // would be marked as attending.
        },
      },
    }
  }

  return (
    <>
      <EventParticipantsForm
        eventId={eventId}
        show={showAddParticipants}
        handleClose={() => setShowAddParticipants(false)}
        initialState={participants}
        onComplete={() => setNeedsRefetch(true)}
      />
      <GenericTable
        title={'event-participants'}
        query={GET_EVENT_PARTICIPANTS}
        variableBuilder={variableBuilder}
        cellLayout={cellLayout}
        dataAccessor={(d) => d?.eventParticipants?.items || []}
        pageInfoAccessor={(d) => d?.eventParticipants?.pageInfo}
        allowSelect={false}
        showToolbar={true}
        showPagination={true}
        buttons={Buttons}
        skip={!eventId}
        onFetchComplete={(d) => setParticipantsResponse(d)}
        refetch={needsRefetch}
        onRefetchComplete={() => setNeedsRefetch(false)}
      />
    </>
  )
}

export default EventParticipantsTable
