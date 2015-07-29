//
//  OCTSubmanagerCallsEcho.m
//  objcToxBot
//
//  Created by Chuong Vu on 7/29/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import "OCTSubmanagerCallsEcho.h"
#import <objcTox/OCTToxAV.h>

@implementation OCTSubmanagerCallsEcho

- (void)toxAV:(OCTToxAV *)toxAV receiveCallAudioEnabled:(BOOL)audio videoEnabled:(BOOL)video friendNumber:(OCTToxFriendNumber)friendNumber
{
    [toxAV answerIncomingCallFromFriend:friendNumber audioBitRate:48 videoBitRate:400 error:nil];
}

- (void)   toxAV:(OCTToxAV *)toxAV
    receiveAudio:(OCTToxAVPCMData *)pcm
     sampleCount:(OCTToxAVSampleCount)sampleCount
        channels:(OCTToxAVChannels)channels
      sampleRate:(OCTToxAVSampleRate)sampleRate
    friendNumber:(OCTToxFriendNumber)friendNumber
{
    [toxAV sendAudioFrame:pcm sampleCount:sampleCount channels:channels sampleRate:sampleRate toFriend:friendNumber error:nil];
}

- (void)                 toxAV:(OCTToxAV *)toxAV
    receiveVideoFrameWithWidth:(OCTToxAVVideoWidth)width height:(OCTToxAVVideoHeight)height
                        yPlane:(OCTToxAVPlaneData *)yPlane uPlane:(OCTToxAVPlaneData *)uPlane
                        vPlane:(OCTToxAVPlaneData *)vPlane
                       yStride:(OCTToxAVStrideData)yStride uStride:(OCTToxAVStrideData)uStride
                       vStride:(OCTToxAVStrideData)vStride
                  friendNumber:(OCTToxFriendNumber)friendNumber
{
    [toxAV sendVideoFrametoFriend:friendNumber
                            width:width
                           height:height
                           yPlane:yPlane
                           uPlane:uPlane
                           vPlane:vPlane
                            error:nil];
}

@end
