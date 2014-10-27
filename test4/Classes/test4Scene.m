/**
 *  test4Scene.m
 *  test4
 *
 *  Created by LzStudio on 9/24/14.
 *  Copyright LTT 2014. All rights reserved.
 */
#import "CC3Billboard.h"
#import "test4Scene.h"
#import "CC3PODResourceNode.h"
#import "CC3ActionInterval.h"
#import "CC3MeshNode.h"
#import "CC3Camera.h"
#import "CC3Light.h"

#import "CC3UtilityMeshNodes.h"
#import "CC3Node.h"

/** Enumeration of camera zoom options. */
typedef enum {
    kCameraZoomNone,			/**< Inside the scene. */
    kCameraZoomStraightBack,	/**< Zoomed straight out to view complete scene. */
    kCameraZoomBackTopRight,	/**< Zoomed out to back top right view of complete scene. */
} CameraZoomType;


@interface CC3Node (TemplateMethods)
@property(nonatomic, readonly) CCColorRef initialDescriptorColor;
@end
@implementation test4Scene

/**
 * Constructs the 3D scene prior to the scene being displayed.
 *
 * Adds 3D objects to the scene, loading a 3D 'hello, world' message
 * from a POD file, and creating the camera and light programatically.
 *
 * When adapting this template to your application, remove all of the content
 * of this method, and add your own to construct your 3D model scene.
 *
 * You can also load scene content asynchronously while the scene is being displayed by
 * loading on a background thread. The
 *
 * NOTES:
 *
 * 1) To help you find your scene content once it is loaded, the onOpen method below contains
 *    code to automatically move the camera so that it frames the scene. You can remove that
 *    code once you know where you want to place your camera.
 *
 * 2) The POD file used for the 'hello, world' message model is fairly large, because converting a
 *    font to a mesh results in a LOT of triangles. When adapting this template project for your own
 *    application, REMOVE the POD file 'hello-world.pod' from the Resources folder of your project.
 */


