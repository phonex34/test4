/**
 *  test4Layer.m
 *  test4
 *
 *  Created by LzStudio on 9/24/14.
 *  Copyright LTT 2014. All rights reserved.
 */
#include <CoreMotion/CoreMotion.h>
#import "CC3Layer.h"
#import "test4Layer.h"
#import "test4Scene.h"
#define kShouldUseGestures				(CC3_IOS && !APPORTABLE)

@interface CC3Layer (TemplateMethods)
@property (nonatomic, retain) CMMotionManager *motionManager;
-(BOOL) handleTouch: (UITouch*) touch ofType: (uint) touchType;
@end

@implementation test4Layer
CMMotionManager *motionManager;
CCLabelTTF *yawLabel;
CCLabelTTF *posIn360Label;
-(test4Scene*) mashUpScene { return (test4Scene*) self.cc3Scene; }
/**
 * Override to set up your 2D controls and other initial state, and to initialize update processing.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
-(void) initializeControls {
    self.userInteractionEnabled = !kShouldUseGestures;
    self.userInteractionEnabled=YES;
//    self.touchEnabled=YES;
    yawLabel = [CCLabelTTF labelWithString:@"Yaw: " fontName:@"Marker Felt" fontSize:12];
    posIn360Label = [CCLabelTTF labelWithString:@"360Pos: " fontName:@"Marker Felt" fontSize:12];
    yawLabel.position =  ccp(50, 140);
    posIn360Label.position =  ccp(50, 100);
    [self addChild: yawLabel];
    [self addChild:posIn360Label];
    [self isTouchEnabled];
//    self.isTouchEnabled=YES;
    [self setTouchEnabled:YES];
    [self initializeDeviceMotion];
    [self scheduleUpdate];
//    [self initializeDeviceMotion];
}


#pragma mark Updating layer

/**
 * Override to perform set-up activity prior to the scene being opened
 * on the view, such as adding gesture recognizers.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
//-(void) onOpenCC3Layer {}

/**
 * Override to perform tear-down activity prior to the scene disappearing.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
-(void) onCloseCC3Layer {}

/**
 * The ccTouchMoved:withEvent: method is optional for the <CCTouchDelegateProtocol>.
 * The event dispatcher will not dispatch events for which there is no method
 * implementation. Since the touch-move events are both voluminous and seldom used,
 * the implementation of ccTouchMoved:withEvent: has been left out of the default
 * CC3Layer implementation. To receive and handle touch-move events for object
 * picking, uncomment the following method implementation.
 */
/*
-(void) ccTouchMoved: (UITouch *)touch withEvent: (UIEvent *)event {
	[self handleTouch: touch ofType: kCCTouchMoved];
}
 */
#pragma mark Touch handling

/**
 * Handle touch move event under Cocos2D v2 and below.
 *
 * The ccTouchMoved:withEvent: method is optional for the <CCTouchDelegateProtocol>.
 * The event dispatcher will not dispatch events for which there is no method
 * implementation. Since the touch-move events are both voluminous and seldom used,
 * the implementation of ccTouchMoved:withEvent: has been left out of the default
 * CC3Layer implementation. To receive and handle touch-move events for object
 * picking, it must be implemented here.
 *
 * This method will not be invoked if gestures have been enabled.
 */
-(void) ccTouchMoved: (UITouch *)touch withEvent: (UIEvent *)event {
	[self handleTouch: touch ofType: kCCTouchMoved];
}

/**
 * Handle touch move event under Cocos2D v3 and above.
 *
 * The touchMoved:withEvent: method is optional. Since the touch-move events are both
 * voluminous and seldom used, the implementation of this method has been left out of
 * the default CC3Layer implementation. To receive and handle touch-move events for
 * object picking, it must be implemented here.
 *
 * This method will not be invoked if gestures have been enabled.
 */
-(void) touchMoved: (UITouch*) touch withEvent: (UIEvent*) event {
	[self handleTouch: touch ofType: kCCTouchMoved];
}

#if CC3_IOS
#pragma mark Gesture support

