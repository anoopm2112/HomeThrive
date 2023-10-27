import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native'
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';
import colorPalette from '../../../theme/Palette';

const CheckBox = (props) => {
    const { label, checked, disabled, onPress } = props
    return (
        <View style={[styles.parent, props.style]}>
            <TouchableOpacity disabled={disabled} activeOpacity={0.4} onPress={onPress}>
                <Icon
                    name={checked ? 'checkbox-marked' : 'checkbox-blank-outline'}
                    color={!disabled && checked ? colorPalette.primary.main : 'grey'}
                    size={24}
                    style={{ margin: 0 }} />
            </TouchableOpacity>
            {label && <Text style={styles.labelTyle}>{label}</Text>}
        </View>
    )
}

const styles = StyleSheet.create({
    parent: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        flex:1
    },
    labelTyle: {
        marginHorizontal: 6,
        color: 'black',
        flex:1
    }
})

export default CheckBox