-(void) initializeScene {

	// Optionally add a static solid-color, or textured, backdrop, by uncommenting one of these lines.
    //self.backdrop = [CC3Backdrop nodeWithColor: ccc4f(0.4, 0.5, 0.9, 1.0)];
	//self.backdrop = [CC3Backdrop nodeWithTexture: [CC3Texture textureFromFile: @"Default.png"]];

	// Create the camera, place it back a bit, and add it to the scene
	CC3Camera* cam = [CC3Camera nodeWithName: @"Camera"];
	cam.location = cc3v( 0.0, 0.0, -1.0 );
	[self addChild: cam];

	// Create a light, place it back and to the left at a specific
	// position (not just directional lighting), and add it to the scene
	CC3Light* lamp = [CC3Light nodeWithName: @"Lamp"];
	lamp.location = cc3v( -2.0, 0.0, 0.0 );
	lamp.isDirectionalOnly = NO;
	[cam addChild: lamp];
	
	// Create and load a POD resource file and add its entire contents to the scene.
	// If needed, prior to adding the loaded content to the scene, you can customize the
	// nodes in the resource, remove unwanted nodes from the resource (eg- extra cameras),
	// or extract only specific nodes from the resource to add them directly to the scene,
	// instead of adding the entire contents.
//	CC3ResourceNode* rezNode = [CC3PODResourceNode nodeFromFile: @"hello-world.pod"];
//	[self addChild: rezNode];
	
	// Or, if you don't need to modify the resource node at all before adding its content,
	// you can simply use the following as a shortcut, instead of the previous lines.
//	[self addContentFromPODFile: @"hello-world.pod"];
	
	// In some cases, PODs are created with opacity turned off by mistake. To avoid the possible
	// surprise of an empty scene, the following line ensures that all nodes loaded so far will
	// be visible. However, it also removes any translucency or transparency from the nodes, which
	// may not be what you want. If your model contains transparency or translucency, remove this line.
    self.opacity = kCCOpacityFull;
	
	// Select the appropriate shaders for each mesh node in this scene now. If this step is
	// omitted, a shaders will be selected for each mesh node the first time that mesh node is
	// drawn. Doing it now adds some additional time up front, but avoids potential pauses as
	// the shaders are loaded, compiled, and linked, the first time it is needed during drawing.
	// This is not so important for content loaded in this initializeScene method, but it is
	// very important for content loaded in the addSceneContentAsynchronously method.
	// Shader selection is driven by the characteristics of each mesh node and its material,
	// including the number of textures, whether alpha testing is used, etc. To have the
	// correct shaders selected, it is important that you finish configuring the mesh nodes
	// prior to invoking this method. If you change any of these characteristics that affect
	// the shader selection, you can invoke the removeShaders method to cause different shaders
	// to be selected, based on the new mesh node and material characteristics.
	[self selectShaders];

	// With complex scenes, the drawing of objects that are not within view of the camera will
	// consume GPU resources unnecessarily, and potentially degrading app performance. We can
	// avoid drawing objects that are not within view of the camera by assigning a bounding
	// volume to each mesh node. Once assigned, the bounding volume is automatically checked
	// to see if it intersects the camera's frustum before the mesh node is drawn. If the node's
	// bounding volume intersects the camera frustum, the node will be drawn. If the bounding
	// volume does not intersect the camera's frustum, the node will not be visible to the camera,
	// and the node will not be drawn. Bounding volumes can also be used for collision detection
	// between nodes. You can create bounding volumes automatically for most rigid (non-skinned)
	// objects by using the createBoundingVolumes on a node. This will create bounding volumes
	// for all decendant rigid mesh nodes of that node. Invoking the method on your scene will
	// create bounding volumes for all rigid mesh nodes in the scene. Bounding volumes are not
	// automatically created for skinned meshes that modify vertices using bones. Because the
	// vertices can be moved arbitrarily by the bones, you must create and assign bounding
	// volumes to skinned mesh nodes yourself, by determining the extent of the bounding
	// volume you need, and creating a bounding volume that matches it. Finally, checking
	// bounding volumes involves a small computation cost. For objects that you know will be
	// in front of the camera at all times, you can skip creating a bounding volume for that
	// node, letting it be drawn on each frame. Since the automatic creation of bounding
	// volumes depends on having the vertex location content in memory, be sure to invoke
	// this method before invoking the releaseRedundantContent method.
	[self createBoundingVolumes];
	
	// Create OpenGL buffers for the vertex arrays to keep things fast and efficient, and to
	// save memory, release the vertex content in main memory because it is now redundant.
	[self createGLBuffers];
	[self releaseRedundantContent];

	
	// ------------------------------------------
	
	// That's it! The scene is now constructed and is good to go.
	
	// To help you find your scene content once it is loaded, the onOpen method below contains
	// code to automatically move the camera so that it frames the scene. You can remove that
	// code once you know where you want to place your camera.
	
	// If you encounter problems displaying your models, you can uncomment one or more of the
	// following lines to help you troubleshoot. You can also use these features on a single node,
	// or a structure of nodes. See the CC3Node notes for more explanation of these properties.
	// Also, the onOpen method below contains additional troubleshooting code you can comment
	// out to move the camera so that it will display the entire scene automatically.
	
	// Displays short descriptive text for each node (including class, node name & tag).
	// The text is displayed centered on the pivot point (origin) of the node.
//	self.shouldDrawAllDescriptors = YES;
	
	// Displays bounding boxes around those nodes with local content (eg- meshes).
//	self.shouldDrawAllLocalContentWireframeBoxes = YES;
	
	// Displays bounding boxes around all nodes. The bounding box for each node
	// will encompass its child nodes.
//	self.shouldDrawAllWireframeBoxes = YES;
	
	// If you encounter issues creating and adding nodes, or loading models from
	// files, the following line is used to log the full structure of the scene.
	LogInfo(@"The structure of this scene is: %@", [self structureDescription]);
	
	// ------------------------------------------

	// And to add some dynamism, we'll animate the 'hello, world' message
	// using a couple of actions...
	
	// Fetch the 'hello, world' object that was loaded from the POD file and start it rotating
//	CC3MeshNode* helloTxt = (CC3MeshNode*)[self getNodeNamed: @"Hello"];
//	[helloTxt runAction: [CC3ActionRotateForever actionWithRotationRate: cc3v(0, 30, 0)]];
//	
//	// To make things a bit more appealing, set up a repeating up/down cycle to
//	// change the color of the text from the original red to blue, and back again.
//	GLfloat tintTime = 8.0f;
//	CCColorRef startColor = helloTxt.color;
//	CCColorRef endColor = CCColorRefFromCCC4F(ccc4f(0.2, 0.0, 0.8, 1.0));
//	CCActionInterval* tintDown = [CCActionTintTo actionWithDuration: tintTime color: endColor];
//	CCActionInterval* tintUp   = [CCActionTintTo actionWithDuration: tintTime color: startColor];
//	[helloTxt runAction: [[CCActionSequence actionOne: tintDown two: tintUp] repeatForever]];
    [self addDieCube];
       // [self addDieCube2];
}
/** Various options for configuring interesting camera behaviours. */
-(void) configureCamera {
	CC3Camera* cam = self.activeCamera;
    
	// Camera starts out embedded in the scene.
//	_cameraZoomType = kCameraZoomNone;
	
	// The camera comes from the POD file and is actually animated.
	// Stop the camera from being animated so the user can control it via the user interface.
	[cam disableAnimation];
	
	// Keep track of which object the camera is pointing at
//	_origCamTarget = cam.target;
//	_camTarget = _origCamTarget;
	
	// Set the field of view orientation to diagonal, to give a good overall average view of
	// the scene, regardless of the shape of the viewing screen. As loaded from the POD file,
	// the FOV is measured horizontally.
	cam.fieldOfViewOrientation = CC3FieldOfViewOrientationDiagonal;
    
	// For cameras, the scale property determines camera zooming, and the effective field of view.
	// You can adjust this value to play with camera zooming. Conversely, if you find that objects
	// in the periphery of your view appear elongated, you can adjust the fieldOfView and/or
	// uniformScale properties to reduce this "fish-eye" effect. See the notes of the CC3Camera
	// fieldOfView property for more on this.
	cam.uniformScale = 0.5;
	
	// You can configure the camera to use orthographic projection instead of the default
	// perspective projection by setting the isUsingParallelProjection property to YES.
	// You will also need to adjust the scale to match the different projection.
    //	cam.isUsingParallelProjection = YES;
    //	cam.uniformScale = 0.015;
	
	// To see the effect of mounting a camera on a moving object, uncomment the following
	// lines to mount the camera on a virtual boom attached to the beach ball.
	// Since the beach ball rotates as it bounces, you might also want to comment out the
	// CC3ActionRotateForever action that is run on the beach ball in the addBeachBall method!
    //	[_beachBall addChild: cam];				// Mount the camera on the beach ball
    //	cam.location = cc3v(2.0, 1.0, 0.0);		// Relative to the parent beach ball
    //	cam.rotation = cc3v(0.0, 90.0, 0.0);	// Point camera out over the beach ball
    
	// To see the effect of mounting a camera on a moving object AND having the camera track a
	// location or object, even as the moving object bounces and rotates, uncomment the following
	// lines to mount the camera on a virtual boom attached to the beach ball, but stay pointed at
	// the moving rainbow teapot, even as the beach ball that the camera is mounted on bounces and
	// rotates. In this case, you do not need to comment out the CC3ActionRotateForever action that
	// is run on the beach ball in the addBeachBall method
    //	[_beachBall addChild: cam];				// Mount the camera on the beach ball
    //	cam.location = cc3v(2.0, 1.0, 0.0);		// Relative to the parent beach ball
    //	cam.target = teapotSatellite;			// Look toward the rainbow teapot...
    //	cam.shouldTrackTarget = YES;			// ...and track it as it moves
}


