import React, { useEffect } from 'react';
import { Image, SafeAreaView, View, ActivityIndicator } from 'react-native';
import logoPath from '../../common/Path';
import { useNavigation } from '@react-navigation/native';
import { useAuthHandlerContext } from '../../common/hooks/AuthHandler';
import Palette from '../../theme/Palette';


const SplashScreen = () => {

    const navigation = useNavigation()
    const { userAuthorized, checkAuthorization } = useAuthHandlerContext()

    useEffect(() => {
        if (userAuthorized !== null) {
            if (userAuthorized) {
                console.log('Navigate to Home')
                navigation.reset({
                    index: 0,
                    routes: [{ name: 'AssessmentList' }],
                })
            } else {
                setTimeout(() => {
                    navigation.reset({
                        index: 0,
                        routes: [{ name: 'Login' }],
                    })
                }, 1500)
            }
        } else {
            checkAuthorization()
        }
    }, [userAuthorized])

    return (
        <SafeAreaView style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
            <View>
                {/* <Image style={{ margin: 20, width: 100, height: 100 }} source={logoPath.miracle_logo} /> */}
                <Image style={{ marginVertical: 20, width: 272, height: 73 }} source={logoPath.miracle_logo_blue} resizeMode={'contain'} />
                <ActivityIndicator
                    animating={true}
                    color={Palette.primary.main}
                    size={"large"}
                    style={{ marginTop: 10 }} />
            </View>
        </SafeAreaView>
    )
}

export default SplashScreen
