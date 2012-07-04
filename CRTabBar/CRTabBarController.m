#import "CRTabBarController.h"

static const float TAB_BAR_HEIGHT = 50.0f;
static const float TAB_BAR_WIDTH = 80.0f;
static const int TABS_PER_ROW = 4;
static const int MORE_BUTTON_INDEX = 3;
static const CGFloat screenHeight = 460.0;


static const NSInteger TAG_OFFSET = 1000;

@implementation CRTabBarController

@synthesize viewControllers         = _viewControllers;
@synthesize selectedIndex           = _selectedIndex;
@synthesize delegate                = _delegate;
@synthesize font                    = _font;
@synthesize maxItemSize             = _maxItemSize;
@synthesize items                   = _items;
@synthesize itemViews               = _itemViews;
@synthesize tabButtonsContainerView = _tabButtonsContainerView;
@synthesize contentContainerView    = _contentContainerView;
@synthesize moreTabBarItem          = _moreTabBarItem;
@synthesize selectedItem            = _selectedItem;
@synthesize moreItemView            = _moreItemView;
@synthesize itemsPerRow             = _itemsPerRow;
@synthesize rows                    = _rows;
@synthesize moreButtonPressed       = _moreButtonPressed;
@synthesize fromController          = _fromController;
@synthesize toController            = _toController;
@synthesize selectedViewController  = _selectedViewController;

- (void)addTabButtons
{
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
	for (UIViewController *viewController in self.viewControllers)
        [tabBarItems addObject: viewController.tabBarItem];

    [self addTabBarItems: tabBarItems];
}

- (UIButton *)moreTabBarButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage: [UIImage imageNamed:@"ICN_more"] forState: UIControlStateNormal];
    [button setImage: [UIImage imageNamed:@"ICN_more_ON"] forState: UIControlStateSelected];
    
    button.tag = TAG_OFFSET + MORE_BUTTON_INDEX;
    
    [button addTarget:self action:@selector(moreTabButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [button setContentHorizontalAlignment: UIControlContentHorizontalAlignmentCenter];        
 
    return button;
}

-(BOOL)shouldDisplayMoreButton 
{
    if ([self.viewControllers count] > TABS_PER_ROW)
        return YES;
    
    return NO;
}

-(void)addTabBarItems: (NSArray *)tabBarItems
{
    NSUInteger index = 0;
    
    for (UITabBarItem *tabBarItem in tabBarItems) {
        if ([self shouldDisplayMoreButton] && index == (TABS_PER_ROW - 1)) 
        {
            UIButton *button = [self moreTabBarButton];
            [self.tabButtonsContainerView addSubview:button];
        }

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage: tabBarItem.finishedUnselectedImage forState: UIControlStateNormal];
        [button setImage: tabBarItem.finishedSelectedImage forState: UIControlStateSelected];
        
        button.tag = TAG_OFFSET + index;
        
        [button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [button setContentHorizontalAlignment: UIControlContentHorizontalAlignmentCenter];        
        
        [self.tabButtonsContainerView addSubview:button];
        index++;
    }
    
}

- (void)reloadTabButtons
{
    [self addTabButtons];
    [self layoutTabButtons];

	NSUInteger lastIndex = _selectedIndex;
	_selectedIndex = NSNotFound;
	self.selectedIndex = lastIndex;
}

- (void)layoutTabButtons
{
	NSUInteger index = 0;
    NSUInteger rowPosition = 0;

	CGRect rect = CGRectMake(0, 0, TAB_BAR_WIDTH, TAB_BAR_HEIGHT);

	NSArray *buttons = [self.tabButtonsContainerView subviews];
	for (UIButton *button in buttons)
	{
        if( (index + 1) > TABS_PER_ROW && ( (index + 1) % TABS_PER_ROW ) == 1 ) {
            ++rowPosition;
            rect.origin.x = 0;    
        }
                    
        rect.origin.y = rowPosition * TAB_BAR_HEIGHT;
		button.frame = rect;
		rect.origin.x += rect.size.width;

		++index;
	}
}

- (void)loadView
{
	[super loadView];

    self.contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;    
	self.tabButtonsContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    CGRect rect = CGRectMake(0, 0, 320, screenHeight - [self tabBarHeight]);        
    self.contentContainerView = [[UIView alloc] initWithFrame:rect];
        
    CGRect innerRect = CGRectMake(0, screenHeight - ([self tabBarHeight]), 320, [self tabBarHeight]);            
	self.tabButtonsContainerView = [[UIView alloc] initWithFrame:innerRect];
    
    [self.view addSubview:self.contentContainerView];
	[self.view addSubview:self.tabButtonsContainerView];
	
	[self reloadTabButtons];        
}

-(CGFloat)tabBarHeight
{    
    if (self.moreButtonPressed) {
        return TAB_BAR_HEIGHT * [self tabBarRows];
    }
    else {
        return TAB_BAR_HEIGHT;
    }
}

-(NSUInteger)tabBarRows
{
    NSUInteger extraRow = 0;
    
    if (([self.viewControllers count] % 4) > 0) {
        extraRow = 1;
    }
    
    NSInteger tabCounter = ([self.viewControllers count] / 4) + extraRow;
    return tabCounter;
}


- (void)viewDidUnload
{
	[super viewDidUnload];
	self.tabButtonsContainerView = nil;
	self.contentContainerView = nil;

}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	[self layoutTabButtons];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Only rotate if all child view controllers agree on the new orientation.
	for (UIViewController *viewController in self.viewControllers)
	{
		if (![viewController shouldAutorotateToInterfaceOrientation:interfaceOrientation])
			return NO;
	}
	return YES;
}