/**
 * By populating this method, you can add add additional scene content dynamically and
 * asynchronously after the scene is open.
 *
 * This method is invoked from a code block defined in the onOpen method, that is run on a
 * background thread by the CC3Backgrounder available through the backgrounder property.
 * It adds content dynamically and asynchronously while rendering is running on the main
 * rendering thread.
 *
 * You can add content on the background thread at any time while your scene is running, by
 * defining a code block and running it on the backgrounder. The example provided in the
 * onOpen method is a template for how to do this, but it does not need to be invoked only
 * from the onOpen method.
 *
 * Certain assets, notably shader programs, will cause short, but unavoidable, delays in the
 * rendering of the scene, because certain finalization steps from shader compilation occur on
 * the main thread when the shader is first used. Shaders and certain other critical assets can
 * be pre-loaded and cached in the initializeScene method, prior to the opening of this scene.
 */

-(void) configureForScene: (CC3Node*) aNode andMaterializeWithDuration: (CCTime) duration {
	
	// This scene is quite complex, containing many objects. As the user moves the camera
	// around the scene, objects move in and out of the camera's field of view. At any time,
	// there may be a number of objects that are out of view of the camera. With such a scene
	// layout, we can save significant GPU processing by not drawing those objects. To make
	// that happen, we assign a bounding volume to each mesh node. Once that is done, only
	// those objects whose bounding volumes intersect the camera frustum will be drawn.
	// Bounding volumes can also be used for collision detection between nodes. You can see
	// the effect of not using bounding volumes on drawing perfomance by commenting out the
	// following line and taking note of the drop in performance for this scene. However,
	// testing bounding volumes against the camera's frustum does take some CPU processing,
	// and in scenes where all or most of the objects are in front of the camera at all times,
	// using bounding volumes may actually result in slightly lower performance. By including
	// or not including the line below, you can test both scenarios and decide which approach
	// is best for your particular scene. Bounding volumes are not automatically created for
	// skinned meshes, such as the runners and mallet. See the addSkinnedRunners and
	// addSkinnedMallet methods to see how those bounding volumes are added manually.
	[aNode createBoundingVolumes];
	
	// Create OpenGL buffers for the vertex arrays to keep things fast and efficient, and
	// to save memory, release the vertex data in main memory because it is now redundant.
	// However, because we can add shadow volumes dynamically to any node, we need to keep the
	// vertex location, index and skinning data of all meshes around to build shadow volumes.
	// If we had added the shadow volumes before here, we wouldn't have to retain this data.
	[aNode retainVertexLocations];
	[aNode retainVertexIndices];
	[aNode retainVertexBoneWeights];
	[aNode retainVertexBoneIndices];
	[aNode createGLBuffers];
	[aNode releaseRedundantContent];
	
	// The following line displays the bounding volumes of each node. The bounding volume of
	// all mesh nodes, except the globe, contains both a spherical and bounding-box bounding
	// volume, to optimize testing. For something extra cool, touch the robot arm to see the
	// bounding volume of the particle emitter grow and shrink dynamically. Use the joystick
	// controls or gestures to back the camera away to get the full effect. You can also turn
	// on this property on individual nodes or node structures. See the notes for this property
	// and the shouldDrawBoundingVolume property in the CC3Node class notes.
    //	aNode.shouldDrawAllBoundingVolumes = YES;
	
	// Select the appropriate shaders for each mesh node descendent now. If this step is omitted,
	// shaders will be selected for each mesh node the first time that mesh node is drawn.
	// Doing it now adds some additional time up front, but avoids potential pauses as the
	// shaders are loaded, compiled, and linked, the first time it is needed during drawing.
	// Shader selection is driven by the characteristics of each mesh node and its material,
	// including the number of textures, whether alpha testing is used, etc. To have the
	// correct shaders selected, it is important that you finish configuring the mesh nodes
	// prior to invoking this method. If you change any of these characteristics that affect
	// the shader selection, you can invoke the removeShaders method to cause different shaders
	// to be selected, based on the new mesh node and material characteristics.
	[aNode selectShaders];
	
	// For an interesting effect, to draw text descriptors and/or bounding boxes on every node
	// during debugging, uncomment one or more of the following lines. The first line displays
	// short descriptive text for each node (including class, node name & tag). The second line
	// displays bounding boxes of only those nodes with local content (eg- meshes). The third
	// line shows the bounding boxes of all nodes, including those with local content AND
	// structural nodes. You can also turn on any of these properties at a more granular level
	// by using these and similar methods on individual nodes or node structures. See the CC3Node
	// class notes. This family of properties can be particularly useful during development to
	// track down display issues.
    //	aNode.shouldDrawAllDescriptors = YES;
    //	aNode.shouldDrawAllLocalContentWireframeBoxes = YES;
    //	aNode.shouldDrawAllWireframeBoxes = YES;
	
	// Use a standard CCActionFadeIn to fade the node in over the specified duration
	if (duration > 0.0f) {
		aNode.opacity = 0;	// Needed for Cocos2D 1.x, which doesn't start fade-in from zero opacity
		[aNode runAction: [CCActionFadeIn actionWithDuration: duration]];
	}
}


