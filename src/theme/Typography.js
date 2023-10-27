import palette from './Palette';

export default {
  h1: {
    color: palette.text.primary, 
    fontSize: 35,
    fontWeight: "bold",
    letterSpacing: -0.24,
    lineHeight: 40
  },
  h2: {
    color: palette.text.primary,  
    fontSize: 29,
    letterSpacing: -0.24,
    lineHeight: 32
  },
  h3: {
    color: palette.text.primary,  
    fontSize: 24,
    letterSpacing: -0.06,
    lineHeight: 28
  },
  h4: {
    color: palette.text.primary,   
    fontSize: 20,
    letterSpacing: -0.06,
    lineHeight: 24
  },
  h5: {
    color: palette.text.primary,   
    fontSize: 16,
    letterSpacing: -0.05,
    lineHeight: 20
  },
  h6: {
    color: palette.text.primary,  
    fontSize: 14,
    letterSpacing: -0.05,
    lineHeight: 20
  },
  subtitle1: {
    color: palette.text.primary,
    fontSize: 16,
    letterSpacing: -0.05,
    lineHeight: 25
  },
  subtitle2: {
    color: palette.text.secondary,    
    fontSize: 14,
    letterSpacing: -0.05,
    lineHeight: 21
  }, 
  body1: {
    color: palette.text.primary,
    fontSize: 14,
    letterSpacing: -0.05,
    lineHeight: 21
  },
  body2: {
    color: palette.text.secondary,
    fontSize: 12,
    letterSpacing: -0.04,
    lineHeight: 18
  },
  button: {
    color: palette.text.primary,
    fontSize: 14
  },
  caption: {
    color: palette.text.secondary,
    fontSize: 11,
    letterSpacing: 0.33,
    lineHeight: 13
  },  
  uppercase: {
    color: palette.text.secondary,
    fontSize: 12,    
    letterSpacing: 0.33,
    lineHeight: 14,
    textTransform: 'uppercase'
  },
  capitalize: {
    color: palette.text.secondary,
    fontSize: 12,    
    letterSpacing: 0.33,
    lineHeight: 14,
    textTransform: 'capitalize'
  },
  alert: {
    color: palette.error.text,
    fontSize: 12,  
    letterSpacing: 0.33,
    lineHeight: 20,     
    paddingLeft: 12, 
    paddingRight: 12
  },
  link: {
    color: palette.text.link,   
    fontSize: 12,
    letterSpacing: -0.04,
    lineHeight: 18
  },
  version: {
    color: palette.text.secondary,
    fontSize: 10,
    letterSpacing: -0.04,
    lineHeight: 18
  } 
};