/**
 * Invoked when this layer is being opened on the view.
 *
 * If we want to use gestures, we add the gesture recognizers here.
 *
 * By using the cc3AddGestureRecognizer: method to add the gesture recognizers,
 * we ensure that they will be torn down when this layer is removed from the view.
 *
 * This layer has child buttons on it. To ensure that those buttons receive their
 * touch events, we set cancelsTouchesInView to NO on the tap gestures recognizer
 * so that that gesture recognizer allows the touch events to propagate to the buttons.
 * We do not need to do that for the other recognizers because we don't want buttons
 * to receive touch events in the middle of a pan or pinch.
 */
-(void) onOpenCC3Layer {
	if (self.isUserInteractionEnabled) return;
	
	// Register for tap gestures to select 3D nodes.
	// This layer has child buttons on it. To ensure that those buttons receive their
	// touch events, we set cancelsTouchesInView to NO so that the gesture recognizer
	// allows the touch events to propagate to the buttons.
	UITapGestureRecognizer* tapSelector = [[UITapGestureRecognizer alloc]
										   initWithTarget: self action: @selector(handleTapSelection:)];
	tapSelector.numberOfTapsRequired = 1;
	tapSelector.cancelsTouchesInView = NO;		// Ensures touches are passed to buttons
	[self cc3AddGestureRecognizer: tapSelector];
	
	// Register for single-finger dragging gestures used to spin the two cubes.
	UIPanGestureRecognizer* dragPanner = [[UIPanGestureRecognizer alloc]
										  initWithTarget: self action: @selector(handleDrag:)];
	dragPanner.minimumNumberOfTouches = 1;
	dragPanner.maximumNumberOfTouches = 1;
	[self cc3AddGestureRecognizer: dragPanner];
    
	// Register for double-finger dragging to pan the camera.
	UIPanGestureRecognizer* cameraPanner = [[UIPanGestureRecognizer alloc]
											initWithTarget: self action: @selector(handleCameraPan:)];
	cameraPanner.minimumNumberOfTouches = 2;
	cameraPanner.maximumNumberOfTouches = 2;
	[self cc3AddGestureRecognizer: cameraPanner];
	
	// Register for double-finger dragging to pan the camera.
	UIPinchGestureRecognizer* cameraMover = [[UIPinchGestureRecognizer alloc]
											 initWithTarget: self action: @selector(handleCameraMove:)];
	[self cc3AddGestureRecognizer: cameraMover];
}

/**
 * This handler is invoked when a single-tap gesture is recognized.
 *
 * If the tap occurs within a descendant CCNode that wants to capture the touch,
 * such as a menu or button, the gesture is cancelled. Otherwise, the tap is
 * forwarded to the CC3Scene to pick the 3D node under the tap.
 */
-(void) handleTapSelection: (UITapGestureRecognizer*) gesture {
    
	// Once the gesture has ended, convert the UI location to a 2D node location and
	// pick the 3D node under that location. Don't forget to test that the gesture is
	// valid and does not conflict with touches handled by this layer or its descendants.
	if ( [self cc3ValidateGesture: gesture] && (gesture.state == UIGestureRecognizerStateEnded) ) {
		CGPoint touchPoint = [self cc3ConvertUIPointToNodeSpace: gesture.location];
		[self.mashUpScene pickNodeFromTapAt: touchPoint];
	}
}

/**
 * This handler is invoked when a single-finger drag gesture is recognized.
 *
 * If the drag starts within a descendant CCNode that wants to capture the touch,
 * such as a menu or button, the gesture is cancelled.
 *
 * The CC3Scene marks where dragging begins to determine the node that is underneath
 * the touch point at that time, and is further notified as dragging proceeds.
 * It uses the velocity of the drag to spin the cube nodes. Finally, the scene is
 * notified when the dragging gesture finishes.
 *
 * The dragging movement is normalized to be specified relative to the size of the
 * layer, making it independant of the size of the layer.
 */
-(void) handleDrag: (UIPanGestureRecognizer*) gesture {
	switch (gesture.state) {
		case UIGestureRecognizerStateBegan:
			if ( [self cc3ValidateGesture: gesture] ) {
				[self.mashUpScene startDraggingAt: [self cc3ConvertUIPointToNodeSpace: gesture.location]];
			}
			break;
		case UIGestureRecognizerStateChanged:
			[self.mashUpScene dragBy: [self cc3NormalizeUIMovement: gesture.translation]
						  atVelocity:[self cc3NormalizeUIMovement: gesture.velocity]];
			break;
		case UIGestureRecognizerStateEnded:
			[self.mashUpScene stopDragging];
			break;
		default:
			break;
	}
}