#define kDieCubePODFile					@"DieCube.pod"
#define kDieCubePODName					@"Cube"
#define kDieCubeName					@"DieCube"
#define kFadeInDuration					0.0f
-(void) addDieCube{

    CC3ResourceNode* podRezNode = [CC3PODResourceNode nodeFromFile: kDieCubePODFile];
	CC3Node* podDieCube = [podRezNode getNodeNamed: kDieCubePODName];
    _dieCube = [podDieCube copyWithName: kDieCubeName asClass: [SpinningNode class]];
    
	// Now set some properties, including the friction, and add the die cube to the scene
	_dieCube.uniformScale = 30.0;
	_dieCube.location = cc3v(-100.0, 0.0, 0.0);
    [_dieCube setLocation:cc3v(-100.0, 0.0, 0.0)];
	_dieCube.touchEnabled = YES;
	_dieCube.friction = 1.0;
	
	// Cube is added on on background thread. Configure it for the scene, and fade it in slowly.
	[self configureForScene: _dieCube andMaterializeWithDuration: kFadeInDuration];
	[self addChild: _dieCube];

}
-(void) addDieCube2{
    
    CC3ResourceNode* podRezNode = [CC3PODResourceNode nodeFromFile: kDieCubePODFile];
    CC3Node* podDieCube = [podRezNode getNodeNamed: kDieCubePODName];
    _dieCube2 = [podDieCube copyWithName: kDieCubeName asClass: [SpinningNode class]];
    
    // Now set some properties, including the friction, and add the die cube to the scene
    _dieCube2.uniformScale = 30.0;
    _dieCube2.location = cc3v(20.0, 0.0, 0.0);
    [_dieCube2 setLocation:cc3v(20.0, 0.0, 0.0)];
    _dieCube2.touchEnabled = YES;
    _dieCube2.friction = 1.0;
    
    // Cube is added on on background thread. Configure it for the scene, and fade it in slowly.
    [self configureForScene: _dieCube2 andMaterializeWithDuration: kFadeInDuration];
    [self addChild: _dieCube2];
    [_dieCube runAction:[CC3ActionMoveTo  actionWithDuration:3.0f moveTo: cc3v(40, 20, -30)]];
    
}
-(void) addSceneContentAsynchronously {}


