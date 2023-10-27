import { DefaultTheme } from "react-native-paper";
//import  colors from '../colors/Colors';

export const theme = {
    ...DefaultTheme,
    colors : {
        ...DefaultTheme.colors,
        primary : "#f37127",
        text : "#263238",
        placeholder : "#757575", //placeholder text color
        // backdrop : "#30303030",
        notification : "#f3f3",
        label : "#ff00000",
        outline : "none"
    }
}