//
//  speechModule.m
//  speech
//
//  Created by Arron on 16/11/2.
//  Copyright © 2016年 somonus. All rights reserved.
//

#import "speechModule.h"
#import "RCTUtils.h"
#import "RCTLog.h"

@implementation speechModule


RCT_EXPORT_MODULE(SpeechModule)

// Speak
RCT_EXPORT_METHOD(speak:(NSDictionary *)args callback:(RCTResponseSenderBlock)callback)
{
    // Error if self.synthesizer was already initialized
    if (self.isSpeaking) {
        [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        //fixed 中途播报停止时释放资源
        //self.synthesizer = nil;
        //return callback(@[RCTMakeError(@"There is a speech in progress.  Use the `paused` method to know if it's paused.", nil, nil)]);
    }

    self.isSpeaking=false;
    // Set args to variables
    NSString *text = args[@"text"];
    NSString *lang = args[@"language"] ? args[@"language"] : @"zh-CH";
    NSNumber *rate = args[@"rate"];
    
    // Error if no text is passed
    if (!text) {
        RCTLogError(@"[Speech] You must specify a text to speak.");
        return;
    }
    if (self.utterance) {
       self.utterance=[self.utterance initWithString:text];
    }
    else{
        // Setup utterance and voice
        self.utterance = [[AVSpeechUtterance alloc] initWithString:text];
    }
    AVSpeechUtterance *utterance=self.utterance;
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:lang];
    
    if (rate) {
        utterance.rate = [rate doubleValue];
    }
    if(!self.synthesizer){
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        self.synthesizer.delegate = self;
    }
    // Speak
    [self.synthesizer speakUtterance:utterance];
    
    _callback = callback;
}

// Stops synthesizer
RCT_EXPORT_METHOD(stop)
{
    if (self.isSpeaking) {
        [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        
        self.isSpeaking=false;
        //fixed 中途播报停止时释放资源
        //self.synthesizer = nil;
    }
}

// Pauses synthesizer
RCT_EXPORT_METHOD(pauseSpeaking)
{
    if (self.synthesizer) {
        [self.synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}

// Resumes synthesizer
RCT_EXPORT_METHOD(continueSpeaking)
{
    if (self.synthesizer) {
        [self.synthesizer continueSpeaking];
    }
}

// Returns false if synthesizer is paued
RCT_EXPORT_METHOD(isPaused:(RCTResponseSenderBlock)callback)
{
    if (self.synthesizer.paused) {
        callback(@[@true]);
    } else {
        callback(@[@false]);
    }
}

// Returns true if synthesizer is speaking
RCT_EXPORT_METHOD(isSpeaking:(RCTResponseSenderBlock)callback)
{
    if (self.synthesizer.speaking) {
        callback(@[@true]);
    } else {
        callback(@[@false]);
    }
}

// Returns available voices
RCT_EXPORT_METHOD(speechVoices:(RCTResponseSenderBlock)callback)
{
    NSArray *speechVoices = [AVSpeechSynthesisVoice speechVoices];
    NSArray *locales = [speechVoices valueForKey:@"language"];
    
    callback(@[[NSNull null], locales]);
}

// Delegate

// Finished Handler
-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    self.isSpeaking = false;
    _callback(@[@true]);
}

@end
