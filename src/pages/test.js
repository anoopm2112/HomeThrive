import React, { useState } from 'react'
import Link from 'next/link'
import AuthedLayout from '~/components/Layout/AuthedLayout'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import Visibility from '@material-ui/icons/Visibility'
import ChildForm from '~/components/Forms/ChildForm'
import Button from '@material-ui/core/Button'
import { GET_CHILDREN } from '~/lib/queries/children'
import { get } from '~/lib/utils'

const cellLayout = [
  {
    id: 'name',
    disablePadding: true,
    accessor: (d) => d.lastName,
    render: (d) => `${d?.lastName}, ${d?.firstName}`,
    label: 'Name',
  },
  {
    id: 'dateOfBirth',
    disablePadding: false,
    accessor: (d) => new Date(d.dateOfBirth),
    render: (d) => new Date(d?.dateOfBirth).toLocaleDateString(),
    label: 'Date of Birth',
  },
  {
    id: 'family',
    disablePadding: false,
    accessor: (d) => get(d, ['parent', 'lastName']),
    render: (d) => {
      const p1 = get(d, ['parent'])
      const p2 = get(d, ['parent', 'secondaryParents', 0])
      const family = p1
        ? `${p1.firstName} ${p2 ? `& ${p2.firstName} ` : ''}${p1.lastName}`
        : '--'
      return family
    },
    label: 'Family',
  },
  {
    id: 'agent',
    disablePadding: false,
    accessor: (d) => d?.agentName,
    render: (d) => d?.agentName,
    label: 'Case Manager',
  },
  {
    id: 'logsCount',
    disablePadding: false,
    accessor: (d) => d?.logsCount,
    render: (d) => d?.logsCount,
    label: 'Logs',
    hiddenOn: ['xs', 'sm', 'md'],
  },
  {
    id: 'action',
    render: function Action(d) {
      return (
        <Link href={`/children/${d.id}`}>
          <Visibility />
        </Link>
      )
    },
    label: '',
  },
]

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

function TestPage() {
  const [showForm, setShowForm] = useState(false)

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

  return (
    <AuthedLayout>
      <ChildForm show={showForm} handleClose={() => setShowForm(false)} />
      <GenericTable
        title={'families'}
        query={GET_CHILDREN}
        variableBuilder={variableBuilder}
        cellLayout={cellLayout}
        dataAccessor={(d) => d?.children?.items || []}
        pageInfoAccessor={(d) => d?.children?.pageInfo}
        allowSelect={false}
        // defaultSortBy={'email1'}
        showToolbar={true}
        showPagination={true}
        buttons={Buttons}
      />
    </AuthedLayout>
  )
}

export default TestPage
