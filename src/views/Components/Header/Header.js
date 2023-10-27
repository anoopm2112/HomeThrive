import React from 'react';
import { View, Image, TouchableOpacity, StyleSheet } from 'react-native';
import colorPalette from '../../../theme/Palette';
import logoPath from '../../../common/Path';
import Icon from 'react-native-vector-icons/FontAwesome';

const Header = (props) => {

    const styles = StyleSheet.create({
        mainContainer: {
            minHeight: 50,
            backgroundColor: colorPalette.primary.main,
            display: "flex", width: "100%",
            flexDirection: "row",
            paddingHorizontal: 10
        },
        image: {
            height: 30,
            width: 30
        },
        barContainer: {
            flex: 1,
            justifyContent: "flex-end",
            alignItems: "center",
            flexDirection: "row"
        },
        notifyIcon: {
            position: 'absolute',
            right: 2,
            top: 2
        }
    });

    return (
        <View style={styles.mainContainer}>
            <View style={{ flex: 1, justifyContent: 'center' }}>
                <Image source={logoPath.miracle_logo} resizeMode={'contain'} style={styles.image} />
            </View>

            <View style={styles.barContainer}>
                <TouchableOpacity style={{ marginRight: 20 }} onPress={props.toggleDrawer}>
                    <Icon name={"bars"} color={'#052536'} size={24} />
                </TouchableOpacity>

                <TouchableOpacity style={{ marginEnd: 10 }}
                    onPress={() => {
                        if (props.bellIconClick !== undefined) {
                            props.bellIconClick()
                        } else {
                            props.toggleBellIcon()
                        }
                    }}>
                    <Icon name={"bell"} size={24} color={'#052536'} />
                    {props.hasNewNotifications && props.hasNewNotifications === true &&
                        <Icon name={"circle"} size={12} color={'white'} style={styles.notifyIcon} />}
                </TouchableOpacity>
            </View>
        </View>
    )
}

export default Header
