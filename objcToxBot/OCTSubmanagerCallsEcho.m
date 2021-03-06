//
//  OCTSubmanagerCallsEcho.m
//  objcToxBot
//
//  Created by Chuong Vu on 7/29/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import "OCTSubmanagerCallsEcho.h"
#import <objcTox/OCTToxAV.h>

@interface OCTSubmanagerCallsEcho ()

@property (nonatomic, assign) uint8_t *uChromaPlane;
@property (nonatomic, assign) uint8_t *vChromaPlane;
@property (nonatomic, assign) size_t sizeOfChromaPlanes;
@property (nonatomic, assign) uint8_t *yLumaPlane;
@property (nonatomic, assign) size_t sizeOfYLumaPlanes;

@end
@implementation OCTSubmanagerCallsEcho

- (void)toxAV:(OCTToxAV *)toxAV receiveCallAudioEnabled:(BOOL)audio videoEnabled:(BOOL)video friendNumber:(OCTToxFriendNumber)friendNumber
{
    [toxAV answerIncomingCallFromFriend:friendNumber audioBitRate:48 videoBitRate:200 error:nil];
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
                        yPlane:(OCTToxAVPlaneData *)yPlane
                        uPlane:(OCTToxAVPlaneData *)uPlane
                        vPlane:(OCTToxAVPlaneData *)vPlane
                       yStride:(OCTToxAVStrideData)yStride
                       uStride:(OCTToxAVStrideData)uStride
                       vStride:(OCTToxAVStrideData)vStride
                  friendNumber:(OCTToxFriendNumber)friendNumber
{

    size_t maxWidth = MAX(width/2, abs(vStride));
    size_t numberOfElementsForChroma = maxWidth * (height/2);
    /**
     * Recreate the buffers if the original ones are too small
     */
    if (numberOfElementsForChroma > self.sizeOfChromaPlanes) {

        if (self.uChromaPlane) {
            free(self.uChromaPlane);
        }

        if (self.vChromaPlane) {
            free(self.vChromaPlane);
        }

        self.uChromaPlane = (uint8_t *)malloc(numberOfElementsForChroma * sizeof(uint8_t));
        self.vChromaPlane = (uint8_t *)malloc(numberOfElementsForChroma * sizeof(uint8_t));

        self.sizeOfChromaPlanes = numberOfElementsForChroma;
    }

    size_t sizeOfYPlane = width * height;

    if (sizeOfYPlane > self.sizeOfYLumaPlanes) {
        if (self.yLumaPlane) {
            free(self.yLumaPlane);
        }

        self.yLumaPlane = malloc(sizeOfYPlane);
        self.sizeOfYLumaPlanes = sizeOfYPlane;
    }

    uint8_t *uSource = (uint8_t *)uPlane;
    uint8_t *vSource = (uint8_t *)vPlane;
    uint8_t *uDestination = self.uChromaPlane;
    uint8_t *vDestination = self.vChromaPlane;

    uint8_t *ySource = (uint8_t *)yPlane;
    uint8_t *yDestination = self.yLumaPlane;

    for (size_t pixelHeight = 0; pixelHeight < height; pixelHeight++) {
        memcpy(yDestination, ySource, width);
        ySource += yStride;
        yDestination += width;
    }

    // We want to know which direction to move along the source
    // Sometimes strides could be negative. This also assumes uStride and vStride are the same.
    size_t jumpLength = (uStride == 0) ? width / 2 : uStride;

    for (size_t pixelHeight = 0; pixelHeight < height / 2; pixelHeight++) {
        for (size_t pixelWidth = 0; pixelWidth < width / 2; pixelWidth++) {
            uDestination[pixelWidth] = uSource[pixelWidth];
            vDestination[pixelWidth] = vSource[pixelWidth];
        }
        uDestination += width / 2;
        vDestination += width / 2;
        uSource += jumpLength;
        vSource += jumpLength;
    }

    [toxAV sendVideoFrametoFriend:friendNumber
                            width:width
                           height:height
                           yPlane:self.yLumaPlane
                           uPlane:self.uChromaPlane
                           vPlane:self.vChromaPlane
                            error:nil];
}

@end
