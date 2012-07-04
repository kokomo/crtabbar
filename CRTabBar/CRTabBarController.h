#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol CRTabBarControllerDelegate;

@interface CRTabBarController : UIViewController

@property (nonatomic, retain)   NSArray           *viewControllers;
@property (nonatomic, retain)   UIViewController  *selectedViewController;
@property (nonatomic, retain)   id                <CRTabBarControllerDelegate> delegate;
@property (nonatomic, retain)   UIFont            *font;
@property (nonatomic, assign)   CGSize            maxItemSize;
@property (nonatomic, assign)   NSArray           *items;
@property (nonatomic, retain)   NSMutableArray    *itemViews;
@property (nonatomic, retain)   UIView            *tabButtonsContainerView;
@property (nonatomic, retain)   UIView            *contentContainerView;
@property (nonatomic, retain)   UIImageView       *moreItemView;
@property (nonatomic, retain)   UITabBarItem      *moreTabBarItem;
@property (nonatomic, assign)   UITabBarItem      *selectedItem;
@property (nonatomic, assign)   NSUInteger        itemsPerRow;
@property (nonatomic, readonly) NSUInteger        rows;
@property (nonatomic, assign)   NSUInteger        selectedIndex;
@property (nonatomic, assign)   BOOL              moreButtonPressed;
@property (nonatomic, assign)   UIViewController  *fromController;
@property (nonatomic, assign)   UIViewController  *toController;

- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setSelectedViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)hideTabBar;
- (void)showTabBar;
@end

/*!
 * The delegate protocol for CRTabBarController.
 */
@protocol CRTabBarControllerDelegate <NSObject>

@optional
- (BOOL)cr_tabBarController:(CRTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
- (void)cr_tabBarController:(CRTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
@end