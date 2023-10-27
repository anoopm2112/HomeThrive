import { LANGUAGE_CODE } from '../constant';

export const LANGUAGES = [
    {
        monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'Octobre', 'Novembre', 'Decembre'],
        monthNamesShort: ['Jan.', 'Feb.', 'Mar', 'Apr', 'May', 'Ju', 'Jul.', 'Aug', 'Sept.', 'Oct.', 'Nov.', 'Dec.'],
        dayNames: ['Monday', 'Tuesday', 'wednesday', 'Thursday', 'Friday', 'Satuday', 'Sunday'],
        dayNamesShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat',],
        today: 'Today',
        locale: LANGUAGE_CODE.LANG_ENGLISH
    },
    {
        monthNames: ['जानेवारी', 'फेब्रुवारी', 'मार्च', 'एप्रिल', 'मई', 'जून', 'जुलै', 'ऑगस्ट', 'सप्टेंबर', 'ऑक्टोबर', 'नोव्हेंबर', 'डिसेंबर'],
        monthNamesShort: ['जाने.', 'फेब्रु.', 'मार्च.', 'एप्रि.', 'मई', 'जून', 'जुलै', 'ऑग.', 'सप्टें.', 'ऑक्ट.', 'नोव्हे.', 'डिसें.'],
        dayNames: ['सोमवार', 'मंगळवार', 'बुधवार', 'गुरुवार', 'शुक्रवार', 'शनिवार', 'रविवारी',],
        dayNamesShort: ['रवि', 'सोम', 'मंग', 'बुध', 'गुरु', 'शुक्र', 'शनि',],
        today: 'आज',
        locale: LANGUAGE_CODE.LANG_HINDI
    },
    {
        monthNames: ['ஜனவரி', 'பிப்ரவரி', 'மார்ச்', 'ஏப்ரல்', 'மே', 'ஜூன்', 'ஜூலை', 'ஆகஸ்ட்', 'செப்டம்பர்', 'அக்டோபர்', 'நவம்பர்', 'டிசம்பர்'],
        monthNamesShort: ['ஜன.', 'பிப்.', 'மா', 'ஏப்', 'மே', 'ஜூ', 'ஜூலை.', 'ஆக', 'செப்.', 'அக்.', 'நவ.', 'டிச.'],
        dayNames: ['திங்கட்கிழமை', 'செவ்வாய்க்கிழமை', 'புதன்கிழமை', 'வியாழக்கிழமை', 'வெள்ளிக்கிழமை', 'சனிக்கிழமை', 'ஞாயிற்றுக்கிழமை'],
        dayNamesShort: ['ஞா', 'திங்', 'செ', 'புத', 'வி', 'வெ', 'சனி',],
        today: 'இன்று',
        locale: LANGUAGE_CODE.LANG_TAMIL
    },
];

export const languagesInitialValue = [
    {
        language: 'English',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/197/197484.png',
        languageCode: LANGUAGE_CODE.LANG_ENGLISH,
        id: '1'
    },
    {
        language: 'Hindi',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/197/197419.png',
        languageCode: LANGUAGE_CODE.LANG_HINDI,
        id: '2'
    },
    {
        language: 'Tamil',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/197/197419.png',
        languageCode: LANGUAGE_CODE.LANG_TAMIL,
        id: '3'
    }
]