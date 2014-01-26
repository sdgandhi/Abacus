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
static NSInteger kNumberOfButtons = 8;


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
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.lineBreakMode =NSLineBreakByTruncatingTail;
    nameLabel.adjustsFontSizeToFitWidth=YES;
    nameLabel.numberOfLines=2;
    [itemView addSubview:nameLabel];

    
     UILabel *typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(46, itemView.frame.size.height-44, itemView.frame.size.width-92, 44)];
    typeLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:20];
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.lineBreakMode =NSLineBreakByTruncatingTail;
    typeLabel.adjustsFontSizeToFitWidth=YES;
    typeLabel.numberOfLines=2;

    typeLabel.adjustsFontSizeToFitWidth=YES;
    if(indexOfView==0)
        typeLabel.text=@"VAL";
    if(indexOfView==1)
        typeLabel.text=@"OP";
    if(indexOfView==2)
        typeLabel.text=@"MAX";
    if(indexOfView==3)
        typeLabel.text=@"MIN";
    if(indexOfView==4)
        typeLabel.text=@"AVG";
    if(indexOfView==5)
        typeLabel.text=@"EXTRACT";
    if(indexOfView==6)
        typeLabel.text=@"Y! $$";
    if(indexOfView==7)
        typeLabel.text=@"RANGE";

    [itemView addSubview:typeLabel];


    
    

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

            [self.view.layer addSublayer:dragLine];
            
            if (inputterOvum.output.count>0) {
                
                OBOvum *outputOvum = inputterOvum.output[0];
                
                if(outputOvum.input.count>1)
                {
                    NSLog(@"Test");
                    [self updateOvumValue:outputOvum];
                }

            }
            
            
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
    NSMutableString *jsonRequest = [[NSMutableString alloc] initWithString:@"["];
    [jsonRequest appendString:[[self getOvumHead] toJSON]];
    [jsonRequest appendString:@"]"];
    //[jsonRequest appendString:@",{\"res\": 1,\"vars\": [{\"symbol\": \"x\",\"start\": 4,\"end\": 5}]}"];
    
    NSLog(@"json object: %@", jsonRequest);
    
    NSURL *url = [NSURL URLWithString:@"http://default-environment-c3nuuemgkx.elasticbeanstalk.com/"];
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
    NSError *error = nil;

    //NSArray *results = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&error];
    //NSLog(@"result is: %@", results[0]);
    //[self getOvumHead].values[0] = results[0];
    NSLog(@"result is: %@", a);
    [self getOvumHead].values[0] = a;
    NSLog(@"ovum head value is %@",   [self getOvumHead].values[0]);
    OBOvum *ovum = [self getOvumHead];
    [self updateOvumValue:ovum];
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
    bottomView.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom_wood_texture.png"]];
    //bottomView.pagingEnabled = YES;

   // bottomView.dropZoneHandler=self;
    
    
    frame = CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height-150);
    //frame = CGRectInset(frame, 20.0, 20.0);
    topView = [[UIView alloc] initWithFrame:frame];
    topView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    topView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    
    // GO BUTTON!
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor=[UIColor blueColor];

    [button addTarget:self
               action:@selector(cloudBoost)
     forControlEvents:UIControlEventTouchUpInside];
    button.tintColor= [UIColor whiteColor];
    [button setTitle:@"GO!" forState:UIControlStateNormal];
    button.frame = CGRectMake(15, 25, 65, 65);
    button.titleLabel.font =  [UIFont fontWithName:@"AvenirNext-Medium" size:20];
    button.layer.cornerRadius = 8.0;

    [topView addSubview:button];
    
    
    //UIBarButtonItem *popoverItem = [[UIBarButtonItem alloc] initWithTitle:@"More Items" style:UIBarButtonItemStyleBordered target:self action:@selector(showMoreItems:)];
    // self.navigationItem.leftBarButtonItem = popoverItem;

    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clearButton.backgroundColor=[UIColor redColor];
    [clearButton addTarget:self
               action:@selector(clearTop)
     forControlEvents:UIControlEventTouchUpInside];
    clearButton.tintColor= [UIColor whiteColor];
    clearButton.titleLabel.font =  [UIFont fontWithName:@"AvenirNext-Medium" size:20];
    clearButton.layer.cornerRadius = 8.0;

    [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    clearButton.frame = CGRectMake(95, 25, 65, 65);
    [topView addSubview:clearButton];

    
    [self.view addSubview:topView];
    [self.view addSubview:bottomView];
    NSLog(@"Bottom view size is :%@", NSStringFromCGRect(bottomView.frame));

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
        [newOvum setType:@"val"];
    } else if ([newOvum getIndexOfOvum] == 1){
        [newOvum setType:@"op"];
    } else if ([newOvum getIndexOfOvum] == 2){
        [newOvum setType:@"max"];
    } else if ([newOvum getIndexOfOvum] == 3){
        [newOvum setType:@"min"];
    } else if ([newOvum getIndexOfOvum] == 4){
        [newOvum setType:@"avg"];
    }
    else if ([newOvum getIndexOfOvum] == 5){
        [newOvum setType:@"extract"];
        [newOvum setValues:[NSMutableArray arrayWithObjects:@"High", nil]];

    }
    else if ([newOvum getIndexOfOvum] == 6)
    {
        [newOvum setType:@"yahoo-finance"];

    }
    else if([newOvum getIndexOfOvum] == 7)
    {
        [newOvum setType:@"range"];
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
    
 
        //[ovum.dragView addSubview:label];
    
    return OBDropActionMove;
}

