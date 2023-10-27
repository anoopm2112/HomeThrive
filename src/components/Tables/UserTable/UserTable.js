import React, { useState } from 'react'
import { useMutation } from '@apollo/client'
import GenericTable from '~/components/Tables/Generic/GenericTable'
import EditIcon from '@material-ui/icons/Edit'
import UserForm, { emptyFormState } from '~/components/Forms/UserForm/UserForm'
import Button from '@material-ui/core/Button'
import Switch from '@material-ui/core/Switch'
import CircularProgress from '@material-ui/core/CircularProgress'
import FormControlLabel from '@material-ui/core/FormControlLabel'
import {
  GET_USERS,
  ENABLE_USER,
  ENABLE_USER_VARIABLES,
} from '~/lib/queries/users'
import { useUser } from '~/lib/amplifyAuth'
import { RolesDictionary } from '~/lib/assets/copy'
import { snakeCaseToProperCase } from '~/lib/utils'
import T from '~/lib/text'

function UserTable() {
  const [showForm, setShowForm] = useState(false)
  const [editData, setEditData] = useState()
  const user = useUser()
  const role = user?.attributes
    ? parseInt(user?.attributes['custom:role'])
    : undefined

  function Buttons() {
    if (role < 1)
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

  const cellLayout = [
    {
      id: 'name',
      disablePadding: true,
      accessor: (d) => d.lastName,
      render: (d) => `${d?.lastName} ${d?.firstName}`,
      label: T('Name'),
    },
    {
      id: 'email',
      disablePadding: false,
      accessor: (d) => d.email,
      render: (d) => d.email,
      label: T('Email'),
    },
    {
      id: 'phone',
      disablePadding: false,
      accessor: (d) => d.phoneNumber,
      render: (d) => d.phoneNumber,
      label: T('Phone'),
    },
    {
      id: 'userType',
      disablePadding: false,
      accessor: (d) => d?.role,
      render: (d) => RolesDictionary[d?.role],
      label: T('UserType'),
    },
    {
      id: 'agency',
      disablePadding: false,
      accessor: (d) => d?.agencyName,
      render: (d) => d?.agencyName || '--',
      label: T('Agency'),
      hiddenOn: ['xs', 'sm', 'md'],
    },
    {
      id: 'enableDisable',
      render: function EnableDisableUser(d) {
        return <EnableDisable data={d} />
      },
      label: T('Enabled'),
    },
    {
      id: 'edit',
      render: function EditButton(d) {
        return (
          <Edit
            onClick={() => {
              const initialState = { ...d, role: snakeCaseToProperCase(d.role) }
              setEditData(initialState)
              setShowForm(true)
            }}
          />
        )
      },
      label: '',
    },
  ]

  function handleClose() {
    setShowForm(false)
    setEditData()
  }

  return (
    <>
      <UserForm
        show={showForm}
        handleClose={handleClose}
        initialState={editData}
      />
      <GenericTable
        title={'users'}
        query={GET_USERS}
        variableBuilder={variableBuilder}
        cellLayout={cellLayout}
        dataAccessor={(d) => d?.users?.items || []}
        pageInfoAccessor={(d) => d?.users?.pageInfo}
        allowSelect={false}
        showToolbar={true}
        showPagination={true}
        buttons={Buttons}
      />
    </>
  )
}

/**
 * Component to render the switch that will allow the admin to
 * @param {*} param0
 * @returns
 */
function EnableDisable({ data: d }) {
  const [enableDisableUser, { loading }] = useMutation(ENABLE_USER)

  return (
    <>
      <FormControlLabel
        label=""
        disabled={loading}
        control={
          <Switch
            checked={d.enabled}
            size="small"
            onChange={() => {
              enableDisableUser({
                variables: ENABLE_USER_VARIABLES(d.cognitoId, !d.enabled),
              })
            }}
            color="primary"
            inputProps={{ 'aria-label': 'secondary checkbox' }}
          />
        }
      />
      {loading && <CircularProgress size={12} />}
    </>
  )
}

function Edit({ onClick }) {
  return <EditIcon onClick={onClick} />
}

export default UserTable
