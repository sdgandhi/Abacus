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
    UIScrollView *leftView;
    NSMutableArray *leftViewContents;
    UIScrollView *rightView;
    NSMutableArray *rightViewContents;
    
    UIPopoverController *sourcesPopoverController;
    AdditionalSourcesViewController *additionalSourcesViewController;
}

@end