#pragma mark Updating custom activity

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides your app with an opportunity to perform update activities before
 * any changes are applied to the transformMatrix of the 3D nodes in the scene.
 *
 * For more info, read the notes of this method on CC3Node.
 */
-(void) updateBeforeTransform: (CC3NodeUpdatingVisitor*) visitor {}

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides your app with an opportunity to perform update activities after
 * the transformMatrix of the 3D nodes in the scen have been recalculated.
 *
 * For more info, read the notes of this method on CC3Node.
 */
-(void) updateAfterTransform: (CC3NodeUpdatingVisitor*) visitor {}


#pragma mark Scene opening and closing

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene is first displayed.
 *
 * This method is a good place to invoke one of CC3Camera moveToShowAllOf:... family
 * of methods, used to cause the camera to automatically focus on and frame a particular
 * node, or the entire scene.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onOpen {

	// Add additional scene content dynamically and asynchronously, on a background thread
	// after rendering has begun on the rendering thread, using the CC3Backgrounder singleton.
	// Asynchronous loading must be initiated after the scene has been attached to the view.
	// It cannot be started in the initializeScene method. However, it does not need to be
	// invoked only from the onOpen method. You can use the code in the line here as a template
	// for use whenever your app requires background content loading after the scene has opened.
	[CC3Backgrounder.sharedBackgrounder runBlock: ^{ [self addSceneContentAsynchronously]; }];

	// Move the camera to frame the scene. The resulting configuration of the camera is output as
	// an [info] log message, so you know where the camera needs to be in order to view your scene.
	[self.activeCamera moveWithDuration: 1.0 toShowAllOf: self withPadding: 0.5f];
    

	// Uncomment this line to draw the bounding box of the scene.
//	self.shouldDrawWireframeBox = YES;
}

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene has been removed from display.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onClose {}


#pragma mark Drawing

/**
 * Template method that draws the content of the scene.
 *
 * This method is invoked automatically by the drawScene method, once the 3D environment has
 * been established. Once this method is complete, the 2D rendering environment will be
 * re-established automatically, and any 2D billboard overlays will be rendered. This method
 * does not need to take care of any of this set-up and tear-down.
 *
 * This implementation simply invokes the default parent behaviour, which turns on the lighting
 * contained within the scene, and performs a single rendering pass of the nodes in the scene 
 * by invoking the visit: method on the specified visitor, with this scene as the argument.
 * Review the source code of the CC3Scene drawSceneContentWithVisitor: to understand the
 * implementation details, and as a starting point for customization.
 *
 * You can override this method to customize the scene rendering flow, such as performing
 * multiple rendering passes on different surfaces, or adding post-processing effects, using
 * the template methods mentioned above.
 *
 * Rendering output is directed to the render surface held in the renderSurface property of
 * the visitor. By default, that is set to the render surface held in the viewSurface property
 * of this scene. If you override this method, you can set the renderSurface property of the
 * visitor to another surface, and then invoke this superclass implementation, to render this
 * scene to a texture for later processing.
 *
 * When overriding the drawSceneContentWithVisitor: method with your own specialized rendering,
 * steps, be careful to avoid recursive loops when rendering to textures and environment maps.
 * For example, you might typically override drawSceneContentWithVisitor: to include steps to
 * render environment maps for reflections, etc. In that case, you should also override the
 * drawSceneContentForEnvironmentMapWithVisitor: to render the scene without those additional
 * steps, to avoid the inadvertenly invoking an infinite recursive rendering of a scene to a
 * texture while the scene is already being rendered to that texture.
 *
 * To maintain performance, by default, the depth buffer of the surface is not specifically
 * cleared when 3D drawing begins. If this scene is drawing to a surface that already has
 * depth information rendered, you can override this method and clear the depth buffer before
 * continuing with 3D drawing, by invoking clearDepthContent on the renderSurface of the visitor,
 * and then invoking this superclass implementation, or continuing with your own drawing logic.
 *
 * Examples of when the depth buffer should be cleared are when this scene is being drawn
 * on top of other 3D content (as in a sub-window), or when any 2D content that is rendered
 * behind the scene makes use of depth drawing. See also the closeDepthTestWithVisitor:
 * method for more info about managing the depth buffer.
 */
