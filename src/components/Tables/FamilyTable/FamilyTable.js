import React, { useState } from 'react'
import Link from 'next/link'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import Visibility from '@material-ui/icons/Visibility'
import FamilyForm from '~/components/Forms/FamilyForm'
import Button from '@material-ui/core/Button'
import { GET_FAMILIES } from '~/lib/queries/families'
import { get } from '~/lib/utils'
import { useUser } from '~/lib/amplifyAuth'
import T from '~/lib/text'

function FamilyTable({ agentId }) {
  const [showForm, setShowForm] = useState(false)
  const [isAgencySelected, setIsAgencySelected] = useState(false)
  const [selectedAgency, setselectedAgency] = useState(false)
  const user = useUser()
  const role = user?.attributes
    ? parseInt(user?.attributes['custom:role'])
    : undefined

  const cellLayout = [
    {
      id: 'parent1',
      disablePadding: true,
      accessor: (d) => d.lastName,
      render: (d) => `${d?.lastName}, ${d?.firstName} `,
      label: T('Parent1'),
    },
    {
      id: 'parent2',
      disablePadding: false,
      accessor: (d) => get(d, ['secondaryParents', 0, 'lastName'], '--'),
      render: (d) => {
        const p2 = get(d, ['secondaryParents', 0], {})
        return p2.firstName ? `${p2.firstName} ${p2.lastName}` : '--'
      },
      label: T('Parent2'),
    },
    {
      id: 'email1',
      disablePadding: false,
      accessor: (d) => d.email,
      render: (d) => d.email,
      label: T('PrimaryEmail'),
    },
    {
      id: 'location',
      disablePadding: false,
      accessor: (d) => d.city,
      render: (d) => d.city,
      label: T('Location'),
      hiddenOn: ['xs', 'sm', 'md'],
    },
    {
      id: 'children',
      disablePadding: false,
      accessor: (d) => d.childrenCount,
      render: (d) => d.childrenCount,
      label: T('NumChildren'),
      hiddenOn: ['xs', 'sm', 'md'],
    },
    {
      id: 'action',
      render: function Action(d) {
        return (
          <Link href={`/families/${d.id}`}>
            <Visibility />
          </Link>
        )
      },
      label: '',
    },
  ]

  function Buttons() {
    if (role == 1 || role == 2 || (role == 0 && isAgencySelected))
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

  function variableBuilder({ router, searchTerm, rowsPerPage, cursor, agencyId }) {
    return {
      input: {
        agentId: agentId ? parseInt(agentId) : undefined,
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

  return (
    <>
      <FamilyForm show={showForm} handleClose={() => setShowForm(false)} agencyId={selectedAgency} />
      <GenericTable
        title={'families'}
        query={GET_FAMILIES}
        variableBuilder={variableBuilder}
        cellLayout={cellLayout}
        dataAccessor={(d) => d?.families?.items || []}
        pageInfoAccessor={(d) => d?.families?.pageInfo}
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

export default FamilyTable
