//
//  PageViewController.m
//  AdaptivePageViewController
//
//  Created by Pambudi on 25/11/20.
//

#import "PageViewController.h"
#import "LeaveViewController.h"

@interface PageViewController ()
<HCAdaptivePageViewControllerDelegate, HCAdaptivePageViewControllerDataSource>
@end

@implementation PageViewController

-(instancetype)init
{
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:nil];
    if(self)
    {
        self.dataSource = self;
        self.delegate = self;
        
        self.view.backgroundColor = [UIColor yellowColor];
        LeaveViewController *firsVC = [self leaveViewControllerForPageIndex:0];
        [self setViewControllers:@[firsVC]];
    }
    return self;
}

-(LeaveViewController*)leaveViewControllerForPageIndex:(NSInteger)pageIndex
{
    LeaveViewController *lvc = [LeaveViewController new];
    lvc.pageIndex = pageIndex;
    
    return lvc;
}

-(UIViewController*)adaptivePageViewController:(HCAdaptivePageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (![viewController isKindOfClass:[LeaveViewController class]]) {
        return nil;
    }
    LeaveViewController *lvc = (LeaveViewController*)viewController;
    return [self leaveViewControllerForPageIndex:lvc.pageIndex-1];
    
}

-(UIViewController*)adaptivePageViewController:(HCAdaptivePageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (![viewController isKindOfClass:[LeaveViewController class]]) {
        return nil;
    }
    LeaveViewController *lvc = (LeaveViewController*)viewController;
    return [self leaveViewControllerForPageIndex:lvc.pageIndex+1];
    
}

@end
