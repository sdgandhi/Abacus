//
//  ViewController.m
//  Abacus
//
//  Created by Sidhant Gandhi on 1/24/14.
//  Copyright (c) 2014 Sidhant Gandhi. All rights reserved.
//


#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>


static NSInteger kItemViewIndex = 100;
static NSInteger kNumberOfButtons = 20;


@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void) layoutScrollView:(UIScrollView*)scrollView withContents:(NSMutableArray*)contents
{
    CGRect bounds = scrollView.bounds;
    __block CGRect contentBounds = bounds;
    NSLog(@"bottom view bounds bounds: %@",NSStringFromCGRect(contentBounds));

    
    CGSize margin = CGSizeMake(40.0, 15.0);
   // CGFloat itemWidth = bounds.size.width - 2 * margin.width;
  //  CGFloat itemHeight = itemWidth * 9 / 16.0;
    CGFloat x = margin.width;
    
    for (UIView *view in contents)
    {
        CGRect frame = CGRectMake(x, margin.height, view.frame.size.width, view.frame.size.height);
        view.frame = frame;
        
        x += view.frame.size.width + margin.width;
        
        contentBounds = CGRectUnion(contentBounds, view.frame);
        NSLog(@"Content bounds: %@", NSStringFromCGRect(contentBounds));
    }
    
   // scrollView.contentSize = contentBounds.size;
}


-(UIView *) createItemView : (int)indexOfView
{
    static CGFloat (^randFloat)(CGFloat, CGFloat) = ^(CGFloat min, CGFloat max) { return min + (max-min) * (CGFloat)random() / RAND_MAX; };
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, [xPositions[indexOfView] intValue], 120, 120)];
    itemView.backgroundColor = [UIColor colorWithHue:randFloat(0.0, 1.0) saturation:randFloat(0.5, 1.0) brightness:randFloat(0.3, 1.0) alpha:1.0];
    itemView.tag = kItemViewIndex++;
    return itemView;
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor greenColor];
    
    CGSize margin = CGSizeMake(40.0, 15.0);

    int x = margin.width;
    for (int i=0; i<kNumberOfButtons; i++)
    {
        [xPositions addObject:[NSNumber numberWithInt:x]];
        x += self.view.frame.size.width + margin.width;
        

    }
    
    //UIBarButtonItem *popoverItem = [[UIBarButtonItem alloc] initWithTitle:@"More Items" style:UIBarButtonItemStyleBordered target:self action:@selector(showMoreItems:)];
   // self.navigationItem.leftBarButtonItem = popoverItem;
    
    
    dragDropManager = [OBDragDropManager sharedManager];
    
    CGRect viewFrame = self.view.frame;
    CGRect frame = CGRectMake(0, viewFrame.size.height-407, viewFrame.size.width+400, 150);
    NSLog(@"test");
    //frame = CGRectInset(frame, 20.0, 20.0);
    bottomView = [[UIScrollView alloc] initWithFrame:frame];
  //  bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleRightMargin;
    bottomView.backgroundColor = [UIColor blueColor];
    bottomView.clipsToBounds = NO;
    bottomView.scrollEnabled = YES;
    //bottomView.pagingEnabled = YES;

   // bottomView.dropZoneHandler=self;
    
    
    frame = CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height-150);
    //frame = CGRectInset(frame, 20.0, 20.0);
    topView = [[UIView alloc] initWithFrame:frame];
    topView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    topView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.view addSubview:topView];
    [self.view addSubview:bottomView];

    topView.dropZoneHandler = self;
    
    
    bottomViewContents = [[NSMutableArray alloc] init];
    topViewContents = [[NSMutableArray alloc] init];
    
    for (NSInteger i=0; i<kNumberOfButtons; i++)
    {
        UIView *itemView = [self createItemView: i];
        [bottomViewContents addObject:itemView];
        [bottomView addSubview:itemView];
        
        UIGestureRecognizer *recognizer = [dragDropManager createDragDropGestureRecognizerWithClass:[UIPanGestureRecognizer class] source:self];
        [itemView addGestureRecognizer:recognizer];
    }
    
    [self layoutScrollView:bottomView withContents:bottomViewContents];
    //[self layoutScrollView:rightView withContents:rightViewContents];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void) viewDidLayoutSubviews
{
   // [self layoutScrollView:bottomView withContents:bottomViewContents];
  //  [self layoutScrollView:rightView withContents:rightViewContents];
}


-(NSInteger) insertionIndexForLocation:(CGPoint)location withContents:(NSArray*)contents
{
    CGFloat minDistance = CGFLOAT_MAX;
    NSInteger insertionIndex = 0;
    for (UIView *view in contents)
    {
        CGFloat locationToView = location.y - CGRectGetMidY(view.frame);
        if (locationToView > 0 && locationToView < minDistance)
        {
            minDistance = locationToView;
            insertionIndex = [contents indexOfObject:view] + 1;
        }
    }
    return insertionIndex;
}

#pragma mark - OBOvumSource

