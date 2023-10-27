import React from 'react'
import { View, StyleSheet, TouchableOpacity } from 'react-native';
import colorPalette from '../../../theme/Palette';
import TextView from '../TextView/TextView';
import { convertHeight, convertWidth } from '../../../common/utils/dimensionUtil';

const PrevNextButtons = (props) => {
    const { formPage, viewAssessment, validateButton, handleLeftClick, loading, validateSaveAndReturn, handleRightClick } = props;

    const styles = StyleSheet.create({
        mainContainer: {
            alignItems: "center",
            flexDirection: "row",
            paddingVertical: convertHeight(15),
            paddingHorizontal: convertWidth(24),
            borderTopWidth: 2,
            borderTopColor: '#E5E5E5'
        },
        btnContainer: {
            width: convertWidth(80),
            height: convertHeight(40),
            justifyContent: "center",
            alignItems: "center",
            borderWidth: 1,
            borderRadius: 5
        },
        previousBtnContainer: {
            borderColor: '#C4C4C4',
            backgroundColor:  '#FFFFFF'
        },
        nextBtnContainer: {
            // borderColor: validateButton() ? colorPalette.grey : formPage === 9 && !viewAssessment ? '#1D334B' : '#1D334B',
            // backgroundColor: validateButton() ? '#7790AB' : formPage === 9 && !viewAssessment ? '#1D334B' : '#1D334B'
            borderColor: validateButton() ? colorPalette.grey : '#1D334B',
            backgroundColor: validateButton() ? '#7790AB' : '#1D334B'
        },
        nextBtnContainer2: {
            backgroundColor: validateButton() ? colorPalette.grey : '#1D334B',
            borderColor: validateButton() ? colorPalette.grey : '#FFFFFF',
        }
    });

    return (
        <View style={styles.mainContainer}>
            <View style={{ flex: 1, alignItems: "flex-start" }}>
                <TouchableOpacity style={[styles.btnContainer, styles.previousBtnContainer]} onPress={() => handleLeftClick()} disabled={loading}>
                    <TextView style={{ color: '#828282' }} textObject={'Assessment:actions:back'} />
                </TouchableOpacity>
            </View>

            {formPage < 10 && !viewAssessment &&
                <TouchableOpacity style={{ width: '42%', }} onPress={() => validateSaveAndReturn()}>
                    <TextView style={{ color: '#1D334B', textDecorationLine: 'underline', textAlign: 'center' }} textObject={'Assessment:actions:saveAndReturn'} />
                </TouchableOpacity>}

            <View style={{ flex: 1, alignItems: "flex-end" }}>
                <TouchableOpacity style={[styles.btnContainer, styles.nextBtnContainer, formPage === 9 && !viewAssessment && styles.nextBtnContainer2]} onPress={() => handleRightClick()}  disabled={loading || validateButton()}>
                    {formPage === 9 && !viewAssessment ?
                        <TextView style={{ color: '#FFFFFF' }} textObject={'Assessment:actions:submit'} />
                        :
                        <TextView style={{ color: '#FFFFFF' }} textObject={'Assessment:actions:next'} />
                    }
                </TouchableOpacity>
            </View>
        </View>
    )
}

export default PrevNextButtons
