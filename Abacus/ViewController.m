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

    
    CGSize margin = CGSizeMake(50.0, 15.0);
   // CGFloat itemWidth = bounds.size.width - 2 * margin.width;
  //  CGFloat itemHeight = itemWidth * 9 / 16.0;
    CGFloat x = margin.width;
    
    for (UIView *view in contents)
    {
        CGRect frame = CGRectMake(x, margin.height, view.frame.size.width, view.frame.size.height);
        view.frame = frame;
        
        x += view.frame.size.width + margin.width;
        
        contentBounds = CGRectUnion(contentBounds, view.frame);
       // NSLog(@"Content bounds: %@", NSStringFromCGRect(contentBounds));
    }
    
    scrollView.contentSize = contentBounds.size;
}

-(void)createColorArray
{
    NSInteger numberOfColors = kNumberOfButtons;
    colorArray = [[NSMutableArray alloc]init];
    for (int i=0; i<numberOfColors; i++)
    {
        static CGFloat (^randFloat)(CGFloat, CGFloat) = ^(CGFloat min, CGFloat max) { return min + (max-min) * (CGFloat)random() / RAND_MAX; };
         [colorArray addObject: [UIColor colorWithHue:randFloat(0.0, 1.0) saturation:randFloat(0.5, 1.0) brightness:randFloat(0.3, 1.0) alpha:1.0]];

    }
}

-(UIView *) createItemView : (int)indexOfView
{
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, [xPositions[indexOfView] intValue], 180, 120)];
    
    
    itemView.backgroundColor = colorArray[indexOfView];
    [itemView.layer setCornerRadius:8];
    [itemView.layer setBorderWidth:5.0];
    CGFloat hue;
    CGFloat sat;
    CGFloat bright;
    CGFloat alpha;
    [itemView.backgroundColor getHue:&hue saturation:&sat brightness:&bright alpha:&alpha];
    itemView.layer.borderColor = [UIColor colorWithHue:hue saturation:sat brightness:bright-0.2 alpha:alpha].CGColor;
    itemView.tag = kItemViewIndex++;
    
    UIView *linkView = [[UIView alloc]initWithFrame:CGRectMake(itemView.frame.size.width-44, itemView.frame.size.height-44, 44, 44)];
    
    [linkView.layer setCornerRadius:3.0];
    linkView.backgroundColor = [UIColor colorWithHue:hue saturation:sat brightness:bright-0.2 alpha:alpha];
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(recognizeLinkDrag:)];
    linkView.tag =indexOfView;
    [linkView addGestureRecognizer:recognizer];
    
    [itemView addSubview:linkView];

    UIView *inputView = [[UIView alloc]initWithFrame:CGRectMake(0, itemView.frame.size.height-44, 44, 44)];
    
    [inputView.layer setCornerRadius:3.0];
    inputView.backgroundColor = [UIColor colorWithHue:hue saturation:sat brightness:bright-0.2 alpha:alpha];
    [itemView addSubview:inputView];
    
    UILabel *nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, itemView.frame.size.width-20, itemView.frame.size.height-54)];
    nameLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:35];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text=@"test fdsajkfhdkjshafkdjhfsakljdhfjkasd";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.lineBreakMode =NSLineBreakByWordWrapping;
    nameLabel.adjustsFontSizeToFitWidth=YES;
    nameLabel.numberOfLines=2;
    [itemView addSubview:nameLabel];

    
    

    return itemView;
}

