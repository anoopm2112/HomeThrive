import React from 'react';
import { View, TouchableOpacity, Linking } from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';
import { useNavigation } from '@react-navigation/native';
import TextView from '../TextView/TextView';

const Footer = (props) => {
    const navigation = useNavigation()


    // const openGmail = async (url) => {
    //     const isSupported = await Linking.canOpenURL(url);
    //     if (isSupported) {
    //         await Linking.openURL(url);
    //     } else {
    //         console.log("Cannot Open mail at this time.")
    //     }
    // }

    return (
        <View style={{
            minHeight: 50,
            display: "flex", width: "100%",
            flexDirection: "row",
            paddingHorizontal: 10,
            backgroundColor: 'white',
            borderTopColor: 'lightgray',
            borderTopWidth: 1,
            paddingVertical: 4,
        }}>

            <View style={{
                flex: 1,
                justifyContent: "center",
                alignItems: "center",
                flexDirection: "row"
            }}>
                <TouchableOpacity
                    style={{ alignItems: 'center' }}
                >
                    <Icon
                        name={"question"}
                        size={25} />
                    <TextView style={{ fontSize: 11 }} textObject={'Common:label:faqs'} />
                </TouchableOpacity>

            </View>

            <View style={{
                flex: 1,
                justifyContent: "center",
                alignItems: "center",
                flexDirection: "row"
            }}>
                <TouchableOpacity
                    onPress={() => navigation.navigate('AssessmentList')}
                    style={{ alignItems: 'center' }}
                >
                    <Icon
                        name={"home"}
                        size={25} />
                    <TextView style={{ fontSize: 11 }} textObject={'Common:label:home'} />
                </TouchableOpacity>

            </View>

            <View style={{
                flex: 1,
                justifyContent: "center",
                alignItems: "center",
                flexDirection: "row"
            }}>
                <TouchableOpacity
                    style={{ alignItems: 'center' }}
                    onPress={() => Linking.openURL(`mailto:miraclefoundation@gmail.com?subject=testing&body=${"Hi"}`)}>
                    <Icon
                        name={"envelope"}
                        size={20} />
                    <TextView style={{ fontSize: 11 }} textObject={'Common:label:messages'} />
                </TouchableOpacity>

            </View>


        </View>
    )
}

export default Footer
