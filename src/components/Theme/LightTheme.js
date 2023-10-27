import { createMuiTheme, responsiveFontSizes } from '@material-ui/core/styles'

const theme = createMuiTheme({
  breakpoints: {
    // @FIXME: custom breakpoints not landing in MUI until v5.0.0:
    // https://github.com/mui-org/material-ui/issues/21745
    // This would improve Dashboard table columns UX
    //  See: components/Tables/GenericTable.js
    values: {
      xs: 0,
      // xs2: 460,
      sm: 600,
      // sm2: 768,
      md: 960,
      // md2: 1076,
      lg: 1280,
      // lg2: 1440,
      // lg3: 1650,
      xl: 1920,
    },
  },
  overrides: {
    MuiTextField: {
      root: {
        backgroundColor: '#ffffff',
        borderRadius: '4px',
      },
    },
  },
  typography: {
    htmlFontSize: 16,
    fontFamily: 'Montserrat, Arial',
    h1: {
      fontFamily: 'Playfair Display',
      fontSize: 36,
    },
    h2: {
      fontFamily: 'Playfair Display',
      fontSize: 34,
      fontWeight: 800,
    },
    h3: {
      fontFamily: 'Playfair Display',
      fontSize: 24,
      fontWeight: 800,
    },
    h4: {
      fontFamily: 'Playfair Display',
      fontSize: 20,
      fontWeight: 600,
    },
    body1: {
      fontSize: 16,
    },
    body2: {
      fontSize: 14,
    },
    body3: {
      fontSize: 12,
    },
  },
  palette: {
    primary: {
      main: '#F37123',
      400: '#F37123',
      contrastText: '#FFFFFF',
    },
    secondary: {
      main: '#1D334B',
      400: '#1D334B',
      600: '#152537',
    },
    error: {
      main: '#F37123',
      400: '#F37123',
      600: '#F37123',
    },
    tertiary: {
      backgroundColor: '#79A6BD',
    },
    grey: {
      black: {
        600: '#15212B',
        400: '#424E5A',
      },
      gray: {
        600: '#57636C',
        400: '#95A1AC',
        200: '#DBE2E7',
        100: '#F1F4F8',
      },
    },
  },
})

const responsiveTheme = responsiveFontSizes(theme, { factor: 1.8 })
export default responsiveTheme
