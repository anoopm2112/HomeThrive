import React from 'react';
import { Text, TouchableOpacity } from 'react-native';
import { Provider as PaperProvider } from 'react-native-paper';
import { SafeAreaProvider } from 'react-native-safe-area-context';
// import HomePage from '../../HomePage';
import Header from '../Header';
import { theme } from '../../../theme/PaperTheme';
import { DrawerActions } from '@react-navigation/native';
import {
  createDrawerNavigator,
  DrawerContentScrollView,
} from '@react-navigation/drawer';
import AssessmentList from '../../AssessmentList';
// import Home from '../../Home';
import { useNavigation } from '@react-navigation/native';
import CaseList from '../../CaseList';

const Drawer = createDrawerNavigator();

const CustomDrawerContent = (props) => {
  const navigation = useNavigation()
  return (
    <DrawerContentScrollView {...props}>
      {/* <DrawerItemList {...props} /> */}
      <TouchableOpacity
        onPress={() => navigation.dispatch(DrawerActions.jumpTo('CaseList'))}>
        <Text>Case List</Text>
      </TouchableOpacity>
      <Text>Home</Text>
      <Text>Home</Text>
      <Text>Home</Text>
      <Text>Home</Text>
    </DrawerContentScrollView>
  );
}

const DrawerContent = () => {
  const navigation = useNavigation()

  return (
    <PaperProvider theme={theme}>
      <SafeAreaProvider>
        <Header
          profileClick={() => navigation.navigate('Profile')}
          toggleDrawer={() => navigation.dispatch(DrawerActions.openDrawer())}
        />
        <Drawer.Navigator screenOptions={{ headerShown: false }}
          drawerContent={(props) => <CustomDrawerContent {...props} />}>
          <Drawer.Screen component={AssessmentList} name={"AssessmentList"} />
          {/* <Drawer.Screen component={Home} name={"Home"} /> */}
          <Drawer.Screen component={CaseList} name={"CaseList"} />
        </Drawer.Navigator>
      </SafeAreaProvider>
    </PaperProvider>
  );
}

export default DrawerContent;