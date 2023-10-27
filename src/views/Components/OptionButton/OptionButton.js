import React from 'react';
import { Text, View, TouchableOpacity, StyleSheet } from 'react-native';
import MaterialCommunityIcon from 'react-native-vector-icons/MaterialCommunityIcons';
import { convertHeight, convertWidth } from '../../../common/utils/dimensionUtil';

const OptionButton = (props) => {
    const { checked, value, label, viewAssessment, onPress, redFlagOption } = props;

    const styles = StyleSheet.create({
        btnContainer: {
            height: convertHeight(36),
            borderRadius: 5,
            justifyContent: 'center',
            borderColor: '#4E4E4E',
            borderWidth: convertWidth(1),
            flexDirection: 'row',
            alignItems: 'center'
        },
        btnText: {
            color: checked ? '#FFFFFF' : '#4E4E4E',
            textAlign: 'center',
            fontWeight: 'bold'
        }
    });

    return (
        <TouchableOpacity disabled={viewAssessment} onPress={onPress}
            style={[styles.btnContainer, { backgroundColor: checked ? '#1D334B' : '#FFFFFF' }]}>
            <Text style={styles.btnText}>{label}</Text>
            {(value === '1' || value === '2') && redFlagOption &&
                <View style={{ position: 'absolute', right: 5 }}>
                    <MaterialCommunityIcon style={{ justifyContent: 'flex-end' }}
                        name="flag-triangle" size={convertHeight(18)} color={checked ? '#FFFFFF' : '#4E4E4E'} />
                </View>}
        </TouchableOpacity>
    )
}

export default OptionButton;