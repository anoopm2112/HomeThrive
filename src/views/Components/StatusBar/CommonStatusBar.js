import React from 'react';
import { View, StyleSheet, Platform, StatusBar, SafeAreaView } from 'react-native'
// import Palette from '../../../theme/Palette';

const CommonStatusBar = () => {
    return (
        <View>
            {Platform.OS === 'android' ?
                <StatusBar barStyle={'dark-content'} backgroundColor={'#FFFFFF'} /> :
                <View style={styles.iosStyle}>
                    <MyStatusBar barStyle={'dark-content'} backgroundColor={'#FFFFFF'}/>
                </View>
            }
        </View>
    )
}

const MyStatusBar = ({backgroundColor, ...props}) => (
    <View style={[styles.statusBar, { backgroundColor }]}>
      <SafeAreaView>
        <StatusBar translucent backgroundColor={backgroundColor} {...props} />
      </SafeAreaView>
    </View>
  )

const styles = StyleSheet.create({
    iosStyle: {
        backgroundColor: '#FFFFFF',
        justifyContent: 'center'
    }
})

export default CommonStatusBar

