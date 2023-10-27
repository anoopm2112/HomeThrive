import React, { useState } from 'react'
import Link from 'next/link'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import Visibility from '@material-ui/icons/Visibility'
import ChildForm from '~/components/Forms/ChildForm'
import Button from '@material-ui/core/Button'
import { GET_CHILDREN } from '~/lib/queries/children'
import { get } from '~/lib/utils'
import { useUser } from '~/lib/amplifyAuth'
import T from '~/lib/text'

function ChildTable() {
  const [showForm, setShowForm] = useState(false)
  const [isAgencySelected, setIsAgencySelected] = useState(false)
  const [selectedAgency, setselectedAgency] = useState(false)
  const user = useUser()
  const role = user?.attributes
    ? parseInt(user?.attributes['custom:role'])
    : undefined

  function Buttons() {
    if (role == 1 || role == 2 || (role == 0 && isAgencySelected))
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

  function variableBuilder({ router, searchTerm, rowsPerPage, cursor, agencyId }) {
    return {
      input: {
        search: searchTerm,
        agencyId: agencyId,
        pagination: {
          cursor: cursor,
          limit: rowsPerPage,
        },
      },
    }
  }
  
  const setAgencyValue = (value) => {
    setselectedAgency(value)
    if(value){
      setIsAgencySelected(true)
    } else {
      setIsAgencySelected(false)
    }
  }

  const cellLayout = [
    {
      id: 'name',
      disablePadding: true,
      accessor: (d) => d.lastName,
      render: (d) => `${d?.lastName}, ${d?.firstName} `,
      label: T('Name'),
    },
    {
      id: 'dateOfBirth',
      disablePadding: false,
      accessor: (d) => new Date(d.dateOfBirth),
      render: (d) => new Date(d?.dateOfBirth).toLocaleDateString(),
      label: T('BirthDate'),
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
      label: T('Family'),
    },
    {
      id: 'agent',
      disablePadding: false,
      accessor: (d) => d?.agentName,
      render: (d) => d?.agentName,
      label: T('Agent'),
    },
    {
      id: 'logsCount',
      disablePadding: false,
      accessor: (d) => d?.logsCount,
      render: (d) => d?.logsCount,
      label: T('LogsCount'),
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

  return (
    <>
      <ChildForm show={showForm} handleClose={() => setShowForm(false)} agencyId={selectedAgency} />
      <GenericTable
        title={'children'}
        query={GET_CHILDREN}
        variableBuilder={variableBuilder}
        cellLayout={cellLayout}
        dataAccessor={(d) => d?.children?.items || []}
        pageInfoAccessor={(d) => d?.children?.pageInfo}
        allowSelect={false}
        showToolbar={true}
        showPagination={true}
        buttons={Buttons}
        showFilter={role == 0 ? true : false}
        setAgencyValue={setAgencyValue}
      />
    </>
  )
}

export default ChildTable