-(void) drawSceneContentWithVisitor: (CC3NodeDrawingVisitor*) visitor {
	[super drawSceneContentWithVisitor: visitor];
}


#pragma mark Gesture handling

-(void) startMovingCamera { _cameraMoveStartLocation = self.activeCamera.location; }

-(void) stopMovingCamera {}

/** Set this parameter to adjust the rate of camera movement during a pinch gesture. */
#define kCamPinchMovementUnit		250

-(void) moveCameraBy:  (CGFloat) aMovement {
	CC3Camera* cam = self.activeCamera;
    
	// Convert to a logarithmic scale, zero is backwards, one is unity, and above one is forward.
	GLfloat camMoveDist = logf(aMovement) * kCamPinchMovementUnit;
    
	CC3Vector moveVector = CC3VectorScaleUniform(cam.globalForwardDirection, camMoveDist);
	cam.location = CC3VectorAdd(_cameraMoveStartLocation, moveVector);
}

-(void) startPanningCamera { _cameraPanStartRotation = self.activeCamera.rotation; }

-(void) stopPanningCamera {}

-(void) panCameraBy:  (CGPoint) aMovement {
	CC3Vector camRot = _cameraPanStartRotation;
	CGPoint panRot = ccpMult(aMovement, 90);		// Full pan swipe is 90 degrees
	camRot.y += panRot.x;
	camRot.x -= panRot.y;
	self.activeCamera.rotation = camRot;
}

-(void) startDraggingAt: (CGPoint) touchPoint { [self pickNodeFromTapAt: touchPoint]; }

-(void) dragBy: (CGPoint) aMovement atVelocity: (CGPoint) aVelocity {
	if (_selectedNode == _dieCube)
		[self rotate: ((SpinningNode*)_selectedNode) fromSwipeVelocity: aVelocity];
}

-(void) stopDragging { _selectedNode = nil; }

/** Set this parameter to adjust the rate of rotation from the length of swipe gesture. */
#define kSwipeVelocityScale		400

/**
 * Rotates the specified spinning node by setting its rotation axis
 * and spin speed from the specified 2D drag velocity.
 */
-(void) rotate: (SpinningNode*) aNode fromSwipeVelocity: (CGPoint) swipeVelocity {
	
	// The 2D rotation axis is perpendicular to the drag velocity.
	CGPoint axis2d = ccpPerp(swipeVelocity);
	
	// Project the 2D rotation axis into a 3D axis by mapping the 2D X & Y screen
	// coords to the camera's rightDirection and upDirection, respectively.
	CC3Camera* cam = self.activeCamera;
	aNode.spinAxis = CC3VectorAdd(CC3VectorScaleUniform(cam.rightDirection, axis2d.x),
								  CC3VectorScaleUniform(cam.upDirection, axis2d.y));
    
	// Set the spin speed from the scaled drag velocity.
	aNode.spinSpeed = ccpLength(swipeVelocity) * kSwipeVelocityScale;
    
	// Mark the spinning node as free-wheeling, so that it will start spinning.
	aNode.isFreeWheeling = YES;
}



#pragma mark Handling touch events 

/**
 * This method is invoked from the CC3Layer whenever a touch event occurs, if that layer
 * has indicated that it is interested in receiving touch events, and is handling them.
 *
 * Override this method to handle touch events, or remove this method to make use of
 * the superclass behaviour of selecting 3D nodes on each touch-down event.
 *
 * This method is not invoked when gestures are used for user interaction. Your custom
 * CC3Layer processes gestures and invokes higher-level application-defined behaviour
 * on this customized CC3Scene subclass.
 *
 * For more info, read the notes of this method on CC3Scene.
 */


/** Set this parameter to adjust the rate of rotation from the length of swipe gesture. */

#define kSwipeVelocityScale 400


/**
 * Rotates the specified spinning node by setting its rotation axis
 * and spin speed from the specified 2D drag velocity.
 */