-(IBAction)recognizeLinkDrag:(UIPanGestureRecognizer *)recognizer
{
    UIView *senderView =recognizer.view ;
    UIView *senderMainView =recognizer.view.superview;

    OBOvum *inputterOvum;

    for(OBOvum *ovum in dragDropManager.ovumList)
    {
        if (ovum.mainView == senderMainView)
        {
            inputterOvum = ovum;
        }
    }
        
    CGPoint location = [senderView.superview convertPoint:senderView.frame.origin toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    
    CGPoint translation = [recognizer translationInView:senderView];
   // CGPoint position = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
  //  [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    CGPoint pointOne = CGPointMake(location.x+senderView.frame.size.width-22, location.y+22);
    CGPoint pointTwo = CGPointMake(pointOne.x +translation.x, pointOne.y +translation.y);
    //NSLog(@"Point one : %@",NSStringFromCGPoint(pointOne));
    //NSLog(@"Point two : %@",NSStringFromCGPoint(pointTwo));


    //NSLog(@"senderview location is %@",NSStringFromCGPoint(location));
                          
  /*  if(recognizer.state == UIGestureRecognizerStateBegan)
    {//start drawing line
        NSLog(@"Gesture began");
       // UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(itemView.frame.size.width-22, 60, 1, 1)];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(location.x+senderView.frame.size.width-22, location.y+22)];
        [path addLineToPoint:CGPointMake(100.0, 100.0)];
        [currentDragLine removeFromSuperlayer];
        currentDragLine = [CAShapeLayer layer];

        currentDragLine.path = [path CGPath];
        currentDragLine.strokeColor = [[UIColor blueColor] CGColor];
        currentDragLine.lineWidth = 3.0;
        currentDragLine.fillColor = [[UIColor clearColor] CGColor];
        
        [self.view.layer addSublayer:currentDragLine];

        
    }*/
    [currentDragLine removeFromSuperlayer];

    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"Gesture ended");
        OBOvum *droppedInOvum = [self findDroppedInOvum:pointTwo];
        BOOL alreadyConnected = [inputterOvum.output containsObject:droppedInOvum];

        if(droppedInOvum && droppedInOvum!=inputterOvum && !alreadyConnected)
        {
            NSLog(@"Found ovum: %@. Inputter is: %@",droppedInOvum, inputterOvum);
            
            [inputterOvum addOutputNode:droppedInOvum];
            NSLog(@"New output nodes for inputter: %@",inputterOvum.output);
            
            
            [droppedInOvum addInputNode:inputterOvum];
            NSLog(@"New input nodes for output: %@",droppedInOvum.input);
             location = [droppedInOvum.mainView.superview convertPoint:droppedInOvum.mainView.frame.origin toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];

             pointTwo = CGPointMake(location.x+22, location.y+droppedInOvum.mainView.frame.size.height-22);

            UIView *outputView = droppedInOvum.mainView;
            UIView *outputSubview = [outputView subviews][0];
            NSLog(@"outputSubview: %@",outputSubview);
            CGPoint outputTarget = outputSubview.center;

            UIBezierPath *path = [UIBezierPath bezierPath];
            
            [path moveToPoint:pointOne];
            [path addLineToPoint:pointTwo];
           CAShapeLayer* dragLine= [CAShapeLayer layer];
            
            dragLine.path = [path CGPath];
            dragLine.strokeColor = [[UIColor blueColor] CGColor];
            dragLine.lineWidth = 3.0;
            dragLine.fillColor = [[UIColor clearColor] CGColor];

            
            
            inputterOvum.outputLine = dragLine;
            NSLog(@"recognizer line2: %@",inputterOvum.outputLine);

            [self.view.layer addSublayer:inputterOvum.outputLine];


            
            
        }
    
    }
    else
    {

        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:pointOne];
        [path addLineToPoint:pointTwo];
        currentDragLine = [CAShapeLayer layer];
        
        currentDragLine.path = [path CGPath];
        currentDragLine.strokeColor = [[UIColor blueColor] CGColor];
        currentDragLine.lineWidth = 3.0;
        currentDragLine.fillColor = [[UIColor clearColor] CGColor];
        
        [self.view.layer addSublayer:currentDragLine];

    }
    //NSLog(@"Recognized link drag!");
    
    
}

- (OBOvum *)getOvumHead {
    for(OBOvum *ovum in dragDropManager.ovumList)
    {
        if (ovum.output.count == 0)
        {
            return ovum;
        }
    }
    return NULL;
}

