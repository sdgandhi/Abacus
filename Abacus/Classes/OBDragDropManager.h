//
//  OBDragDropManager.h
//  OBUserInterface
//
//  Created by Zai Chang on 2/23/12.
//  Copyright (c) 2012 Oblong Industries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBDragDropProtocol.h"
#import "OBLongPressDragDropGestureRecognizer.h"
#import <QuartzCore/QuartzCore.h>


// NSNotifications that gets broadcasted when a drag and drop has started or ended
#define OBDragDropManagerWillBeginDragNotification @"OBDragDropManagerWillBeginDrag"
#define OBDragDropManagerDidEndDragNotification @"OBDragDropManagerDidEndDrag"

#define OBOvumDictionaryKey @"ovum"

// OBOvum represents a data object that is being dragged around a UI window, named
// after the g-speak equivalent within the Ovipositor infrastructure.
// It also is responsible for keeping track of the drag view (a visual representation
// of the ovum)
@interface OBOvum : NSObject
{
@private
  id<OBOvumSource> __weak source;
  id dataObject;
  NSString *tag;
  
  // Current drop action and target
  OBDropAction dropAction;
  UIView *__weak currentDropHandlingView;
  
  UIView *dragView; // View to represent the dragged object
  CGPoint dragViewInitialCenter;
  BOOL isCentered;
  BOOL shouldScale;
}
@property (nonatomic, weak) id<OBOvumSource> source;
@property (nonatomic, strong) id dataObject;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, assign) OBDropAction dropAction;

// The drop target that the ovum is currenly over
@property (nonatomic, weak) UIView *currentDropHandlingView;
@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, assign) CGPoint dragViewInitialCenter;
@property (nonatomic, assign) BOOL isCentered;
@property (nonatomic, assign) BOOL shouldScale;


@property (nonatomic, strong)UIView *mainView;

// node properties
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSMutableArray *values;
@property (nonatomic, strong) NSMutableArray *input;
@property (nonatomic, strong) NSMutableArray *output;
@property (nonatomic,weak) CAShapeLayer *outputLine;



@property (nonatomic, assign) CGPoint offsetOvumAndTouch;
@property (nonatomic, assign) CGPoint shiftPinchCentroid;
@property (nonatomic, assign) CGFloat scale;

-(id)initWithType:(NSString *)type;
-(NSString*) toJSON;

-(void)addOutputNode:(OBOvum *)newOutputNode;

-(void)addInputNode:(OBOvum *)newOutputNode;
-(void)deleteOvum;

-(void)testMethod;
-(NSString *)getLabel;
-(int)getIndexOfOvum;

-(void)setLabel:(NSString *)label;
-(void)setTypeLabel:(NSString *)label;
@end



@interface OBDragDropManager : NSObject <UIGestureRecognizerDelegate>
{
  NSInteger prevNumberOfTouches;
  CGPoint prevPinchCentroid;
  CGFloat initialDistance;
  CGRect initialFrame;
}

@property (nonatomic, strong) UIWindow *overlayWindow;
@property (nonatomic, assign) CGPoint currentLocationInHostWindow;
@property (nonatomic, assign) CGPoint currentLocationInOverlayWindow;

@property (nonatomic,strong)NSMutableArray *ovumList;

+(OBDragDropManager *) sharedManager;

// This should be called in during the initialization of the app to prepare the
// drag and drop overlay window
-(void) prepareOverlayWindowUsingMainWindow:(UIWindow*)mainWindow;

// Creates and registers a gesture recognizer for drag and drop
// Note that this should be a continuous gesture such as pan or long press
-(UIGestureRecognizer *) createDragDropGestureRecognizerWithClass:(Class)recognizerClass source:(id<OBOvumSource>)source;

// Can be deprecated in favor of the above API
-(OBLongPressDragDropGestureRecognizer*) createLongPressDragDropGestureRecognizerWithSource:(id<OBOvumSource>)source;

-(void) animateOvumDrop:(OBOvum*)ovum withAnimation:(void (^)()) dropAnimation completion:(void (^)(BOOL completed))completion;

-(void) updateOvum:(OBOvum *)ovum withZoom:(CGFloat)zoom;
-(void)cleanupOvum:(OBOvum *)ovum;
-(OBOvum *)getOvumWithTag:(int)tag;

@end

