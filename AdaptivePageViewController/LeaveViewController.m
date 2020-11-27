//
//  LeaveViewController.m
//  AdaptivePageViewController
//
//  Created by Pambudi on 25/11/20.
//

#import "LeaveViewController.h"

@interface LeaveViewController ()
@property (nonatomic) UILabel *pageLabel;

@end

@implementation LeaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    
}

-(UILabel*)pageLabel
{
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64, self.view.frame.size.width, 60)];
        _pageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_pageLabel];
    }
    return _pageLabel;;
}

 -(void)setPageIndex:(NSInteger)pageIndex
{
    _pageIndex = pageIndex;
    NSNumber *num = [NSNumber numberWithInteger:pageIndex+1];
    NSNumberFormatter *nf = [NSNumberFormatter new];
    nf.locale = [NSLocale currentLocale];
    
    self.pageLabel.text = [nf stringFromNumber:num];
}

@end
