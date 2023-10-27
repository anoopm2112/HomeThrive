import React from 'react';
import { Text } from 'react-native';
import { useTranslation } from "react-i18next";

const TextView = (props) => {
    const { t } = useTranslation()
    return (
        <Text {...props}>
            {props.textObject !== undefined ? t(props.textObject) : ''}
            {props.children ? { ...props.children } : <></>}
        </Text>
    )
}

export default TextView