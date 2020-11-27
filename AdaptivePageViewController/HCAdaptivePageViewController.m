//
//  HCAdaptivePageViewController.m
//  AdaptivePageViewController
//
//  Created by Pambudi on 25/11/20.
//

#import "HCAdaptivePageViewController.h"

typedef NS_ENUM(NSInteger, HCDisplayMode)
{
    HCDisplayModeSingle = 0,
    HCDisplayModeDouble
};

@interface HCAdaptivePageViewController ()
<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property(nonatomic) UIPageViewController *activePageVC;
@property(nonatomic) UIPageViewController *siglePageVC;
@property(nonatomic) UIPageViewController *doublePageVC;

@property(nonatomic) UIPageViewControllerTransitionStyle transitionStyle;
@property(nonatomic) UIPageViewControllerNavigationOrientation navigationOrientation;
@property(nonatomic) NSDictionary *options;

@property(nonatomic) HCDisplayMode displayMode;

@end

@implementation HCAdaptivePageViewController
@synthesize viewControllers = _viewControllers;

-(instancetype)initWithTransitionStyle:(UIPageViewControllerTransitionStyle) transitionStyle
                 navigationOrientation:(UIPageViewControllerNavigationOrientation) navigationOrientation
                               options:(NSDictionary*)options
{
    self = [super init];
    if (self)
    {
        _transitionStyle = transitionStyle;
        _navigationOrientation = navigationOrientation;
        _options = options;
    }
    return self;
}

#pragma mark - UIViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!self.activePageVC.viewControllers.count)
    {
        self.displayMode = [self displayModeForTraitCollection:self.traitCollection withSize:self.view.bounds.size];
    }
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.displayMode = [self displayModeForTraitCollection:self.traitCollection withSize:size];
    }];
}

//-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
//
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        self.displayMode = [self displayModeForTraitCollection:newCollection];
//    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//
//    }];
//}

#pragma mark Getter
-(UIPageViewController*)siglePageVC
{
    if (!_siglePageVC) {
        NSMutableDictionary *mdd = [NSMutableDictionary dictionaryWithDictionary:self.options];
        id obj = [mdd objectForKey:UIPageViewControllerOptionSpineLocationKey];
        if ([obj respondsToSelector:@selector(integerValue)]) {
            if ([obj integerValue]==UIPageViewControllerSpineLocationMid) {
                [mdd removeObjectForKey:UIPageViewControllerOptionSpineLocationKey];
            }
        }
        
        _siglePageVC = [[UIPageViewController alloc] initWithTransitionStyle:self.transitionStyle
                                                       navigationOrientation:self.navigationOrientation
                                                                     options:mdd];
    }
    return _siglePageVC;
}

-(UIPageViewController*)doublePageVC
{
    if (!_doublePageVC) {
        NSMutableDictionary *mdd = [NSMutableDictionary dictionaryWithDictionary:self.options];
        [mdd setObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMid]
                forKey:UIPageViewControllerOptionSpineLocationKey];

        _doublePageVC.doubleSided = YES;
        _doublePageVC = [[UIPageViewController alloc] initWithTransitionStyle:self.transitionStyle
                                                        navigationOrientation:self.navigationOrientation
                                                                      options:mdd];
    }
    return _doublePageVC;
}

-(NSArray <UIViewController*>*)viewControllers
{
    return self.activePageVC.viewControllers;
}

#pragma mark Setter

