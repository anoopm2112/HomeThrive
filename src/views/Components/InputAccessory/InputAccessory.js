import React from 'react';
import { InputAccessoryView, Button, View, StyleSheet, Keyboard } from 'react-native';

const InputAccessory = (props) => {
    return (
        <View>
            <InputAccessoryView nativeID={props.data}>
                <View style={styles.mainContainer}>
                    <View style={styles.btnContainer}>
                        <Button onPress={() => Keyboard.dismiss()} title="Done" />
                    </View>
                </View>
            </InputAccessoryView>
        </View>
    )
}

const styles = StyleSheet.create({
    mainContainer: {
        backgroundColor: '#FFF',
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'flex-end'
    },
    btnContainer: {
        width: '18%'
    }
});

export default InputAccessory;