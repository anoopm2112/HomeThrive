
import 'react-native-gesture-handler';
import React, { useEffect, useState } from 'react';
import {
  SafeAreaView,
  StyleSheet,
  useColorScheme,
} from 'react-native';

import { SafeAreaProvider } from 'react-native-safe-area-context';
import { Provider as PaperProvider } from 'react-native-paper';

import {
  Colors,
} from 'react-native/Libraries/NewAppScreen';

import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';

import { theme } from './src/theme/PaperTheme';

import Login from './src/views/Login';
import Overview from './src/views/Overview';
import ForgotPassword from './src/views/ForgotPassword';
import NewPassword from './src/views/NewPassword';
import Profile from './src/views/Profile/Profile';
import EditProfile from './src/views/Profile/EditProfile';
import CaseList from './src/views/CaseList';
import Assessment from './src/views/Assessment';
import AssessmentList from './src/views/AssessmentList';
import OfflineOperationHandler from './src/helpers/OfflineOperationHandler';
import DownloadScreen from './src/views/DownloadScreen/DownloadScreen';
import Palette from './src/theme/Palette';
import SideMenuView from './src/views/Components/SideMenuView/SideMenuView';
import AssessmentUpload from './src/views/AssessmentUpload';
import ContinueAssessment from './src/views/ContinueAssessment/ContinueAssessment';
import AppSettings from './src/views/AppSettings/AppSettings';
import './src/common/translation/LangTranslationManager'
import AuthHandler from './src/common/hooks/AuthHandler';
import CommonStatusBar from './src/views/Components/StatusBar/CommonStatusBar';
import NotificationPanel from './src/views/NotificationPanel/NotificationPanel';
import ChangePassword from './src/views/ChangePassword/ChangePassword';
import AssessmentView from './src/views/AssessmentView/AssessmentView';

const Stack = createNativeStackNavigator();

const App = () => {

  const isDarkMode = useColorScheme() === 'dark';
  const [isVisible, setIsVisible] = useState(false)
  const [showNotificationPanel, setShowNotificationPanel] = useState(false)
  const [notificationPanelRef, setNotificationPanelRef] = useState(undefined)

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };

  const toggleMenu = () => {
    setIsVisible(!isVisible)
  }

  const toggleNotificationPanel = () => {
    setShowNotificationPanel(!showNotificationPanel)
  }

  useEffect(() => {
    if (notificationPanelRef !== null && notificationPanelRef !== undefined) {
      if (showNotificationPanel) {
        notificationPanelRef.open()
      } else {
        notificationPanelRef.close()
      }
    }
  }, [showNotificationPanel])

  return (
    <PaperProvider theme={theme}>
      <SafeAreaProvider style={backgroundStyle}>
        <CommonStatusBar barStyle={'light-content'} backgroundColor={Palette.primary.main} />
        <NavigationContainer>
          <AuthHandler>
            <OfflineOperationHandler>
              <SafeAreaView>
                <SideMenuView isVisible={isVisible} onBackdropPress={toggleMenu} />
                <NotificationPanel reference={(ref) => {
                  setNotificationPanelRef(ref)
                }}
                  onDismiss={() => setShowNotificationPanel(false)} 
                  state={showNotificationPanel ? 'open' : 'close'}/>
              </SafeAreaView>
              <Stack.Navigator screenOptions={{
                header: () => null
              }}
                initialRouteName="Login"
              >
                {/* <Stack.Screen name="SplashScreen" component={SplashScreen} /> */}
                <Stack.Screen name="Login" component={Login} />
                <Stack.Screen name="Assessment">
                  {(props) => <Assessment {...props} toggleMenu={toggleMenu}
                    toggleBellIcon={toggleNotificationPanel} />}
                </Stack.Screen>
                <Stack.Screen name="Overview" component={Overview} />
                <Stack.Screen name="ForgotPassword" component={ForgotPassword} />
                <Stack.Screen name="NewPassword" component={NewPassword} />
                <Stack.Screen name="Profile">
                  {(props) => <Profile {...props} toggleMenu={toggleMenu}
                    toggleBellIcon={toggleNotificationPanel} />}
                </Stack.Screen>
                <Stack.Screen name="EditProfile">
                  {(props) => <EditProfile {...props} toggleMenu={toggleMenu}
                    toggleBellIcon={toggleNotificationPanel} />}
                </Stack.Screen>
                <Stack.Screen name="CaseList">
                  {(props) => <CaseList {...props} toggleMenu={toggleMenu}
                    toggleBellIcon={toggleNotificationPanel} />}
                </Stack.Screen>
                <Stack.Screen name="AssessmentList" >
                  {(props) => <AssessmentList {...props} toggleMenu={toggleMenu}
                    toggleBellIcon={toggleNotificationPanel} />}
                </Stack.Screen>
                <Stack.Screen name="ContinueAssessment" >
                  {(props) => <ContinueAssessment {...props} toggleMenu={toggleMenu}
                    toggleBellIcon={toggleNotificationPanel} />}
                </Stack.Screen>
                <Stack.Screen name="Download">
                  {(props) => <DownloadScreen {...props} toggleMenu={toggleMenu}
                    toggleBellIcon={toggleNotificationPanel} />}
                </Stack.Screen>
                <Stack.Screen name="AssessmentUpload">
                  {(props) => <AssessmentUpload {...props} toggleMenu={toggleMenu}
                    toggleBellIcon={toggleNotificationPanel} />}
                </Stack.Screen>
                <Stack.Screen name="AppSettings">
                  {(props) => <AppSettings {...props} toggleMenu={toggleMenu}
                    toggleBellIcon={toggleNotificationPanel} />}
                </Stack.Screen>
                <Stack.Screen name="ChangePassword">
                  {(props) => <ChangePassword {...props} toggleMenu={toggleMenu}
                    toggleBellIcon={toggleNotificationPanel} />}
                </Stack.Screen>
                <Stack.Screen name="AssessmentView">
                  {(props) => <AssessmentView {...props} toggleMenu={toggleMenu}
                    toggleBellIcon={toggleNotificationPanel} />}
                </Stack.Screen>
              </Stack.Navigator>
            </OfflineOperationHandler>
          </AuthHandler>
        </NavigationContainer>
      </SafeAreaProvider>
    </PaperProvider>
  );
};

const styles = StyleSheet.create({
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
  },
  highlight: {
    fontWeight: '700',
  },
});

export default App;