- (void)setViewControllers:(NSArray *)newViewControllers
{
	NSAssert([newViewControllers count] >= 2, @"CRTabBarController requires at least two view controllers");

	UIViewController *oldSelectedViewController = self.selectedViewController;

	// Remove the old child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[viewController willMoveToParentViewController:nil];
		[viewController removeFromParentViewController];
	}

	_viewControllers = [newViewControllers copy];

	// This follows the same rules as UITabBarController for trying to
	// re-select the previously selected view controller.
	NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
	if (newIndex != NSNotFound)
		_selectedIndex = newIndex;
	else if (newIndex < [_viewControllers count])
		_selectedIndex = newIndex;
	else
		_selectedIndex = 0;

	// Add the new child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[self addChildViewController:viewController];
		[viewController didMoveToParentViewController:self];
	}

	if ([self isViewLoaded])
		[self reloadTabButtons];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
	[self setSelectedIndex:newSelectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated
{
	NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");

	if ([self.delegate respondsToSelector:@selector(cr_tabBarController:shouldSelectViewController:atIndex:)])
	{
		self.toController = [self.viewControllers objectAtIndex:newSelectedIndex];
		if (![self.delegate cr_tabBarController:self shouldSelectViewController:self.toController atIndex:newSelectedIndex])
			return;
	}

	if (![self isViewLoaded])
	{
		_selectedIndex = newSelectedIndex;
	}
	else if (_selectedIndex != newSelectedIndex)
	{
		if (_selectedIndex != NSNotFound)
		{
			self.fromController = self.selectedViewController;
		}

		NSUInteger oldSelectedIndex = _selectedIndex;
		_selectedIndex = newSelectedIndex;

		UIButton *toButton;
		if (_selectedIndex != NSNotFound)
		{
			toButton = (UIButton *)[self.tabButtonsContainerView viewWithTag:TAG_OFFSET + _selectedIndex];
			self.toController = self.selectedViewController;
		}

		if (self.toController == nil)  // don't animate
		{
			[self.fromController.view removeFromSuperview];
		}
		else if (self.fromController == nil)  // don't animate
		{
			self.toController.view.frame = self.contentContainerView.bounds;
			[self.contentContainerView addSubview:self.toController.view];

			if ([self.delegate respondsToSelector:@selector(cr_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate cr_tabBarController:self didSelectViewController:self.toController atIndex:newSelectedIndex];
		}
		else if (animated)
		{
			CGRect rect = self.contentContainerView.bounds;
			if (oldSelectedIndex < newSelectedIndex)
				rect.origin.x = rect.size.width;
			else
				rect.origin.x = -rect.size.width;

			self.toController.view.frame = rect;
			self.tabButtonsContainerView.userInteractionEnabled = NO;

			[self transitionFromViewController: self.fromController 
                              toViewController: self.toController
                                      duration:0.3
                                       options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
                                    animations:^ {
					CGRect rect = self.fromController.view.frame;
					if (oldSelectedIndex < newSelectedIndex)
						rect.origin.x = -rect.size.width;
					else
						rect.origin.x = rect.size.width;

					self.fromController.view.frame = rect;
					self.toController.view.frame = self.contentContainerView.bounds;
				}
				completion:^(BOOL finished)
				{
					self.tabButtonsContainerView.userInteractionEnabled = YES;

					if ([self.delegate respondsToSelector:@selector(cr_tabBarController:didSelectViewController:atIndex:)])
						[self.delegate cr_tabBarController:self didSelectViewController:self.toController atIndex:newSelectedIndex];
				}];
		}
		else  // not animated
		{
            
            if( self.fromController.view )
                [self.fromController.view removeFromSuperview];

			self.toController.view.frame = self.contentContainerView.bounds;
			[self.contentContainerView addSubview:self.toController.view];

			if ([self.delegate respondsToSelector:@selector(cr_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate cr_tabBarController:self didSelectViewController:self.toController atIndex:newSelectedIndex];
		}
	}
}

- (UIViewController *)selectedViewController
{
	if (self.selectedIndex != NSNotFound)
		return [self.viewControllers objectAtIndex:self.selectedIndex];
	else
		return nil;
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController
{
	[self setSelectedViewController:newSelectedViewController animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated;
{
	NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
	if (index != NSNotFound)
		[self setSelectedIndex:index animated:animated];
}

- (void)tabButtonPressed:(UIButton *)sender
{    
	[self setSelectedIndex:sender.tag - TAG_OFFSET animated:YES];
}

- (void)moreTabButtonPressed:(UIButton *)sender
{    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    

    self.moreButtonPressed = !self.moreButtonPressed;

    CGRect rect = CGRectMake(0, 0, 320, screenHeight - [self tabBarHeight]);        
    self.contentContainerView.frame = rect;
  
    CGRect innerRect = CGRectMake(0, screenHeight - [self tabBarHeight], 320, [self tabBarHeight]);            
	self.tabButtonsContainerView.frame = innerRect;
    [UIView commitAnimations];
}

-(void)hideTabBar {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];

    [self.contentContainerView setFrame:CGRectMake(self.contentContainerView.frame.origin.x,
                                                   0,
                                                   self.contentContainerView.frame.size.width,
                                                   480)];
    
    [self.tabButtonsContainerView setFrame:CGRectMake(self.tabButtonsContainerView.frame.origin.x,
                                                      480,
                                                      self.tabButtonsContainerView.frame.size.width,
                                                      self.tabButtonsContainerView.frame.size.height)];
    
    [UIView commitAnimations];
}

-(void)showTabBar {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
        
    CGRect rect = CGRectMake(0, 0, 320, screenHeight - [self tabBarHeight]);        
    self.contentContainerView.frame = rect;
    
    CGRect innerRect = CGRectMake(0, screenHeight - [self tabBarHeight], 320, [self tabBarHeight]);            
	self.tabButtonsContainerView.frame = innerRect;
    
    [UIView commitAnimations];
}

@end
