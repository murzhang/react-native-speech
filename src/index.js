import { NativeModules, Platform } from 'react-native';

const { SpeechModule } = NativeModules;

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
            options.rate = options.rate || 1.0;
            options.rate = options.rate * platformStandRate;//换算为平台标准语速
        }
        else {
            options.rate = options.rate || 1.0;
            /* SpeechModule 规则
            if (options.rate == 0.25) {
                options.rate = 0.25;
            }
            else if (options.rate == 0.5) {
                options.rate = 0.5;
            }
            else if (options.rate == 0.75) {
                options.rate = 0.75;
            }
            else if (options.rate == 1.0) {
                options.rate = 1.0;
            }
            else if (options.rate == 1.25) {
                options.rate = 3.5;
            }
            else if (options.rate == 1.5) {
                options.rate = 7.5;
            }
            else if (options.rate == 1.75) {
                options.rate = 30.0;
            }
            */
           // YSModule 规则0~100
            if (options.rate == 0.25) {
                options.rate = 15.0;
            }
            else if (options.rate == 0.5) {
                options.rate = 25.0;
            }
            else if (options.rate == 0.75) {
                options.rate = 35.0;
            }
            else if (options.rate == 1.0) {
                options.rate = 50.0;
            }
            else if (options.rate == 1.25) {
                options.rate = 75.0;
            }
            else if (options.rate == 1.5) {
                options.rate = 85.0;
            }
            else if (options.rate == 1.75) {
                options.rate = 95.0;
            }
        }
        if (Platform.OS === "ios") {
            SpeechModule.speak(options, callback);
        }
        else {
            NativeModules.YSTTS.speak(options, callback);
        }
    },
    stop() {
        if (Platform.OS === "ios") {
            SpeechModule.stop();
        }
        else {
            NativeModules.YSTTS.stop();
        }
    },
    isSpeaking(callback) {
        if (!callback) {
            callback = function callback(argument) {
            }
        }
        if (Platform.OS === "ios") {
            SpeechModule.isSpeaking(callback);
        }
        else {
            NativeModules.YSTTS.isSpeaking(callback);
        }
    }
}

export default Speech;