/**
 * This handler is invoked when a double-finger pan gesture is recognized.
 *
 * If the panning starts within a descendant CCNode that wants to capture the touch,
 * such as a menu or button, the gesture is cancelled.
 *
 * The CC3Scene marks the camera orientation when dragging begins, and is notified
 * as dragging proceeds. It uses the relative translation of the panning movement
 * to determine the new orientation of the camera. Finally, the scene is notified
 * when the dragging gesture finishes.
 *
 * The dragging movement is normalized to be specified relative to the size of the
 * layer, making it independant of the size of the layer.
 */
-(void) handleCameraPan: (UIPanGestureRecognizer*) gesture {
	switch (gesture.state) {
		case UIGestureRecognizerStateBegan:
			if ( [self cc3ValidateGesture: gesture] ) [self.mashUpScene startPanningCamera];
			break;
		case UIGestureRecognizerStateChanged:
			[self.mashUpScene panCameraBy: [self cc3NormalizeUIMovement: gesture.translation]];
			break;
		case UIGestureRecognizerStateEnded:
			[self.mashUpScene stopPanningCamera];
			break;
		default:
			break;
	}
}


/**
 * This handler is invoked when a pinch gesture is recognized.
 *
 * If the pinch starts within a descendant CCNode that wants to capture the touch,
 * such as a menu or button, the gesture is cancelled.
 *
 * The CC3Scene marks the camera location when pinching begins, and is notified
 * as pinching proceeds. It uses the relative scale of the pinch gesture to determine
 * a new location for the camera. Finally, the scene is notified when the pinching
 * gesture finishes.
 *
 * Note that the pinching does not zoom the camera, although the visual effect is
 * very similar. For this application, moving the camera is more flexible and useful
 * than zooming. But other application might prefer to use the pinch gesture scale
 * to modify the uniformScale or fieldOfView properties of the camera, to perform
 * a true zooming effect.
 */
-(void) handleCameraMove: (UIPinchGestureRecognizer*) gesture {
	switch (gesture.state) {
		case UIGestureRecognizerStateBegan:
			if ( [self cc3ValidateGesture: gesture] ) [self.mashUpScene startMovingCamera];
			break;
		case UIGestureRecognizerStateChanged:
			[self.mashUpScene moveCameraBy: gesture.scale];
			break;
		case UIGestureRecognizerStateEnded:
			[self.mashUpScene stopMovingCamera];
			break;
		default:
			break;
	}
}
-(void) initializeDeviceMotion {
    
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 1.0/60.0;
   // [motionManager startDeviceMotionUpdates];
   if (motionManager.isDeviceMotionAvailable) {
        [motionManager startDeviceMotionUpdates];
   }
    
    
}


-(void) update:(CCTime) dt {
    
    [self sampleDeviceMotion];
    
    [super update: dt];
    
    
}


-(void) sampleDeviceMotion {
    
    if (motionManager.isDeviceMotionActive) {
        
        CMDeviceMotion *currentDeviceMotion = motionManager.deviceMotion;
        CMAttitude *currentAttitude = currentDeviceMotion.attitude;
        
        // 1: Convert the radians yaw value to degrees then round up/down
        float yaw = roundf((float)(CC_RADIANS_TO_DEGREES(currentAttitude.yaw)));
        
        // 2: Convert the degrees value to float and use Math function to round the value
        [yawLabel setString:[NSString stringWithFormat:@"Yaw: %.0f", yaw]];
        
        // 3: Convert the yaw value to a value in the range of 0 to 360
        int positionIn360 = yaw;
        if (positionIn360 < 0) {
            positionIn360 = 360 + positionIn360;
        }
        
        [posIn360Label setString:[NSString stringWithFormat:@"360Pos: %d", positionIn360]];
        
    }
    
}
#endif	// CC3_IOS
@end
