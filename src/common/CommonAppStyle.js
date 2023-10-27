import { StyleSheet } from 'react-native';
import { convertHeight } from './utils/dimensionUtil';
import colorPalette from '../theme/Palette';

export const CommonAppStyle = StyleSheet.create({
    ta: {
        logo_header: {
            color: colorPalette.primary.black,
            fontSize: convertHeight(31)
        }
    },
    en: {
        logo_header: {
            color: colorPalette.primary.black,
            fontSize: convertHeight(41)
        }
    },
    hi: {
        logo_header: {
            color: colorPalette.primary.black,
            fontSize: convertHeight(41)
        }
    }
});