-(OBOvum *) createOvumFromView:(UIView*)sourceView
{
    OBOvum *ovum = [[OBOvum alloc] init];
    ovum.dataObject = [NSNumber numberWithInteger:sourceView.tag];
    ovum.dragView.frame = sourceView.frame;
    return ovum;
}


-(UIView *) createDragRepresentationOfSourceView:(UIView *)sourceView inWindow:(UIWindow*)window
{
    
    if([bottomViewContents containsObject:sourceView]){
        currentDragIndex= [bottomViewContents indexOfObject:sourceView];
    }
    else if ([topViewContents containsObject:sourceView])
    {
        currentDragIndex = [topViewContents indexOfObject:sourceView];
        sourceView.hidden=YES;
    }
    
    CGPoint locationInHostWindow = sourceView.frame.origin;
    NSArray *subviews = sourceView.subviews;
    NSLog(@"Create drag representation at location %@",NSStringFromCGPoint(locationInHostWindow));

    CGRect frame = [sourceView convertRect:sourceView.bounds toView:sourceView.window];
    frame = [window convertRect:frame fromWindow:sourceView.window];
    
    UIView *dragView = [[UIView alloc] initWithFrame:frame];
    dragView.backgroundColor = sourceView.backgroundColor;
    dragView.layer.cornerRadius = 5.0;
    dragView.layer.borderColor = [UIColor colorWithWhite:0.1 alpha:1.0].CGColor;
    dragView.layer.borderWidth = 1.0;
    dragView.alpha=0.9;
    dragView.layer.masksToBounds = YES;
    

    return dragView;
}


-(void) dragViewWillAppear:(UIView *)dragView inWindow:(UIWindow*)window atLocation:(CGPoint)location
{
    NSLog(@"drag view will appear");
    /*
    CGRect original = dragView.frame;
    dragView.transform = CGAffineTransformIdentity;
    dragView.alpha = 0.0;
    
    [UIView animateWithDuration:0.25 animations:^{
        dragView.center = location;
        dragView.transform = CGAffineTransformMakeScale(0.80, 0.80);
        dragView.alpha = 0.75;
    }
     completion:^(BOOL finished) {
     //    dragView.frame =CGRectMake(location.x, location.y, original.size.width, original.size.height);
     }];
     */
}






#pragma mark - OBDropZone

static NSInteger kLabelTag = 2323;

-(OBDropAction) ovumEntered:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
    NSLog(@"Ovum<0x%x> %@ Entered", (int)ovum, ovum.dataObject);
    
    //CGFloat red = 0.33 + 0.66 * location.y / self.view.frame.size.height;
    view.layer.borderColor = [UIColor blueColor].CGColor;
    view.layer.borderWidth = 2.0;
    
    CGRect labelFrame = CGRectMake(ovum.dragView.bounds.origin.x, ovum.dragView.bounds.origin.y, ovum.dragView.bounds.size.width, ovum.dragView.bounds.size.height / 2);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    //label.text = @"Ovum entered";
    label.tag = kLabelTag;
    label.backgroundColor = [UIColor clearColor];
    label.opaque = NO;
    label.font = [UIFont boldSystemFontOfSize:24.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [ovum.dragView addSubview:label];
    
    return OBDropActionMove;
}

-(OBDropAction) ovumMoved:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
   //  NSLog(@"Ovum<0x%x> %@ Moved. In view %@", (int)ovum, ovum.dataObject, view);
    
   // CGFloat hiphopopotamus = 0.33 + 0.66 * location.y / self.view.frame.size.height;
    
    // This tester currently only supports dragging from left to right view
    /*
    if ([ovum.dataObject isKindOfClass:[NSNumber class]])
    {
        UIView *itemView = [self.view viewWithTag:[ovum.dataObject integerValue]];
        if ([topViewContents containsObject:itemView])
        {
            view.layer.borderColor = [UIColor colorWithRed:hiphopopotamus green:0.0 blue:0.0 alpha:1.0].CGColor;
            view.layer.borderWidth = 5.0;
            
            UILabel *label = (UILabel*) [ovum.dragView viewWithTag:kLabelTag];
            label.text = @"Cannot Drop Here";
            
            return OBDropActionNone;
        }
    }*/
    
    //view.layer.borderColor = [UIColor colorWithRed:0.0 green:hiphopopotamus blue:0.0 alpha:1.0].CGColor;
    //view.layer.borderWidth = 5.0;
    
    //UILabel *label = (UILabel*) [ovum.dragView viewWithTag:kLabelTag];
    //label.text = [NSString stringWithFormat:@"Ovum at %@", NSStringFromCGPoint(location)];
    
    return OBDropActionMove;
}

-(void) ovumExited:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
    NSLog(@"Ovum<0x%x> %@ Exited", (int)ovum, ovum.dataObject);
    
    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.borderWidth = 0.0;
    
    UILabel *label = (UILabel*) [ovum.dragView viewWithTag:kLabelTag];
    [label removeFromSuperview];
}