-(void) touchEvent: (uint) touchType at: (CGPoint) touchPoint {
	struct timeval now;
	gettimeofday(&now, NULL);
    
	// Time since last event
	CCTime dt = (now.tv_sec - _lastTouchEventTime.tv_sec) + (now.tv_usec - _lastTouchEventTime.tv_usec) / 1000000.0f;
    
	switch (touchType) {
		case kCCTouchBegan:
			[self pickNodeFromTouchEvent: touchType at: touchPoint];
			break;
		case kCCTouchMoved:
			if (_selectedNode == _dieCube) {
                LogInfo(@"da vao rotate 1");
				[self rotate: ((SpinningNode*)_selectedNode) fromSwipeAt: touchPoint interval:dt  ];
			}
			break;
		case kCCTouchEnded:
			if (_selectedNode == _dieCube ) {
				// If the user lifted the finger while in motion, let the cubes know
				// that they can freewheel now. But if the user paused before lifting
				// the finger, consider it stopped.
                LogInfo(@"da vao rotate 2");
				((SpinningNode*)_selectedNode).isFreeWheeling = (dt < 0.5);
			}
			_selectedNode = nil;
			break;
		default:
			break;
	}
	
	// For all event types, remember when and where the touchpoint was, for subsequent events.
	_lastTouchEventPoint = touchPoint;
	_lastTouchEventTime = now;
}

/** Set this parameter to adjust the rate of rotation from the length of touch-move swipe. */
#define kSwipeScale 0.6

/**
 * Rotates the specified node, by determining the direction of each touch move event.
 *
 * The touch-move swipe is measured in 2D screen coordinates, which are mapped to
 * 3D coordinates by recognizing that the screen's X-coordinate maps to the camera's
 * rightDirection vector, and the screen's Y-coordinates maps to the camera's upDirection.
 *
 * The node rotates around an axis perpendicular to the swipe. The rotation angle is
 * determined by the length of the touch-move swipe.
 *
 * To allow freewheeling after the finger is lifted, we set the spin speed and spin axis
 * in the node. We indicate for now that the node is not freewheeling.
 */
-(void) rotate: (SpinningNode*) aNode fromSwipeAt: (CGPoint) touchPoint interval: (CCTime) dt {
    LogInfo(@"da vao rotate 3");
	CC3Camera* cam = self.activeCamera;
    
	// Get the direction and length of the movement since the last touch move event, in
	// 2D screen coordinates. The 2D rotation axis is perpendicular to this movement.
	CGPoint swipe2d = ccpSub(touchPoint, _lastTouchEventPoint);
	CGPoint axis2d = ccpPerp(swipe2d);
	
	// Project the 2D axis into a 3D axis by mapping the 2D X & Y screen coords
	// to the camera's rightDirection and upDirection, respectively.
	CC3Vector axis = CC3VectorAdd(CC3VectorScaleUniform(cam.rightDirection, axis2d.x),
								  CC3VectorScaleUniform(cam.upDirection, axis2d.y));
	GLfloat angle = ccpLength(swipe2d) * kSwipeScale;
    
	// Rotate the cube under direct finger control, by directly rotating by the angle
	// and axis determined by the swipe. If the die cube is just to be directly controlled
	// by finger movement, and is not to freewheel, this is all we have to do.
	[aNode rotateByAngle: angle aroundAxis: axis];
    
	// To allow the cube to freewheel after lifting the finger, have the cube remember
	// the spin axis and spin speed. The spin speed is based on the angle rotated on
	// this event and the interval of time since the last event. Also mark that the
	// die cube is not freewheeling until the finger is lifted.
	aNode.isFreeWheeling = NO;
	aNode.spinAxis = axis;
	aNode.spinSpeed = angle / dt;
}

/**
 * This callback method is automatically invoked when a touchable 3D node is picked
 * by the user. If the touch event indicates that the user has raised the finger,
 * thus completing the touch action.
 *
 * If the UI is in "managing shadows" mode, each touch of an object cycles through
 * various shadowing options for the touched node. If not in "managing shadows" mode,
 * the actions described here occur.
 *
 * Most nodes are simply temporarily highlighted by running a Cocos2D tinting action on
 * the emission color property of the node (which affects the emission color property of
 * the materials underlying the node).
 *
 * Some nodes have other, or additional, behaviour. Nodes with special behaviour include
 * the ground, the die cube, the beach ball, the textured and rainbow teapots, and the wooden sign.
 */
-(void) nodeSelected: (CC3Node*) aNode byTouchEvent: (uint) touchType at: (CGPoint) touchPoint {
    
	// If in "managing shadows" mode, cycle through a variety of shadowing techniques.
	if (_isManagingShadows) {
		//[self cycleShadowFor: aNode];
		return;
	}
	
	// Remember the node that was selected
	_selectedNode = aNode;
	
	// Uncomment to toggle the display of a descriptor label on the node
    //	aNode.shouldDrawDescriptor = !aNode.shouldDrawDescriptor;
    
	// Briefly highlight the location where the node was touched.
	[self markTouchPoint: touchPoint on: aNode];
	
	if (!aNode) return;
    
//	if (aNode == _ground) {
//		[self touchGroundAt: touchPoint];
//	} else if (aNode == _beachBall) {
//		[self touchBeachBallAt: touchPoint];
//	} else if (aNode == _brickWall) {
//		[self touchBrickWallAt: touchPoint];
//	} else if (aNode == _woodenSign) {
//		[self switchWoodenSign];
//	} else if (aNode == _floatingHead) {
//		[self toggleFloatingHeadConfiguration];
//	} else
    if (aNode == _dieCube) {
		// These are spun by touch movement. Do nothing...and don't highlight
	}
}

