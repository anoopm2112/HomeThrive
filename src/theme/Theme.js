import colorPalette from './Palette';

export default {
    safeAreaStyle: {
        backgroundColor: '#f5f5f5'
    },
    activityIndicatorStyle: {
        height: 60,
        width: 60,
        position: "absolute",
        zIndex: 1000,
        top: "50%",
        left: "50%",
        transform: [{ translateX: -30 },
        { translateY: 45 }
        ],
        alignItems: "center",
        justifyContent: "center"
    },
    primaryLabel: {
        color: "lightslategrey",
        textAlign: "center",
        fontSize: 30,
        fontWeight: "bold"
    },
    secondaryLabel: {
        color: "lightslategrey",
        fontSize: 19,
        fontWeight: "500"
    },
    textInputStyle: {
        fontSize: 20,
    },
    textLinks: {
        color: colorPalette.text.link,
        fontSize: 15,
        marginTop: 10,
        textDecorationLine: "underline"
    },
    button: {
        height: 48,
        backgroundColor: colorPalette.button.main,
        borderRadius: 10,
        alignItems: "center",
        justifyContent: "center"
    },
    buttonLabel: {
        color: colorPalette.primary.white,
        fontSize: 17,
        fontWeight: "500"
    },
    text: {
        color: 'black',
    },
    primaryText: {
        color: colorPalette.primary.main,
        fontSize: 14,
    },
    warningText: {
        color: 'crimson',
        fontSize: 14,
    }

};