-(OBDropAction) ovumMoved:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
     NSLog(@"Ovum<0x%x> %@ Moved. In view %@", (int)ovum, ovum.dataObject, view);
    /*
    NSMutableArray *inputNodes = ovum.input;
    NSMutableArray *outputNodes = [NSMutableArray arrayWithArray:ovum.output];
    if(ovum.outputLine){
        for (int i=0; i<self.view.layer.sublayers.count; i++) {
            if(i>1){
                CALayer *layer = self.view.layer.sublayers[i];

                [layer removeFromSuperlayer];}
    }}

    for(OBOvum * ovumLoop in dragDropManager.ovumList)
    {
        
       
        if(outputNodes.count>0)
        {
           for(OBOvum *outputter in outputNodes)
           {
               
//            CGPoint location = [senderView.superview convertPoint:senderView.frame.origin toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];

  //          CGPoint translation = [recognizer translationInView:senderView];
               CGPoint location = [senderView.superview convertPoint:senderView.frame.origin toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
               
               CGPoint pointOne = CGPointMake(location.x+senderView.frame.size.width-22, location.y+22);
               CGPoint pointTwo = CGPointMake(pointOne.x +translation.x, pointOne.y +translation.y);

               
               
        CGPoint pointOne = CGPointMake(ovumLoop.mainView.frame.origin.x + ovumLoop.mainView.frame.size.width- 22, ovumLoop.mainView.frame.origin.y + ovumLoop.mainView.frame.size.height-22);
        
               CGPoint pointTwo = CGPointMake(outputter.dragView.frame.origin.x +22, ovumLoop.dragView.frame.origin.y + ovumLoop.dragView.frame.size.height-22);

        UIBezierPath *path = [UIBezierPath bezierPath];
        
         [path moveToPoint:pointOne];
        [path addLineToPoint:pointTwo];
        CAShapeLayer *dragLine = [CAShapeLayer layer];
        
        dragLine.path = [path CGPath];
        dragLine.strokeColor = [[UIColor blueColor] CGColor];
        dragLine.lineWidth = 3.0;
        dragLine.fillColor = [[UIColor clearColor] CGColor];
        
        [self.view.layer addSublayer:dragLine];

        }}
    }
    */
    
    
    return OBDropActionMove;
}