/**
 * Unproject the 2D touch point into a 3D global-coordinate ray running from the camera through
 * the touched node. Find the node that is punctured by the ray, the location at which the ray
 * punctures the node's bounding volume in the local coordinates of the node, and add a temporary
 * visible marker at that local location that fades in and out, and then removes itself.
 */
-(void) markTouchPoint: (CGPoint) touchPoint on: (CC3Node*) aNode {
    
	if (!aNode) {
		LogInfo(@"You selected no node.");
		return;
	}
    
	// Get the location where the node was touched, in its local coordinates.
	// Normally, in this case, you would invoke nodesIntersectedByGlobalRay:
	// on the touched node, not on this CC3Scene. We do so here, to show that
	// all of the nodes under the ray will be detected, not just the touched node.
	CC3Ray touchRay = [self.activeCamera unprojectPoint: touchPoint];
	CC3NodePuncturingVisitor* puncturedNodes = [self nodesIntersectedByGlobalRay: touchRay];
	
	// The reported touched node may be a parent. We want to find the descendant node that
	// was actually pierced by the touch ray, so that we can attached a descriptor to it.
	CC3Node* localNode = puncturedNodes.closestPuncturedNode;
	CC3Vector nodeTouchLoc = puncturedNodes.closestPunctureLocation;
    
	// Create a descriptor node to display the location on the node
//	NSString* touchLocStr = [NSString stringWithFormat: @"(%.1f, %.1f, %.1f)", nodeTouchLoc.x, nodeTouchLoc.y, nodeTouchLoc.z];
//	CCLabelTTF* dnLabel = [CCLabelTTF labelWithString: touchLocStr
//											 fontName: @"Arial"
//											 fontSize: 8];
//	CC3Node* dn = [CC3NodeDescriptor nodeWithName: [NSString stringWithFormat: @"%@-TP", localNode.name]
//									withBillboard: dnLabel];
//	dn.color = localNode.initialDescriptorColor;
//    
//	// Use actions to fade the descriptor node in and then out, and remove it when done.
//	CCActionInterval* fadeIn = [CCActionFadeIn actionWithDuration: 0.2];
//	CCActionInterval* fadeOut = [CCActionFadeOut actionWithDuration: 5.0];
//	CCActionInstant* remove = [CC3ActionRemove action];
//	dn.opacity = 0;		// Start invisible
//	[dn runAction: [CCActionSequence actions: fadeIn, fadeOut, remove, nil]];
//	
//	// Set the location of the descriptor node to the touch location,
//	// which are in the touched node's local coordinates, and add the
//	// descriptor node to the touched node.
//	dn.location = nodeTouchLoc;
//	[localNode addChild: dn];
    
	// Log everything that happened.
	NSMutableString* desc = [NSMutableString stringWithCapacity: 500];
	[desc appendFormat: @"You selected %@", aNode];
	[desc appendFormat: @" located at %@", NSStringFromCC3Vector(aNode.globalLocation)];
	[desc appendFormat: @", or at %@ in 2D.", NSStringFromCC3Vector([self.activeCamera projectNode: aNode])];
	[desc appendFormat: @"\nThe actual node touched was %@", localNode];
	[desc appendFormat: @" at %@ on its boundary", NSStringFromCC3Vector(nodeTouchLoc)];
	[desc appendFormat: @" (%@ globally).", NSStringFromCC3Vector(puncturedNodes.closestGlobalPunctureLocation)];
	[desc appendFormat: @"\nThe nodes punctured by the ray %@ were:", NSStringFromCC3Ray(touchRay)];
	NSUInteger puncturedNodeCount = puncturedNodes.nodeCount;
	for (NSUInteger i = 0; i < puncturedNodeCount; i++) {
		[desc appendFormat: @"\n\t%@", [puncturedNodes puncturedNodeAt: i]];
		[desc appendFormat: @" at %@ on its boundary.", NSStringFromCC3Vector([puncturedNodes punctureLocationAt: i])];
		[desc appendFormat: @" (%@ globally).", NSStringFromCC3Vector([puncturedNodes globalPunctureLocationAt: i])];
	}
	LogInfo(@"%@", desc);
}


@end

