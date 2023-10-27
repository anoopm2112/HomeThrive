import React, { useState } from 'react'
import Link from 'next/link'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import Visibility from '@material-ui/icons/Visibility'
import LocalResourceForm from '~/components/Forms/LocalResourceForm'
import Button from '@material-ui/core/Button'
import { GET_LOCAL_RESOURCES } from '~/lib/queries/localResources'
import { useUser } from '~/lib/amplifyAuth'
import T from '~/lib/text'

function LocalResourcesTable({ agentId }) {
  const [showForm, setShowForm] = useState(false)
  const user = useUser()
  const role = user?.attributes
    ? parseInt(user?.attributes['custom:role'])
    : undefined

  const cellLayout = [
    {
      id: 'support service name',
      disablePadding: true,
      accessor: (d) => d.name,
      render: (d) => d.name,
      label: 'Support Service Name',
    },
    {
      id: 'phone',
      disablePadding: false,
      accessor: (d) => d.phoneNumber,
      render: (d) => d.phoneNumber,
      label: T('Phone'),
    },
    {
      id: 'email',
      disablePadding: false,
      accessor: (d) => d.email,
      render: (d) => d.email,
      label: T('Email'),
    },
    {
      id: 'website',
      disablePadding: false,
      accessor: (d) => d.website,
      render: (d) => d.website,
      label: 'Website',
    },
    {
      id: 'action',
      render: function Action(d) {
        return (
          <Link href={`/localresources/${d.id}`}>
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
          Create
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
      <LocalResourceForm show={showForm} role={role} handleClose={() => setShowForm(false)} />
      <GenericTable
        title={'supportServices'}
        query={GET_LOCAL_RESOURCES}
        variableBuilder={variableBuilder}
        cellLayout={cellLayout}
        dataAccessor={(d) => d?.supportServices?.items || []}
        pageInfoAccessor={(d) => d?.supportServices?.pageInfo}
        allowSelect={false}
        showToolbar={true}
        showPagination={true}
        buttons={Buttons}
      />
    </>
  )
}

export default LocalResourcesTable
