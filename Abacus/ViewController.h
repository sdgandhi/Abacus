//
//  ViewController.h
//  Abacus
//
//  Created by Sidhant Gandhi on 1/24/14.
//  Copyright (c) 2014 Sidhant Gandhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBDragDrop.h"
#import "AdditionalSourcesViewController.h"

@interface ViewController : UIViewController <OBOvumSource, OBDropZone, UIPopoverControllerDelegate>
{
    UIScrollView *bottomView;
    NSMutableArray *bottomViewContents;
    UIView *topView;
    NSMutableArray *topViewContents;
    
    UIPopoverController *sourcesPopoverController;
    AdditionalSourcesViewController *additionalSourcesViewController;
}

@end
