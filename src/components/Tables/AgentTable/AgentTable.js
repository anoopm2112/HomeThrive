import React, { useState } from 'react'
import Link from 'next/link'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import Visibility from '@material-ui/icons/Visibility'
import AgencyUserForm from '~/components/Forms/AgencyUserForm'
import Button from '@material-ui/core/Button'
import { GET_AGENTS } from '~/lib/queries/users'
import T from '~/lib/text'
import { useUser } from '~/lib/amplifyAuth'

function AgentTable() {
  const [showForm, setShowForm] = useState(false)
  const user = useUser()
  const role = user?.attributes
    ? parseInt(user?.attributes['custom:role'])
    : undefined

  const cellLayout = [
    {
      id: 'name',
      disablePadding: true,
      accessor: (d) => d.lastName,
      render: (d) =>
        d.firstName && d?.lastName ? `${d?.lastName}, ${d?.firstName} ` : '--',
      label: T('Name'),
    },
    {
      id: 'email',
      disablePadding: false,
      accessor: (d) => d?.email,
      render: (d) => d?.email,
      label: T('Email'),
    },
    {
      id: 'phone',
      disablePadding: false,
      accessor: (d) => d.phoneNumber,
      render: (d) => d.phoneNumber,
      label: T('Phone'),
      hiddenOn: ['xs', 'sm'],
    },
    {
      id: 'families',
      disablePadding: false,
      accessor: (d) => d?.familiesCount,
      render: (d) => d?.familiesCount,
      label: T('Families'),
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
      id: 'action',
      render: function Action(d) {
        return (
          <Link href={`/agents/${d.id}`}>
            <Visibility />
          </Link>
        )
      },
      label: '',
    },
  ]

  function Buttons() {
    if (role < 2)
      return (
        <Button
          variant="contained"
          color="primary"
          onClick={() => setShowForm(true)}
        >
          {T('Create')}
        </Button>
      )
    else return ''
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
      <AgencyUserForm show={showForm} handleClose={() => setShowForm(false)} />
      <GenericTable
        title={'agents'}
        query={GET_AGENTS}
        variableBuilder={variableBuilder}
        cellLayout={cellLayout}
        dataAccessor={(d) => d?.agents?.items || []}
        pageInfoAccessor={(d) => d?.agents?.pageInfo}
        allowSelect={false}
        showToolbar={true}
        showPagination={true}
        buttons={Buttons}
      />
    </>
  )
}

export default AgentTable
