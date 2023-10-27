import React, { useState } from 'react'
import { useQuery, useMutation } from '@apollo/client'
import Grid from '@material-ui/core/Grid'
import Typography from '@material-ui/core/Typography'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button'
import MenuItem from '@material-ui/core/MenuItem'
import CircularProgress from '@material-ui/core/CircularProgress'
import T from '~/lib/text'
import { RolesForCreate } from '~/lib/assets/copy'
import { GET_AGENCIES, GET_AGENCIES_VARIABLES } from '~/lib/queries/agencies'
import { CREATE_USER } from '~/lib/queries/users'
import { formatPhoneNumber } from '~/lib/utils'
import useStyles from './Register.styles'

function Register() {
  const [formState, setFormState] = useState({
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    role: RolesForCreate[0],
    agency: '',
    terms: false,
    validation: {},
  })

  const { loading, data } = useQuery(GET_AGENCIES, {
    variables: GET_AGENCIES_VARIABLES('', 100),
  })

  const [
    createUser,
    { loading: createLoading, data: createData, error: createError },
  ] = useMutation(CREATE_USER)

  function handleChange(e) {
    const el = e.target
    const val = el.value
    const checked = el.checked
    setFormState({ ...formState, [el.id]: el.id === 'terms' ? checked : val })
  }

  function handleSelectChange(e) {
    const { name, value } = e.target
    setFormState({ ...formState, [name]: value })
  }

  function handleSubmit() {
    const vars = {
      input: {
        email: formState.email,
        firstName: formState.firstName,
        phoneNumber: formatPhoneNumber(formState.phone),
        lastName: formState.lastName,
        role: formState.role,
      },
    }
    if (formState.role !== RolesForCreate[0]) {
      vars.input.agencyId = formState.agency
    }

    createUser({
      variables: vars,
    })
  }

  const agencies = data?.agencies?.items || []
  const agencyOptions = agencies.map(({ name, id }) => (
    <MenuItem key={id} value={id}>
      {name}
    </MenuItem>
  ))

  const classes = useStyles()
  return (
    <div className="register-form">
      <Grid container spacing={3}>
        <Grid item xs={12}>
          <Typography variant="h2">{T('Heading')}</Typography>
          <Typography variant="body1">{T('SubHeading')}</Typography>
        </Grid>
        <Grid item xs={12}>
          <TextField
            className={classes.field}
            id="firstName"
            variant="outlined"
            label={T('FirstName')}
            value={formState.name}
            onChange={handleChange}
          />
          <TextField
            className={classes.field}
            id="lastName"
            variant="outlined"
            label={T('LastName')}
            value={formState.phone1}
            onChange={handleChange}
          />
          <TextField
            className={classes.field}
            id="email"
            variant="outlined"
            label={T('Email')}
            value={formState.occupation1}
            onChange={handleChange}
          />
          <TextField
            className={classes.field}
            id="phone"
            variant="outlined"
            label={T('Phone')}
            value={formState.name}
            onChange={handleChange}
          />
          <TextField
            className={classes.field}
            name="role"
            id="Role"
            variant="outlined"
            label={T('Role')}
            select={true}
            value={formState.role}
            onChange={handleSelectChange}
          >
            {RolesForCreate.map((name) => (
              <MenuItem key={name} value={name}>
                {name}
              </MenuItem>
            ))}
          </TextField>
          <TextField
            id="agency"
            name="agency"
            className={classes.field}
            variant="outlined"
            label={T('Agency')}
            select
            value={formState.agency}
            onChange={handleSelectChange}
            error={!!formState.validation?.agency}
            helperText={formState.validation?.agency || ''}
            disabled={loading || formState.role === RolesForCreate[0]} // only allow agency select if the role is set to agency
          >
            {agencyOptions}
          </TextField>
        </Grid>

        <Grid item xs={6}>
          <Button href="/auth/login" color="primary">
            {T('ExistingAccount')}
          </Button>
        </Grid>
        <Grid item xs={6}>
          <Button
            variant="contained"
            color="primary"
            onClick={handleSubmit}
            disabled={loading}
            endIcon={
              createLoading && (
                <CircularProgress style={{ color: 'white' }} size={12} />
              )
            }
          >
            {T('Submit')}
          </Button>
        </Grid>
      </Grid>
    </div>
  )
}

export default Register
