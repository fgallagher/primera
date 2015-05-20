//
//  EMPlayerSession.h
//  Puddy
//
//  Created by Shane Arney on 11/11/12.
//  Copyright (c) 2012 srainier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
//#import "EMPlaybackControl.h"
@class GVMusicPlayerController;

@interface PRPlayerSession : NSObject

- (void) startAudioSession;
- (void) endAudioSession;

- (BOOL) handleRemoteControlReceivedEvent:(UIEvent *)event withPlayer:(GVMusicPlayerController *)player;

@end