-(void) ovumDropped:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
    NSLog(@"Ovum<0x%x> %@ Dropped. In view: %@. At Location: %@", (int)ovum, ovum.dataObject,view, NSStringFromCGPoint(location));
    view.hidden=NO;
    
    NSLog(@"Ovum tag is :%@",ovum.tag);
    
    ovum.dragView.hidden=NO;

    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.borderWidth = 0.0;
    
    UILabel *label = (UILabel*) [ovum.dragView viewWithTag:kLabelTag];
    [label removeFromSuperview];
    
    
    UIView *itemView = [self.view viewWithTag:[ovum.dataObject integerValue]];
    
    
    
    NSInteger insertionIndex = [self insertionIndexForLocation:location withContents:topViewContents];
    
    if (itemView)
    {
        if(location.y<600) //Dropped in top view
        {
            [itemView removeFromSuperview];
            NSLog(@"index of item view: %i",currentDragIndex);
            [bottomViewContents removeObject:itemView];
            
            [topView insertSubview:itemView atIndex:insertionIndex];
            [topViewContents insertObject:itemView atIndex:insertionIndex];
            
            if(bottomViewContents.count<20){
            UIView *itemView2 = [self createItemView: currentDragIndex];
            [bottomViewContents insertObject:itemView2 atIndex:currentDragIndex];

            [bottomView insertSubview:itemView2 atIndex:currentDragIndex];

            
            UIGestureRecognizer *recognizer = [dragDropManager createDragDropGestureRecognizerWithClass:[UIPanGestureRecognizer class] source:self];
            [itemView2 addGestureRecognizer:recognizer];
            }

            /*
            UIView *itemView = [self createItemView: index];
            [bottomViewContents addObject:itemView];
            [bottomView addSubview:itemView];
            
            // Drag drop with long press gesture
            //UIGestureRecognizer *recognizer = [dragDropManager createLongPressDragDropGestureRecognizerWithSource:self];
            // Drag drop with pan gesture
            UIGestureRecognizer *recognizer = [dragDropManager createDragDropGestureRecognizerWithClass:[UIPanGestureRecognizer class] source:self];
            [itemView addGestureRecognizer:recognizer];*/
        }
        else  //dropped in bottom view
        {
            if([topViewContents containsObject:itemView]){
            [itemView removeFromSuperview];
            [topViewContents removeObject:itemView];
            }
            else
            {
               
            }
            
            //[bottomView insertSubview:itemView atIndex:insertionIndex];
           // [bottomViewContents insertObject:itemView atIndex:insertionIndex];
            
            
        }
        
    }
}


-(void) handleDropAnimationForOvum:(OBOvum*)ovum withDragView:(UIView*)dragView dragDropManager:(OBDragDropManager*)dragDropManager
{
    NSLog(@"Called handleDropAnimationForOvum");
    UIView *itemView =[self.view viewWithTag:[ovum.dataObject integerValue]];
    itemView.hidden=NO;
    
    if (itemView)
    {
        // Set the initial position of the view to match that of the drag view
        CGRect dragViewFrameInTargetWindow = [ovum.dragView.window convertRect:dragView.frame toWindow:topView.window];
        dragViewFrameInTargetWindow = [topView convertRect:dragViewFrameInTargetWindow fromView:topView.window];
        itemView.frame = dragViewFrameInTargetWindow;
        
        CGRect viewFrame = [ovum.dragView.window convertRect:itemView.frame fromView:itemView.superview];
       // dragView.frame = viewFrame;
       // itemView.frame = CGRectMake([xPositions[currentDragIndex] intValue], 120, itemView.frame.size.width, itemView.frame.size.height);
      //  CGRect frame = CGRectMake(x, margin.height, view.frame.size.width, view.frame.size.height);
        //view.frame = frame;
        dragView.frame = viewFrame;
        
        [self layoutScrollView:bottomView withContents:bottomViewContents];


        void (^animation)() = ^{
            //[self layoutScrollView:rightView withContents:rightViewContents];
        };
        
        [dragDropManager animateOvumDrop:ovum withAnimation:animation completion:nil];
    }
}






/*

-(IBAction) showMoreItems:(id)sender
{
    if (additionalSourcesViewController == nil)
    {
        additionalSourcesViewController = [[AdditionalSourcesViewController alloc] initWithNibName:nil bundle:nil];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        additionalSourcesViewController.contentSizeForViewInPopover = CGSizeMake(320, 480);
        sourcesPopoverController = [[UIPopoverController alloc] initWithContentViewController:additionalSourcesViewController];
        sourcesPopoverController.delegate = self;
        [sourcesPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        sourcesPopoverController.passthroughViews = nil;
    }
    else {
        // iPhone case
        if (additionalSourcesViewController.view.superview != self.view)
        {
            additionalSourcesViewController.view.alpha = 0.0;
            additionalSourcesViewController.view.frame = self.view.bounds;
            [self.view addSubview:additionalSourcesViewController.view];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            additionalSourcesViewController.view.alpha = 1.0;
        }];
    }
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == sourcesPopoverController)
    {
        sourcesPopoverController = nil;
    }
}
*/
@end
