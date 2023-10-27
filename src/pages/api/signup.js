import Amplify from 'aws-amplify'
Amplify.configure({
  Auth: {
    identityPoolId: process.env.IDENTITY_POOL_ID,
    // REQUIRED - Amazon Cognito Region
    region: process.env.REGION,
    identityPoolRegion: process.env.IDENTITY_POOL_REGION,
    // OPTIONAL - Amazon Cognito User Pool ID
    userPoolId: process.env.USER_POOL_ID,
    // OPTIONAL - Amazon Cognito Web Client ID (26-char alphanumeric string)
    userPoolWebClientId: process.env.USER_POOL_WEB_CLIENT_ID,
    // OPTIONAL - Manually set the authentication flow type. Default is 'USER_SRP_AUTH'
    authenticationFlowType: process.env.AUTHENTICATION_FLOW_TYPE,
  },
})
