import React, { useState } from 'react'
import Link from 'next/link'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import Visibility from '@material-ui/icons/Visibility'
import ResourceForm from '~/components/Forms/ResourceForm'
import Button from '@material-ui/core/Button'
import Chip from '@material-ui/core/Chip'
import { GET_RESOURCES } from '~/lib/queries/resources'
import { useUser } from '~/lib/amplifyAuth'
import T from '~/lib/text'

function ResourcesTable({ agentId }) {
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
      id: 'categories',
      disablePadding: false,
      accessor: (d) => d.categories.length,
      render: (d) =>
        (d?.categories || []).map((e, i) => (
          <Chip key={`${e.id}.${i}`} size="small" label={e.name} />
        )),
      label: T('Categories'),
    },
    {
      id: 'createdAt',
      disablePadding: false,
      accessor: (d) => new Date(d.createdAt),
      render: (d) => new Date(d.createdAt).toLocaleDateString(),
      hiddenOn: ['xs', 'sm', 'md'],
      label: T('CreatedAt'),
    },
    {
      id: 'author',
      disablePadding: false,
      accessor: (d) => d.author?.lastName,
      render: (d) => `${d.author?.firstName} ${d.author?.lastName}`,
      label: T('CreatedBy'),
      hiddenOn: ['xs', 'sm', 'md'],
    },
    {
      id: 'published',
      disablePadding: false,
      accessor: (d) => d.published,
      render: (d) => (d.published ? 'published' : 'draft'),
      label: T('Published'),
      hiddenOn: ['xs', 'sm'],
    },
    {
      id: 'updatedAt',
      disablePadding: false,
      accessor: (d) => new Date(d.updatedAt),
      render: (d) => new Date(d.updatedAt).toLocaleDateString(),
      label: T('UpdatedAt'),
      hiddenOn: ['xs', 'sm'],
    },
    {
      id: 'action',
      render: function Action(d) {
        return (
          <Link href={`/resources/${d.id}`}>
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
        agentId: agentId ? parseInt(agentId) : undefined,
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
      <ResourceForm show={showForm} handleClose={() => setShowForm(false)} />
      <GenericTable
        title={'resources'}
        query={GET_RESOURCES}
        variableBuilder={variableBuilder}
        cellLayout={cellLayout}
        dataAccessor={(d) => d?.resources?.items || []}
        pageInfoAccessor={(d) => d?.resources?.pageInfo}
        allowSelect={false}
        showToolbar={true}
        showPagination={true}
        buttons={Buttons}
      />
    </>
  )
}

export default ResourcesTable
