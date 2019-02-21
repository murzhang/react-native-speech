import {NativeModules, Platform} from 'react-native';

const {SpeechModule} = NativeModules;

const Speech = {
    speak(context, callback) {
        let options = {};
        if (context.constructor === String) {
            options.text = context;
            options.language = 'zh-CH';
        } else {
            options = context;
        }
        if (!callback) {
            callback = function callback(argument) {
            }
        }
        let platformStandRate = 1.0;
        if (Platform.OS === 'ios') {
            platformStandRate = 0.5;
        }
        options.rate = options.rate || 1.0;
        options.rate = options.rate * platformStandRate;//换算为平台标准语速
        SpeechModule.speak(options, callback);
    },
    stop() {
        SpeechModule.stop();
    },
    isSpeaking(callback) {
        if (!callback) {
            callback = function callback(argument) {
            }
        }
        SpeechModule.isSpeaking(callback);
    }
}

export default Speech;