-(void)setDisplayMode:(HCDisplayMode)displayMode
{
    UIPageViewController *prevPageVC = self.activePageVC;
    _displayMode = displayMode;
    _activePageVC = [self pageViewControllerForDisplayMode:displayMode];
    if([self.activePageVC.view.superview isEqual:self.view])return;
    
    [self.view.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    if(![prevPageVC isEqual:self.activePageVC])
    {
        prevPageVC.dataSource = nil;
        prevPageVC.delegate = nil;
        self.activePageVC.dataSource = self;
        self.activePageVC.delegate = self;
    }
    
    [self.view addSubview:self.activePageVC.view];
    self.activePageVC.view.frame = self.view.bounds;
    self.activePageVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    UIViewController *anchorVC = prevPageVC.viewControllers.firstObject;
    [self prepareContentForPageViewController:self.activePageVC withAnchorViewController:anchorVC];
}

-(void)setViewControllers:(NSArray<UIViewController *> *)viewControllers
{
    
    if (!self.activePageVC)
    {
        _viewControllers = viewControllers;
        
    }
    [self.activePageVC setViewControllers:viewControllers
                                direction:UIPageViewControllerNavigationDirectionReverse
                                 animated:YES
                               completion:^(BOOL finished) {
            
    }];
}


#pragma mark Helper

-(void)prepareContentForPageViewController:(UIPageViewController*)pageVC
                  withAnchorViewController:(UIViewController*)anchorVC
{
    if (![anchorVC isKindOfClass:[UIViewController class]]) {
        anchorVC = _viewControllers.firstObject;
        if (![anchorVC isKindOfClass:[UIViewController class]]) {
            anchorVC = [UIViewController new];
        }
    }
    NSMutableArray *mArr = [NSMutableArray arrayWithObject:anchorVC];
    if (pageVC.spineLocation==UIPageViewControllerSpineLocationMid)
    {
        UIViewController *nextVC = [self.dataSource adaptivePageViewController:self viewControllerAfterViewController:mArr.firstObject];
        if(![nextVC isKindOfClass:[UIViewController class]])
        {
            nextVC = [UIViewController new];
        }
        [mArr addObject:nextVC];
    }
    [pageVC setViewControllers:mArr
                     direction:UIPageViewControllerNavigationDirectionForward
                      animated:NO
                    completion:^(BOOL finished) {
            
    }];
}

-(HCDisplayMode)displayModeForTraitCollection:(UITraitCollection*)traitCollection withSize:(CGSize)size
{
    if(self.navigationOrientation==UIPageViewControllerNavigationOrientationHorizontal)
    {
        if (traitCollection.verticalSizeClass==UIUserInterfaceSizeClassRegular) {
            if (traitCollection.horizontalSizeClass==UIUserInterfaceSizeClassRegular) {
                CGFloat ratio = size.height/size.width;
                if (ratio<1.1) {
                    return HCDisplayModeDouble;
                }
            }
        }
    }
    return HCDisplayModeSingle;
}

-(UIPageViewController*)pageViewControllerForDisplayMode:(HCDisplayMode)displayMode
{
    switch (displayMode) {
        case HCDisplayModeDouble:
            return self.doublePageVC;
            break;
        default:
            break;
    }
    
    return self.siglePageVC;
}
#pragma mark - UIPageViewControllerDelegate
-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    if ([self.delegate respondsToSelector:@selector(adaptivePageViewController:willTransitionToViewControllers:)]) {
        [self.delegate adaptivePageViewController:self willTransitionToViewControllers:pendingViewControllers];
    }
}

- (void)pageViewController:(HCAdaptivePageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if([self.delegate respondsToSelector:@selector(adaptivePageViewController:didFinishAnimating:previousViewControllers:transitionCompleted:)])
    {
        [self.delegate adaptivePageViewController:self didFinishAnimating:finished previousViewControllers:previousViewControllers transitionCompleted:completed];
    }
}

#pragma mark UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(HCAdaptivePageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([self.dataSource respondsToSelector:@selector(adaptivePageViewController:viewControllerBeforeViewController:)]) {
        return [self.dataSource adaptivePageViewController:self viewControllerBeforeViewController:viewController];
    }
    
    return nil;
}
- (UIViewController *)pageViewController:(HCAdaptivePageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([self.dataSource respondsToSelector:@selector(adaptivePageViewController:viewControllerAfterViewController:)]) {
        return [self.dataSource adaptivePageViewController:self viewControllerAfterViewController:viewController];
    }
    
    return nil;
}


@end
