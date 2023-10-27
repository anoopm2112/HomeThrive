import React from 'react';
// import { View,SafeAreaView,Text,Image, TouchableOpacity, ScrollView  } from 'react-native';
import colorPalette from '../../theme/Palette';
// import Header from '../Components/Header';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Provider as PaperProvider } from 'react-native-paper';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import Icon from 'react-native-vector-icons/FontAwesome';
import { theme } from '../../theme/PaperTheme';
import ForgotPassword from '../ForgotPassword';
import Home from '../Home';
// import Assessment from '../Assessment';
// import CaseList from '../CaseList';

const Tab = createBottomTabNavigator();
const HomePage = () => {
    return (
           
    <PaperProvider theme={theme}>
    <SafeAreaProvider>
    {/* <Header/> */}
    <Tab.Navigator screenOptions={({ route }) => ({
      tabBarIcon: ({ focused, color, size }) => {
        let iconName;
        if (route.name === 'Home') {
        //   iconName = focused
        //     ? 'shopping-bag'
        //     : 'shopping-bag';
        iconName = 'home';
        } else if (route.name === 'ForgotPassword') {
          iconName = 'question';
        } else {
          iconName = 'envelope';
        }
        return <Icon name={iconName} size={iconName === 'envelope' ? 20 : size} color={color} />;
      },
      headerShown: false,
      tabBarShowLabel : false,
      tabBarActiveTintColor: colorPalette.primary.main,
      tabBarInactiveTintColor: 'gray',
    })}
    // tabBarOptions={{
    //   showLabel : false,
    // }}
    >
      <Tab.Screen name="Home" component={Home} />
      <Tab.Screen name="ForgotPassword" component={ForgotPassword} />
      <Tab.Screen name="Forgot" component={ForgotPassword} listeners={{
      tabPress: (e) => {
        e.preventDefault();
        //Any custom code here
        console.log("123");
      },
    }}
  />
      </Tab.Navigator>  
      </SafeAreaProvider>
      </PaperProvider>
    )
}

export default HomePage
