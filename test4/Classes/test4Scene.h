/**
 *  test4Scene.h
 *  test4
 *
 *  Created by LzStudio on 9/24/14.
 *  Copyright LTT 2014. All rights reserved.
 */


#import "CC3Scene.h"
#import "Models.h"
/** A sample application-specific CC3Scene subclass.*/
@interface test4Scene : CC3Scene {
    SpinningNode* _dieCube;
        SpinningNode* _dieCube2;
    struct timeval _lastTouchEventTime;
    CC3Node* _selectedNode;
    CGPoint _lastTouchEventPoint;
    BOOL _isManagingShadows : 1;
    CC3Vector _cameraMoveStartLocation;
	CC3Vector _cameraPanStartRotation;
//   CameraZoomType _cameraZoomType;
    
}
#pragma mark Gesture handling

/**
 * Start moving the camera using the feedback from a UIPinchGestureRecognizer.
 *
 * This method is invoked once at the beginning of each pinch gesture.
 * The current location of the camera is cached. Subsequent invocations of the
 * moveCameraBy: method will move the camera relative to this starting location.
 */
-(void) startMovingCamera;

/**
 * Moves the camera using the feedback from a UIPinchGestureRecognizer.
 *
 * Since the specified movement comes from a pinch gesture, it's value will be a
 * scale, where one represents the initial pinch size, zero represents a completely
 * closed pinch, and values larget than one represent an expanded pinch.
 *
 * Taking the initial pinch size to reference the initial camera location, the camera
 * is moved backwards relative to that location as the pinch closes, and forwards as
 * the pinch opens. Movement is linear and relative to the forwardDirection of the camera.
 *
 * This method is invoked repeatedly during a pinching gesture.
 *
 * Note that the pinching does not zoom the camera, although the visual effect is
 * very similar. For this application, moving the camera is more flexible and useful
 * than zooming. But other application might prefer to use the pinch gesture scale
 * to modify the uniformScale or fieldOfView properties of the camera, to perform
 * a true zooming effect.
 */
-(void) moveCameraBy: (CGFloat) aMovement;

/**
 * Stop moving the camera using the feedback from a UIPinchGestureRecognizer.
 *
 * This method is invoked once at the end of each pinch gesture.
 * This method does nothing.
 */
-(void) stopMovingCamera;

/**
 * Start panning the camera using the feedback from a UIPanGestureRecognizer.
 *
 * This method is invoked once at the beginning of each double-finger pan gesture.
 * The current orientation of the camera is cached. Subsequent invocations of the
 * panCameraBy: method will move the camera relative to this starting orientation.
 */
-(void) startPanningCamera;

/**
 * Pans the camera using the feedback from a UIPanGestureRecognizer.
 *
 * Each component of the specified movement has a value of +/-1 if the user drags two
 * fingers completely across the width or height of the CC3Layer, or a proportionally
 * smaller value for shorter drags. The value changes as the panning gesture continues.
 * At any time, it represents the movement from the initial position when the gesture
 * began, and the startPanningCamera method was invoked. The movement does not represent
 * a delta movement from the previous invocation of this method.
 *
 * This method is invoked repeatedly during a double-finger panning gesture.
 */
-(void) panCameraBy: (CGPoint) aMovement;

/**
 * Stop panning the camera using the feedback from a UIPanGestureRecognizer.
 *
 * This method is invoked once at the end of each double-finger pan gesture.
 * This method does nothing.
 */
-(void) stopPanningCamera;

/**
 * Start dragging whatever object is below the touch point of this gesture.
 *
 * This method is invoked once at the beginning of each single-finger gesture.
 * This method invokes the pickNodeFromTapAt: method to pick the node under the
 * gesture, and cache that node. If that node is either of the two rotating cubes,
 * subsequent invocations of the dragBy:atVelocity: method will spin that node.
 */
-(void) startDraggingAt: (CGPoint) touchPoint;

/**
 * Dragging whatever object was below the initial touch point of this gesture.
 *
 * If the selected node is either of the spinning cubes, spin it based on the
 * specified velocity,
 *
 * Each component of the specified movement has a value of +/-1 if the user drags one
 * finger completely across the width or height of the CC3Layer, or a proportionally
 * smaller value for shorter drags. The value changes as the panning gesture continues.
 * At any time, it represents the movement from the initial position when the gesture
 * began, and the startDraggingAt: method was invoked. The movement does not represent
 * a delta movement from the previous invocation of this method.
 *
 * Each component of the specified velocity is also normalized to the CC3Layer, so that
 * a steady drag completely across the layer taking one second would have a value of
 * +/-1 in the X or Y components.
 *
 * This method is invoked repeatedly during a single-finger panning gesture.
 */
-(void) dragBy: (CGPoint) aMovement atVelocity: (CGPoint) aVelocity;

/**
 * Stop dragging whatever object was below the initial touch point of this gesture.
 *
 * This method is invoked once at the end of each single-finger pan gesture.
 * This method simply clears the cached selected node.
 */
-(void) stopDragging;

@end