-(void)clearTop
{
    if(dragDropManager.ovumList.count>0){
        
        NSArray *ovums = [NSArray arrayWithArray:dragDropManager.ovumList];
        currentDragLine=nil;

        NSArray* sublayers = [NSArray arrayWithArray:self.view.layer.sublayers];

    for (int i=0; i<sublayers.count; i++) {
        if(i>1){
            CALayer *layer = sublayers[i];
            
            [layer removeFromSuperlayer];}}

        
        for(OBOvum *ovum in ovums)
        {
            [ovum deleteOvum];
            NSLog(@"Ovum<0x%x> %@ Exited", (int)ovum, ovum.dataObject);
            
            topView.layer.borderColor = [UIColor clearColor].CGColor;
            topView.layer.borderWidth = 0.0;
            UIView *itemView = ovum.mainView;
           //     itemView.alpha=0.5;
             //   itemView.frame = CGRectInset(itemView.frame, itemView.frame.size.width-40, itemView.frame.size.height-40);
                
                
                OBDragDropManager *manager = [OBDragDropManager sharedManager];
                NSLog(@"pre remove ovumlist: %@",manager.ovumList);
                [manager.ovumList removeObject:ovum];
            
                if([topViewContents containsObject:itemView]){
                    [[itemView subviews]
                     makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    [itemView removeFromSuperview];
                    [topViewContents removeObject:itemView];
                    
                }
                
            
            
            
        }

    }
    [topView setNeedsDisplay];

    [self.view setNeedsDisplay];
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
    
}

-(void) ovumDropped:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
    NSLog(@"Ovum<0x%x> %@ Dropped. In view: %@. At Location: %@", (int)ovum, ovum.dataObject,view, NSStringFromCGPoint(location));
    view.hidden=NO;
    
    NSLog(@"Ovum tag is :%@",ovum.tag);
    
    ovum.dragView.hidden=NO;

    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.borderWidth = 0.0;
    
    
    
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
                if([ovum.type isEqualToString:@"val"] || [ovum.type isEqualToString:@"op"])
               {
                   [ovum setLabel:@""];

                    [self editOvumText:ovum];
                }
                
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

-(void)editOvumText:(OBOvum *)ovum
{
    NSLog(@"Called editOvumText on %@",ovum);
    CGRect frame = ovum.mainView.frame;
  //  CGRect frame = [ovum.mainView convertRect:ovum.mainView.bounds toView:ovum.mainView.window];
    //frame = [window convertRect:frame fromWindow:ovum.mainView.window];
  //  frame = [topView.window convertRect:frame fromWindow:ovum.mainView.window];
    CGRect newRect = CGRectMake(20, 0, frame.size.width-20, frame.size.height/2);
    UITextField *textField = [[UITextField alloc] initWithFrame:newRect];
    textField.borderStyle = UITextBorderStyleNone;
    textField.font =  [UIFont fontWithName:@"AvenirNext-Medium" size:20];
    textField.textColor = [UIColor whiteColor];
    textField.placeholder = @"";
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.returnKeyType = UIReturnKeyDone;
    textField.backgroundColor= [UIColor clearColor];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    textField.tag=(int)ovum.dataObject;
    [ovum.mainView addSubview:textField];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    OBOvum *ovum = [dragDropManager getOvumWithTag:textField.tag];
    [ovum setLabel:@""];

    if (![ovum.type isEqualToString:@"val"]) { //its an operator
        
        ovum.type=textField.text;
        
        if(ovum.input.count<2)
        {
            [ovum setTypeLabel:textField.text];
        }
        else
        {
            [ovum setTypeLabel:textField.text];

            [self updateOvumValue:ovum];
            
            
        }
    }
    else{ //its a value
        ovum.values = [[NSMutableArray alloc]initWithObjects:textField.text, nil];
        [ovum setLabel:textField.text];
        
        if (ovum.output.count>0) {

        OBOvum *outputOvum = ovum.output[0];

            if(outputOvum.input.count>1)
            {
                NSLog(@"Test");
                [self updateOvumValue:outputOvum];
            }
            
            
        }

    }
    
    
    textField.text=@"";

    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    OBOvum *ovum = [dragDropManager getOvumWithTag:textField.tag];

    if (![ovum.type isEqualToString:@"val"]) {
        textField.text = @"";
    }
    else
    {
    textField.text = [ovum getLabel];
    }
    [ovum setLabel:@""];

}
-(void)updateOvumValue:(OBOvum *)ovum
{
    if([ovum.type isEqualToString: @"+"])
    {
        float value = 0;
        
        for (OBOvum *ovumInputs in ovum.input)
        {
            value += [ovumInputs.values[0] floatValue];
        }
        
        ovum.values = [[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%f",value], nil];
        
        [ovum setLabel:[NSString stringWithFormat:@"%g",value]];

        
    }
    else if([ovum.type isEqualToString: @"*"])
    {
        float value = 1;
        
        for (OBOvum *ovumInputs in ovum.input)
        {
            value =value * [ovumInputs.values[0] floatValue];
        }
        
        ovum.values = [[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%f",value], nil];
        
        [ovum setLabel:[NSString stringWithFormat:@"%g",value]];

    }
    else if([ovum.type isEqualToString: @"/"])
    {
        
            OBOvum *dividend = ovum.input[0];
        OBOvum *divisor = ovum.input[1];

        float value = [dividend.values[0] floatValue] / [divisor.values[0] floatValue];
        
        ovum.values = [[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%f",value], nil];
        
        [ovum setLabel:[NSString stringWithFormat:@"%g",value]];
        
    }
    else if([ovum.type isEqualToString: @"-"])
    {
        OBOvum *dividend = ovum.input[0];
        OBOvum *divisor = ovum.input[1];
        
        float value = [dividend.values[0] floatValue] - [divisor.values[0] floatValue];
        
        ovum.values = [[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%f",value], nil];
        
        [ovum setLabel:[NSString stringWithFormat:@"%g",value]];

    }
    else if([ovum.type isEqualToString: @"^"])
    {
        OBOvum *dividend = ovum.input[0];
        OBOvum *divisor = ovum.input[1];
        
        float value = pow([dividend.values[0] floatValue], [divisor.values[0] floatValue]);
        
        ovum.values = [[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%f",value], nil];
        
        [ovum setLabel:[NSString stringWithFormat:@"%g",value]];

        
    }
    else if([ovum.type isEqualToString: @"%"])
    {
        OBOvum *dividend = ovum.input[0];
        OBOvum *divisor = ovum.input[1];
        
        float value =  [dividend.values[0] integerValue] % [divisor.values[0] integerValue];
        
        ovum.values = [[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%f",value], nil];
        
        [ovum setLabel:[NSString stringWithFormat:@"%g",value]];
        
        
    }
    else if([ovum.type isEqualToString: @"%"])
    {
        OBOvum *dividend = ovum.input[0];
        OBOvum *divisor = ovum.input[1];
        
        float value =  [dividend.values[0] integerValue] % [divisor.values[0] integerValue];
        
        ovum.values = [[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%f",value], nil];
        
        [ovum setLabel:[NSString stringWithFormat:@"%g",value]];
        
        
    }
    
    if([ovum.type isEqualToString:@"min"] || [ovum.type isEqualToString:@"max"])
    {
        if(ovum.values.count>0){
        
        float value = [ovum.values[0] floatValue];
        [ovum setLabel:[NSString stringWithFormat:@"%g",value ]];
        }
    }
    
    for(OBOvum *outputNode in ovum.output)
    {
        if(outputNode.input.count>1)
        {
            [self updateOvumValue:outputNode];
        }
    }

    
}

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


-(void)checkOvumList
{
    NSArray *list = [NSArray arrayWithArray:dragDropManager.ovumList];
    
    for(OBOvum *ovum in list)
    {
        if(ovum.currentDropHandlingView != topView)
        {
            [dragDropManager.ovumList removeObject:ovum];
        }
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