- (void)cloudBoost {
    NSString *jsonRequest = [[self getOvumHead] toJSON];
    
    NSURL *url = [NSURL URLWithString:@"http://default-environment-c3nuuemgkx.elasticbeanstalk.com/"];
    //NSURL *url = [NSURL URLWithString:@"10.55.51.229:8080"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - NSURLDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
    NSString *a = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
    
    NSLog(@"Response Data: %@", a);
    
    [self getOvumHead].values[0] = a;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor greenColor];
    [self createColorArray];
    currentDragLine = [CAShapeLayer layer];

    CGSize margin = CGSizeMake(50.0, 15.0);

    int x = margin.width;
    for (int i=0; i<kNumberOfButtons; i++)
    {
        [xPositions addObject:[NSNumber numberWithInt:x]];
        x += self.view.frame.size.width + margin.width;

    }
    
    
    // GO BUTTON!
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self
               action:@selector(cloudBoost)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Go" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [topView addSubview:button];
    
    //UIBarButtonItem *popoverItem = [[UIBarButtonItem alloc] initWithTitle:@"More Items" style:UIBarButtonItemStyleBordered target:self action:@selector(showMoreItems:)];
   // self.navigationItem.leftBarButtonItem = popoverItem;
    
    
    dragDropManager = [OBDragDropManager sharedManager];
    
    CGRect viewFrame = self.view.frame;
    CGRect frame = CGRectMake(0, viewFrame.size.height-406, viewFrame.size.width+400, 150);
    NSLog(@"frame size is: %@",NSStringFromCGRect(frame));
    
    //frame = CGRectInset(frame, 20.0, 20.0);
    bottomView = [[UIScrollView alloc] initWithFrame:frame];
  //  bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleRightMargin;
    bottomView.backgroundColor = [UIColor lightGrayColor];
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
        [itemView setClipsToBounds:YES];
        
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
    for(OBOvum* ovum in dragDropManager.ovumList)
    {
        if (ovum.mainView == sourceView) {
            NSLog(@"Found old ovum, reusing");
            return ovum;
        }
    }
    
    OBOvum *newOvum = [[OBOvum alloc] init];
    
    newOvum.dataObject = [NSNumber numberWithInteger:sourceView.tag];
    newOvum.dragView.frame = sourceView.frame;
    newOvum.mainView= sourceView;
    
    if([newOvum getIndexOfOvum] == 0){
        [newOvum setType:@"yahoo-finance"];
    } else if ([newOvum getIndexOfOvum] == 1){
        [newOvum setType:@"max"];
    } else if ([newOvum getIndexOfOvum] == 2){
        [newOvum setType:@"min"];
    } else if ([newOvum getIndexOfOvum] == 3){
        [newOvum setType:@"avg"];
    } else if ([newOvum getIndexOfOvum] == 4){
        [newOvum setType:@"extract"];
        [newOvum setValues:[NSMutableArray arrayWithObjects:@"High", nil]];
    }
    
    NSLog(@"new ovum mainview : %@", newOvum.mainView);
    NSLog(@"Couldn't find old ovum, creating new");

 //   [newOvum testMethod];
    return newOvum;
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
    //NSArray *subviews = sourceView.subviews;
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

-(OBOvum *)findDroppedInOvum:(CGPoint)dropSpot
{
   // NSLog(@"dragDropManager.ovumList: %@",dragDropManager.ovumList);
    
    
    for (UIView *view in topViewContents)
    {
        if (CGRectContainsPoint(view.frame, dropSpot)) {
            for(OBOvum* ovum in dragDropManager.ovumList)
            {
                if(view.tag == [ovum.dataObject intValue])
                {
                    return ovum;
                }
            }
            
           
        }
    }
    
    return nil;
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
    NSLog(@"Ovum<0x%x> %@ Entered. # %i", (int)ovum, ovum.dataObject, ovum.getIndexOfOvum);
    
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
    //[ovum.dragView addSubview:label];
    
    return OBDropActionMove;
}

