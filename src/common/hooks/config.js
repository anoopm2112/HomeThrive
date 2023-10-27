import Config from "react-native-config";

export const serverConfig = {
  dev_test: {
    baseUrl: "https://i8dmxxohb6.execute-api.us-east-1.amazonaws.com",
    baseEndPointUrl: "staging-test",
    amplifyConfig: {
      region: "us-east-1",
      userPoolId: "us-east-1_ZFTtvGBRn",
      userPoolWebClientId: "2k3c691cnav4tfrb65e5bq4v7p",
      oauth: {
        responseType: "code"
      }
    }
  },
  dev: {
    baseUrl: "https://ahoqnvmyt2.execute-api.us-east-1.amazonaws.com",
    baseEndPointUrl: "miracle-dev",
    amplifyConfig: {
      region: "us-east-1",
      userPoolId: "us-east-1_TPWk314tw",
      userPoolWebClientId: "3r63jm78qrbnnkdb3v0h1k48si",
      oauth: {
        responseType: "code"
      }
    }
  },
  staging: {
    baseUrl: "https://828cwbwdvb.execute-api.us-east-1.amazonaws.com",
    baseEndPointUrl: "miracle-staging-demo",
    amplifyConfig: {
      region: "us-east-1",
      userPoolId: "us-east-1_DhsAFbdFG",
      userPoolWebClientId: "1pro11cjhf3v7gb3tpnt6vd393",
      oauth: {
        responseType: "code"
      }
    }
  },
  prod: {
    baseUrl: "https://trelujjqg2.execute-api.us-east-1.amazonaws.com",
    baseEndPointUrl: "miracle-prod",
    amplifyConfig: {
      region: "us-east-1",
      userPoolId: "us-east-1_n1KCZjsXF",
      userPoolWebClientId: "5spvcgl19a8hbrfbtv9kqr3mpj",
      oauth: {
        responseType: "code"
      }
    }
  },
}

export const gtmConfig = {
  containerId: process.env.REACT_APP_GTM_CONTAINER_ID
};

const getBaseURL = () => {
  switch (Config.ENV) {
    case 'DEV':
      return serverConfig.dev.baseUrl
    case 'STAGING':
      return serverConfig.staging.baseUrl
    case 'PROD':
      return serverConfig.prod.baseUrl
  }
};

const getBaseEndPoint = () => {
  switch (Config.ENV) {
    case 'DEV':
      return serverConfig.dev.baseEndPointUrl
    case 'STAGING':
      return serverConfig.staging.baseEndPointUrl
    case 'PROD':
      return serverConfig.prod.baseEndPointUrl
  }
}

export const CurrentAmplifyConfig = () => {
  switch (Config.ENV) {
    case 'DEV':
      return serverConfig.dev.amplifyConfig
    case 'STAGING':
      return serverConfig.staging.amplifyConfig
    case 'PROD':
      return serverConfig.prod.amplifyConfig
  }
}

export const AppConfig = {
  baseURL: getBaseURL(),
  baseEndPoint: getBaseEndPoint()
};

