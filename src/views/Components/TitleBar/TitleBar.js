import React from 'react';
import { useNavigation } from '@react-navigation/native';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native'
import Icon from 'react-native-vector-icons/FontAwesome5';
import TextView from '../TextView/TextView';

const TitleBar = ({ title, goBack, hideBack = false }) => {
    const navigation = useNavigation()
    return (
        <View style={[styles.parent, hideBack ? { marginHorizontal: 0 } : {}]}>
            {!hideBack && <TouchableOpacity
                onPress={() => {
                    if (goBack !== undefined) {
                        goBack()
                    } else {
                        navigation.goBack()
                    }
                }}
            >
                <Icon name="arrow-left" size={25} />
            </TouchableOpacity>}
            {title && <TextView style={styles.titleText} textObject={title} />}
        </View >
    )
}

const styles = StyleSheet.create({
    parent: {
        display: 'flex',
        flexDirection: 'row',
        alignItems: "center",
        marginVertical: 5,
        marginHorizontal: 10,
    },
    titleText: {
        fontSize: 21,
        fontWeight: "700",
        marginHorizontal: 15
    }
})

export default TitleBar

