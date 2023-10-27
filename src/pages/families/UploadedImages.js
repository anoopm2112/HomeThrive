import React, { useState, useEffect } from 'react'
import { IconButton } from '@material-ui/core';
import { GET_FAMILY_IMAGES } from '~/lib/queries/families'
import { useQuery } from '@apollo/client'
import Alert from '@material-ui/lab/Alert'
import Paper from '@material-ui/core/Paper'
import Typography from '@material-ui/core/Typography'
import Button from '@material-ui/core/Button'
import CircularProgress from '@material-ui/core/CircularProgress'
import Grid from '@material-ui/core/Grid'
import Dialog from '@material-ui/core/Dialog'
import DialogTitle from '@material-ui/core/DialogTitle'
import DialogContent from '@material-ui/core/DialogContent'
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogActions from '@material-ui/core/DialogActions'
import T from '~/lib/text'
import useStyles from '~/components/Details/Details.styles'
import ChevronLeftIcon from '~/components/Icons/ChevronLeft.js'
import ChevronRightIcon from '~/components/Icons/ChevronRight.js'

function UploadedImages({ familyId, role }) {
  const [allImages, setAllImages] = useState(null)
  const [currentImages, setCurrentImages] = useState(null)
  const [page, setPage] = useState(1)
  const [highestPage, setHighestPage] = useState(1)
  const [isLoading, setIsLoading] = useState(false)
  const [cursor, setCursor] = useState(null)
  const [open, setOpen] = useState(false);
  const [selectedImage, setSelectedImage] = useState();
  const id = parseInt(familyId) || undefined
  const ImagePerPageCount = 4;

  //   __     _      _    _
  //  / _|___| |_ __| |_ (_)_ _  __ _
  // |  _/ -_)  _/ _| ' \| | ' \/ _` |
  // |_| \___|\__\__|_||_|_|_||_\__, |
  //                            |___/

  const {
    loading: fetchLoading,
    data: fetchData,
    error: fetchError,
  } = useQuery(GET_FAMILY_IMAGES, {
    skip: !id,
    variables: {
      input: { 
        familyId: id,
        pagination: {
          limit: ImagePerPageCount,
          cursor: cursor
        },
      },
    },
    notifyOnNetworkStatusChange: false,
  })

  //     _      _
  //  __| |__ _| |_ __ _   _ __ _ _ ___ _ __
  // / _` / _` |  _/ _` | | '_ \ '_/ -_) '_ \
  // \__,_\__,_|\__\__,_| | .__/_| \___| .__/
  //

  const finalCursor = fetchData?.familyImages?.pageInfo?.cursor
  const hasNextPage = fetchData?.familyImages?.pageInfo?.hasNextPage

  const classes = useStyles()

  const handleClickOpen = (image) => {
    setOpen(true)
    setSelectedImage(image)
  };

  const handleClose = () => {
    setOpen(false)
  };

  useEffect(() => {
    if(!currentImages && page === 1){
      setCurrentImages(fetchData?.familyImages.items)
      setAllImages(fetchData?.familyImages.items)
    } else{
      setCurrentImages(fetchData?.familyImages.items)
      const currentData = fetchData?.familyImages.items
      setHighestPage(page)
      if(currentData && currentData.length > 0){
        setAllImages([...allImages, ...currentData])
      }
    }
  }, [fetchData])

  const clickNextPage = () => {
    if(page === highestPage){
      setPage(page+1)
      setCursor(finalCursor)
    } else{
      setIsLoading(true)
      setTimeout(()=>{
        const tempImages = allImages.slice((page)*ImagePerPageCount, (page+1)*ImagePerPageCount)
        setPage(page+1)
        setCurrentImages(tempImages)
        setIsLoading(false)
      }, 150)
    }
  }

  const clickPrevPage = () => {
    setIsLoading(true)
    setTimeout(()=>{
      const tempImages = allImages.slice((page-2)*ImagePerPageCount, (page-1)*ImagePerPageCount)
      setPage(page-1)
      setCurrentImages(tempImages)
      setIsLoading(false)
    }, 150)
  }

  const download = e => {
    fetch(e.target.href, {
      method: "GET",
      headers: {}
    })
      .then(response => {
        response.arrayBuffer().then(function(buffer) {
          // const url = window.URL.createObjectURL(new Blob([buffer]));
          const link = document.createElement("a");
          link.href = selectedImage?.url;
          link.setAttribute("download", "image.png");
          document.body.appendChild(link);
          link.click();
        });
      })
      .catch(err => {
        console.log(err);
      });
  };

  return (
    <>
    <Dialog
      open={open}
      onClose={handleClose}
      aria-labelledby="alert-dialog-title"
      aria-describedby="alert-dialog-description"
    >
      <DialogTitle id="alert-dialog-title" className={classes.email}>{selectedImage?.name}</DialogTitle>
      <DialogContent>
        <DialogContentText id="alert-dialog-description">
          <img
            className={classes.resourceImageView}
            src={selectedImage?.url}
            alt="Resource Image"
          />
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        <Button
          variant="contained"
          color="primary"
          onClick={e => download(e)}
        >
          Download
        </Button>
        <Button
          variant="contained"
          color="secondary"
          onClick={handleClose}
        >
          {T('Close')}
        </Button>
      </DialogActions>
    </Dialog>
    <Paper className={classes.paper}>
      {fetchLoading || isLoading ? (
        <CircularProgress />
      ) : (
        <div className="agency-details">
          {fetchError && <Alert severity="error">{fetchError.message}</Alert>}
          <Grid container spacing={2}>
            <Grid item xs={12} className={classes.header}>
              <Typography className={classes.detailsTitle} variant="h4">
                {T('UploadedImages')}
              </Typography>
            </Grid>
            <Grid item xs={12}>
              <div className={classes.imageDiv}>
              {currentImages && currentImages.length > 0 ? 
                currentImages.map(item => {
                  return <div className={classes.imageWrapper}>
                    <img
                      className={classes.resourceImage}
                      src={item.url}
                      alt="Resource Image"
                      onClick={()=>handleClickOpen(item)}
                    />
                    <Typography className={classes.imageName} variant="body1">{item.name || '-'}</Typography>
                  </div>
                })
              :<>No images</>}
              </div>
              <div className={classes.arrowDiv}>
                {page > 1 &&
                  <IconButton
                    color="inherit"
                    onClick={()=>clickPrevPage()}
                    sx={{mt : - 0.5}}
                  >
                    <ChevronLeftIcon fontSize="small" />
                  </IconButton>
                }
                {(hasNextPage || page < highestPage) ?
                  <IconButton
                    color="inherit"
                    className={classes.rightArrow}
                    onClick={()=>clickNextPage()}
                    sx={{mt : - 0.5, mr: 3}}
                  >
                    <ChevronRightIcon fontSize="small" />
                  </IconButton>
                  : <></>
                }
              </div>
            </Grid>
          </Grid>
        </div>
      )}
    </Paper>
    </>
  )
}

export default UploadedImages
