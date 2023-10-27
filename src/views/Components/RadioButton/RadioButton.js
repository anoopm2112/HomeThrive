import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native'
import Icon from 'react-native-vector-icons/MaterialIcons';
import colorPalette from '../../../theme/Palette';
// import { convertWidth } from '../../../common/utils/dimensionUtil';

const RadioButton = (props) => {
    const { label, checked, disabled, onPress } = props
    return (
        <View style={[styles.parent, props.style]}>
            <TouchableOpacity disabled={disabled} activeOpacity={0.4} onPress={onPress}>
                <Icon
                    name={checked ? 'radio-button-on' : 'radio-button-off'}
                    color={!disabled && checked ? colorPalette.primary.main : 'grey'}
                    size={24}
                    style={{ margin: 4 }} />
            </TouchableOpacity>
            {label && <Text onPress={onPress} style={styles.labelTyle}>{label}</Text>}
        </View>
    )
}

const styles = StyleSheet.create({
    parent: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    labelTyle: {
        marginHorizontal: 6,
        color: 'black'
    }
})

export default RadioButton

