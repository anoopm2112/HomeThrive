import React, { useContext, useState, useEffect } from 'react'
import axios from 'axios'
import Link from 'next/link'
import { GET_FAMILY } from '~/lib/queries/families'
import { GET_CHILDREN } from '~/lib/queries/children'
import { useQuery } from '@apollo/client'
import { NotificationContext } from '~/components/Contexts/NotificationContext'
import Alert from '@material-ui/lab/Alert'
import Paper from '@material-ui/core/Paper'
import Edit from '@material-ui/icons/Edit'
import Typography from '@material-ui/core/Typography'
import Button from '@material-ui/core/Button'
import CircularProgress from '@material-ui/core/CircularProgress'
import Grid from '@material-ui/core/Grid'
import Chip from '@material-ui/core/Chip'
import Dialog from '@material-ui/core/Dialog'
import DialogTitle from '@material-ui/core/DialogTitle'
import DialogContent from '@material-ui/core/DialogContent'
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogActions from '@material-ui/core/DialogActions'
import T from '~/lib/text'
import useStyles from './Details.styles'
import FamilyForm from '~/components/Forms/FamilyForm'

function FamilyDetails({ familyId, role }) {
  const [showDialog, setShowDialog] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const [loading, setLoading] = useState(false)
  const [resendStatus, setResendStatus] = useState(false)
  const [childrenList, setChildrenList] = useState([])
  const [open, setOpen] = useState(false);
  const [resendEmail, setResendEmail] = useState();
  const notificationState = useContext(NotificationContext)
  const id = parseInt(familyId) || undefined
  const canEdit = role <= 2

  //   __     _      _    _
  //  / _|___| |_ __| |_ (_)_ _  __ _
  // |  _/ -_)  _/ _| ' \| | ' \/ _` |
  // |_| \___|\__\__|_||_|_|_||_\__, |
  //                            |___/

  const {
    loading: fetchLoading,
    data: fetchData,
    error: fetchError,
  } = useQuery(GET_FAMILY, {
    skip: !id,
    variables: {
      input: { id: id },
    },
    notifyOnNetworkStatusChange: false,
  })

  const {
    loading: childrenLoading,
    data: childrenData,
    error: childrenError,
    fetchMore,
  } = useQuery(GET_CHILDREN, {
    skip: !id,
    variables: {
      input: {
        parentId: id,
        pagination: {
          limit: 100,
        },
      },
    },
    notifyOnNetworkStatusChange: false,
  })

  useEffect(() => {
    if(familyId){
      setIsLoading(true)
      fetchMore({
        variables: {
          input: {
            parentId: id,
            pagination: {
              limit: 100,
            },
          },
        }
      }).then(res => {
        setChildrenList(res.data)
        setIsLoading(false)
      })
    }
  }, [familyId])

  //     _      _
  //  __| |__ _| |_ __ _   _ __ _ _ ___ _ __
  // / _` / _` |  _/ _` | | '_ \ '_/ -_) '_ \
  // \__,_\__,_|\__\__,_| | .__/_| \___| .__/
  //

  const family = fetchData?.family
  const parent1Name =
    family?.firstName && family?.lastName
      ? `${family.firstName} ${family.lastName}`
      : '--'
  const parent2 =
    family?.secondaryParents.length > 0 ? family?.secondaryParents[0] : []
  const parent2Name =
    parent2?.firstName && parent2?.lastName
      ? `${parent2.firstName} ${parent2.lastName}`
      : '--'
  const parent2Email = parent2?.email ? parent2?.email : '--'
  const parent2Phone = parent2?.phoneNumber ? parent2?.phoneNumber : '--'

  const location =
    family?.city && family?.state ? family.city + ', ' + family?.state : '--'
  const children = (childrenList?.children?.items || []).map((e, i) => (
    <Link key={`${e.id}.${i}`} href={`/children/${e.id}`}>
      <Chip label={`${e.firstName} ${e.lastName}`} />
    </Link>
  ))

  const agencyId = family?.agencyId

  // format initial edit state
  let initialEditState
  if (family) {
    const parent2 = family?.secondaryParents.length
      ? family?.secondaryParents[0]
      : {}
    initialEditState = {
      id: id,
      firstName: family?.firstName,
      lastName: family?.lastName,
      agentId: family?.agentId,
      agentName: family?.agentName,
      occupation: family?.occupation,
      parent2Id: parent2?.id,
      parent2FirstName: parent2?.firstName,
      parent2LastName: parent2?.lastName,
      parent2Email: parent2?.email,
      parent2PhoneNumber: parent2?.phoneNumber,
      parent2Occupation: parent2?.occupation,
      licenseNumber: family?.licenseNumber,
      city: family?.city,
      state: family?.state,
      zipCode: family?.zipCode,
      primaryLanguage: family?.primaryLanguage,
      address: family?.address,
      email: family?.email,
      phoneNumber: family?.phoneNumber,
    }
  }

  const classes = useStyles()

  const handleClickOpen = (emailId) => {
    setOpen(true)
    setResendEmail(emailId)
  };

  const handleClose = () => {
    setOpen(false)
  };

  const handleSend = async () => {
    setLoading(true)
    try {
      setLoading(true)
      const url = process.env.NEXT_PUBLIC_UNAUTHED_ENDPOINT
      const id = process.env.NEXT_PUBLIC_USER_POOL_WEB_CLIENT_ID

      const r = await axios({
        method: 'POST',
        url: url,
        data: {
          query: `mutation ForgotPassword($input: ForgotPasswordInput!) {
            forgotPassword(input: $input)
          }`,
          variables: {
            input: {
              clientId: id,
              email: resendEmail.trim(),
            },
          },
        },
        headers: {
          'Content-Type': 'application/json',
        },
      })

      if (!r.data?.data?.forgotPassword || r?.data.errors) {
        ;(r.data.errors || []).forEach((e) => console.error(e.message))
        throw new Error(r?.data?.errors[0].message)
      }
    } catch (err) {
      console.error(err)
    } finally {
      setLoading(false)
      setOpen(false)
      setResendStatus(true)
    }
  };

  useEffect(() => {
    if (resendStatus) {
      notificationState.set({
        open: true,
        message: T('SuccessResendInvitation'),
      })
      setResendStatus(false)
    }
  }, [resendStatus])

  return (
    <>
    <Dialog
      open={open}
      onClose={handleClose}
      aria-labelledby="alert-dialog-title"
      aria-describedby="alert-dialog-description"
    >
      <DialogTitle id="alert-dialog-title">{"Resend invitation?"}</DialogTitle>
      <DialogContent>
        <DialogContentText id="alert-dialog-description">
          Do you want to resend invitation to {resendEmail} ? The user will receive an email with a temporary password.
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        <Button
          variant="contained"
          color="secondary"
          onClick={handleClose}
          disabled={loading}
        >
          {T('Cancel')}
        </Button>
        <Button
          variant="contained"
          color="primary"
          onClick={handleSend}
          disabled={loading}
          endIcon={
            loading && (
              <CircularProgress style={{ color: 'white' }} size={12} />
            )
          }
        >
          {T('Submit')}
        </Button>
      </DialogActions>
    </Dialog>
    <Paper className={classes.paper}>
      {fetchLoading || isLoading ? (
        <CircularProgress />
      ) : (
        <div className="agency-details">
          {canEdit && (
            <FamilyForm
              show={showDialog}
              handleClose={() => setShowDialog(false)}
              initialState={initialEditState}
              agencyId={role == 0 ? agencyId : null}
            />
          )}
          {fetchError && <Alert severity="error">{fetchError.message}</Alert>}
          <Grid container spacing={2}>
            <Grid item xs={12} className={classes.header}>
              <Typography className={classes.detailsTitle} variant="h4">
                {T('FamilyDetailsHeader')}
              </Typography>
              {canEdit && (
                <Button color="secondary" onClick={() => setShowDialog(true)}>
                  <Edit />
                </Button>
              )}
            </Grid>
            <Grid item xs={12} md={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Name1')}
              </Typography>
              <Typography variant="h3">{parent1Name}</Typography>
            </Grid>
            <Grid item xs={12} md={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Email1')}
              </Typography>
              <Typography className={classes.email} variant="body1">{family?.email}</Typography>
            </Grid>
            <Grid item xs={family?.canResendInvitation?.primaryParent ? 6 : 12}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Phone1')}
              </Typography>
              <Typography variant="body1">{family?.phoneNumber}</Typography>
            </Grid>
            {family?.canResendInvitation?.primaryParent ? 
            <Grid item xs={12} md={6}>
              <Button
                variant="contained"
                color="primary"
                onClick={()=>handleClickOpen(family?.email)}
              >
                Resend Invitation
              </Button>
            </Grid>
            : <></> }
            <Grid item xs={12} md={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Name2')}
              </Typography>
              <Typography variant="h3">{parent2Name}</Typography>
            </Grid>
            <Grid item xs={12} md={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Email2')}
              </Typography>
              <Typography className={classes.email} variant="body1">{parent2Email}</Typography>
            </Grid>
            <Grid item xs={parent2?.email && family?.canResendInvitation?.secondaryParent ? 6 : 12}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Phone2')}
              </Typography>
              <Typography variant="body1">{parent2Phone}</Typography>
            </Grid>
            {parent2?.email && family?.canResendInvitation?.secondaryParent ? 
            <Grid item xs={12} md={6}>
              <Button
                variant="contained"
                color="primary"
                onClick={()=>handleClickOpen(parent2Email)}
              >
                Resend Invitation
              </Button>
            </Grid> : <></> }
            <Grid item xs={12} md={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Location')}
              </Typography>
              <Typography variant="body1">{location}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('NumChildren')}
              </Typography>
              <Typography variant="body1">{family?.childrenCount}</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('Agent')}
              </Typography>
              <Typography variant="body1">{family?.agentName}</Typography>
            </Grid>
            <Grid item xs={12}>
              <Typography className={classes.groupTitle} variant="body2">
                {T('ChildrenList')}
              </Typography>
              {children}{' '}
              {childrenError && (
                <Alert severity="error">{childrenError.message}</Alert>
              )}
            </Grid>
          </Grid>
        </div>
      )}
    </Paper>
    </>
  )
}

export default FamilyDetails
