//
//  VideoPlayOperation.m
//  VideoPlayer
//
//  Created by eleme on 16/4/26.
//  Copyright © 2016年 zachary. All rights reserved.
//

#import "VideoPlayOperation.h"


@implementation VideoPlayOperation

-(void)videoPlayTask:(NSString *)filePath
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[[NSURL alloc] initFileURLWithPath:filePath] options:nil];
    
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSError *error;
    AVAssetReader* reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
    NSArray* videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    
    if (!videoTracks.count) {
        //没有数据时要将线程取消掉
        self.videoBlock = nil;
        self.stopBlock = nil;
        [self cancel];
        return ;
    }
    
    AVAssetTrack* videoTrack = [videoTracks objectAtIndex:0];
    
    UIImageOrientation orientation = [self orientationFromAVAssetTrack:videoTrack];
    
    int m_pixelFormatType = kCVPixelFormatType_32BGRA;
    NSDictionary* options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt: (int)m_pixelFormatType] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    AVAssetReaderTrackOutput* videoReaderOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:options];
    [reader addOutput:videoReaderOutput];
    [reader startReading];
    while ([reader status] == AVAssetReaderStatusReading && videoTrack.nominalFrameRate > 0&&(!self.isCancelled)&&self.videoBlock) {
        CMSampleBufferRef sampleBuffer = [videoReaderOutput copyNextSampleBuffer];
        if (!sampleBuffer) {
            break;
            
        }
        CGImageRef tpImage=[VideoPlayOperation imageFromSampleBuffer:sampleBuffer rotation:orientation];
        
        MAIN(^{
            if (self.videoBlock) {
                self.videoBlock(tpImage,filePath);
            }
            if (sampleBuffer) {
                CFRelease(sampleBuffer);
            }
            if (tpImage) {
                CGImageRelease(tpImage);
            }
            
           
        });
        [NSThread sleepForTimeInterval:CMTimeGetSeconds(videoTrack.minFrameDuration)];//CMTimeGetSeconds(videoTrack.minFrameDuration)
//        NSLog(@"hahahaa=========%f",CMTimeGetSeconds(videoTrack.minFrameDuration));
    }
    [reader cancelReading];
}

- (UIImageOrientation)orientationFromAVAssetTrack:(AVAssetTrack *)videoTrack
{
    UIImageOrientation orientation;
    CGAffineTransform t = videoTrack.preferredTransform;
    if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
        // Portrait
        //        degress = 90;
        orientation = UIImageOrientationRight;
    }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
        // PortraitUpsideDown
        //        degress = 270;
        orientation = UIImageOrientationLeft;
    }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
        // LandscapeRight
        //        degress = 0;
        orientation = UIImageOrientationUp;
    }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
        // LandscapeLeft
        //        degress = 180;
        orientation = UIImageOrientationDown;
    }
    return orientation;
}



+ (CGImageRef) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer rotation:(UIImageOrientation)orientation{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    unsigned char* pixel = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    CGContextRef context=CGBitmapContextCreate(pixel, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    UIGraphicsEndImageContext();
    return image;
}
@end
