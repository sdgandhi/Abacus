//
//  ViewController.h
//  Abacus
//
//  Created by Sidhant Gandhi on 1/24/14.
//  Copyright (c) 2014 Sidhant Gandhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBDragDrop.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"


@interface ViewController : UIViewController <OBOvumSource, OBDropZone, UIPopoverControllerDelegate, NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
    UIScrollView *bottomView;
    NSMutableArray *bottomViewContents;
    UIView *topView;
    NSMutableArray *topViewContents;
    
    UIPopoverController *sourcesPopoverController;
    OBDragDropManager *dragDropManager;
    
    NSMutableArray *xPositions;
    int currentDragIndex;
    
    CAShapeLayer *currentDragLine;
    
    NSMutableArray *colorArray;
}

@end
