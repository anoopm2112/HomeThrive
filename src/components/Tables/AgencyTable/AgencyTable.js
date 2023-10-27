import React, { useState } from 'react'
import Link from 'next/link'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import Visibility from '@material-ui/icons/Visibility'
import AgencyForm from '~/components/Forms/AgencyForm'
import Button from '@material-ui/core/Button'
import { GET_AGENCIES } from '~/lib/queries/agencies'
import { get } from '~/lib/utils'
import { useUser } from '~/lib/amplifyAuth'
import T from '~/lib/text'

function AgencyTable() {
  const [showForm, setShowForm] = useState(false)
  const user = useUser()
  const role = user?.attributes
    ? parseInt(user?.attributes['custom:role'])
    : undefined

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

  const cellLayout = [
    {
      id: 'name',
      disablePadding: true,
      accessor: (d) => d.name,
      render: (d) => d.name,
      label: T('Name'),
    },
    {
      id: 'location',
      disablePadding: false,
      accessor: (d) => d.city,
      render: (d) => d.city,
      label: T('Location'),
    },
    {
      id: 'email',
      disablePadding: false,
      accessor: (d) => get(d, ['poc', 'email']),
      render: (d) => get(d, ['poc', 'email'], '--'),
      label: T('Email'),
    },
    {
      id: 'agents',
      disablePadding: false,
      accessor: (d) => d?.agentsCount,
      render: (d) => d?.agentsCount,
      label: T('Agents'),
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
      accessor: (d) => d?.childrenCount,
      render: (d) => d?.childrenCount,
      label: T('Children'),
      hiddenOn: ['xs', 'sm'],
    },
    {
      id: 'action',
      render: function Action(d) {
        return (
          <Link href={`/agencies/${d.id}`}>
            <Visibility />
          </Link>
        )
      },
      label: '',
    },
  ]

  return (
    <>
      <AgencyForm show={showForm} handleClose={() => setShowForm(false)} />
      <GenericTable
        title={'agency'}
        query={GET_AGENCIES}
        variableBuilder={variableBuilder}
        cellLayout={cellLayout}
        dataAccessor={(d) => d?.agencies?.items || []}
        pageInfoAccessor={(d) => d?.agencies?.pageInfo}
        allowSelect={false}
        showToolbar={true}
        showPagination={true}
        buttons={Buttons}
      />
    </>
  )
}

export default AgencyTable
