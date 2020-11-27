//
//  HCAdaptivePageViewController.h
//  AdaptivePageViewController
//
//  Created by Pambudi on 25/11/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HCAdaptivePageViewControllerDelegate;
@protocol HCAdaptivePageViewControllerDataSource;

@interface HCAdaptivePageViewController : UIViewController
@property(nonatomic) NSArray <UIViewController*> *viewControllers;
@property(nonatomic) id<HCAdaptivePageViewControllerDelegate> delegate;
@property(nonatomic) id<HCAdaptivePageViewControllerDataSource> dataSource;

-(instancetype)initWithTransitionStyle:(UIPageViewControllerTransitionStyle) transitionStyle
                 navigationOrientation:(UIPageViewControllerNavigationOrientation) navigationOrientation
                               options:(nullable NSDictionary*)options;
@end

@protocol HCAdaptivePageViewControllerDelegate <NSObject>
@optional
- (void)adaptivePageViewController:(HCAdaptivePageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers;
- (void)adaptivePageViewController:(HCAdaptivePageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed;
@end

@protocol HCAdaptivePageViewControllerDataSource <NSObject>
@required
- (UIViewController *)adaptivePageViewController:(HCAdaptivePageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController;
- (UIViewController *)adaptivePageViewController:(HCAdaptivePageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController;
@end
NS_ASSUME_NONNULL_END
