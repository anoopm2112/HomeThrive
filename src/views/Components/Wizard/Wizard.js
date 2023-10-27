import React,{useState} from 'react'
// import { View, Text } from 'react-native'
import StepIndicator from 'react-native-step-indicator'

const Wizard=(props)=> {

    const [currentPosition,setCurrentPosition] = useState(0)

    // const labels = ["Living Conditions","Education","Health","Summary", "Redflag","Areas Needing Immediate Intervantion"];
    

const customStyles = {
    stepIndicatorSize: 20,
    currentStepIndicatorSize:30,
    separatorStrokeWidth: 2,
    currentStepStrokeWidth: 3,
    stepStrokeCurrentColor: '#fe7013',
    stepStrokeWidth:3,
    stepStrokeFinishedColor: '#fe7013',
    stepStrokeUnFinishedColor: '#aaaaaa',

    separatorFinishedColor: '#fe7013',
    separatorUnFinishedColor: '#aaaaaa',

    stepIndicatorFinishedColor: '#fe7013',
    stepIndicatorUnFinishedColor: '#ffffff',
    stepIndicatorCurrentColor: '#ffffff',
    stepIndicatorLabelFontSize: 10,

    currentStepIndicatorLabelFontSize: 13,
    stepIndicatorLabelCurrentColor: '#fe7013',
    stepIndicatorLabelFinishedColor: '#ffffff',
    stepIndicatorLabelUnFinishedColor: '#aaaaaa',
    labelColor: '#999999',
    labelSize: 0 ,
    currentStepLabelColor: '#fe7013'
  }
    return (
        <StepIndicator customStyles={customStyles}
         currentPosition={currentPosition}
         labels={props.currentLabel}
         //labels={data.map((item) => item.label)}
         stepCount={9}
         direction="vertical"
         //onPress={()=>console.log("hyi")}
         />
    )
}

export default Wizard