-(OBDropAction) ovumMoved:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
     NSLog(@"Ovum<0x%x> %@ Moved. In view %@", (int)ovum, ovum.dataObject, view);
    
    NSMutableArray *inputNodes = ovum.input;
    NSMutableArray *outputNodes = ovum.output;
    
    for(OBOvum * ovumLoop in inputNodes)
    {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        // [path moveToPoint:pointOne];
        //[path addLineToPoint:pointTwo];
        currentDragLine = [CAShapeLayer layer];
        
        currentDragLine.path = [path CGPath];
        currentDragLine.strokeColor = [[UIColor blueColor] CGColor];
        currentDragLine.lineWidth = 3.0;
        currentDragLine.fillColor = [[UIColor clearColor] CGColor];
        
        [self.view.layer addSublayer:currentDragLine];

        
    }
    
    
    
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
    UIView *itemView = ovum.dragView;
    [UIView animateWithDuration:0.25 animations:^{
        itemView.alpha=0.5;
        itemView.frame = CGRectInset(itemView.frame, itemView.frame.size.width-40, itemView.frame.size.height-40);

    }completion:^(BOOL finished) {
        
        OBDragDropManager *manager = [OBDragDropManager sharedManager];
        NSLog(@"pre remove ovumlist: %@",manager.ovumList);
        [manager.ovumList removeObject:ovum];
        if([topViewContents containsObject:itemView]){
            [[itemView subviews]
             makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [itemView removeFromSuperview];
            [topViewContents removeObject:itemView];
            
        }

    }];
    

    
    //UILabel *label = (UILabel*) [ovum.dragView viewWithTag:kLabelTag];
    //[label removeFromSuperview];
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
        NSLog(@"test");
        if(location.y<600) //Dropped in top view
        {
            [itemView removeFromSuperview];
            NSLog(@"Dropped in top view. Index of item view: %i",currentDragIndex);
            [bottomViewContents removeObject:itemView];
            
            [topView insertSubview:itemView atIndex:insertionIndex];
            [topViewContents insertObject:itemView atIndex:insertionIndex];
            
            if(bottomViewContents.count<20){
                NSLog(@"triggered");
                UIView *itemView2 = [self createItemView: currentDragIndex];
                [bottomViewContents insertObject:itemView2 atIndex:currentDragIndex];
                
                [bottomView insertSubview:itemView2 atIndex:currentDragIndex];
                
                
                UIGestureRecognizer *recognizer = [dragDropManager createDragDropGestureRecognizerWithClass:[UIPanGestureRecognizer class] source:self];
                [itemView2 addGestureRecognizer:recognizer];
            //    if([ovum.type isEqualToString:@"val"])
             //   {
               //     [self editOvumText:ovum];
                //}
                
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
       /* else  //dropped in bottom view
        {
            if([topViewContents containsObject:itemView]){
            [itemView removeFromSuperview];
            [topViewContents removeObject:itemView];
                
            }
            OBDragDropManager *manager = [OBDragDropManager sharedManager];
            NSLog(@"pre remove ovumlist: %@",manager.ovumList);
            [manager.ovumList removeObject:ovum];
            NSLog(@"post remove ovumlist: %@",manager.ovumList);


            //[bottomView insertSubview:itemView atIndex:insertionIndex];
           // [bottomViewContents insertObject:itemView atIndex:insertionIndex];
            
            
        }*/
        
    }
}
/*
-(void)editOvumText:(OBOvum *)ovum
{
    NSLog(@"Called editOvumText on %@",ovum);
  //  CGRect frame = [ovum.mainView convertRect:ovum.mainView.bounds toView:ovum.mainView.window];
    //frame = [window convertRect:frame fromWindow:ovum.mainView.window];

    UITextField *textField = [[UITextField alloc] initWithFrame:ovum.mainView.frame];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = @"";
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.returnKeyType = UIReturnKeyDone;
    textField.backgroundColor= [UIColor clearColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    [ovum.mainView addSubview:textField];
    [textField becomeFirstResponder];
    
}*/

-(void) handleDropAnimationForOvum:(OBOvum*)ovum withDragView:(UIView*)dragView dragDropManager:(OBDragDropManager*)dragDropManager
{
    NSLog(@"Called handleDropAnimationForOvum");
    UIView *itemView =[self.view viewWithTag:[ovum.dataObject integerValue]];
    itemView.hidden=NO;
    ovum.mainView.frame = dragView.frame;

    
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
        //ovum.mainView.frame = viewFrame;
        
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
