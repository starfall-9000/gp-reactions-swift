//
//  Global.swift
//  DTMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit

public enum ComponentViewPosition {
    case top(CGFloat), left(CGFloat), bottom(CGFloat), right(CGFloat), center
}

/// ViewState for binding from ViewModel and View (Life cycle binding)
public enum ViewState {
    case none, willAppear, didAppear, willDisappear, didDisappear
}

/// ApplicationState for anyone who wants to know the application state
public enum ApplicationState {
    case none, resignActive, didEnterBackground, willEnterForeground, didBecomeActive, willTerminate
}

/// Block type for factory creation
public typealias FactoryCreationBlock<T> = (() -> T)

/// Block type for destroy a page (mainly to clean up DisposeBag)
public typealias DestroyPageBlock = ((UIViewController?) -> ())

/// Factory type
public struct Factory<T> {
    
    private let creationBlock: FactoryCreationBlock<T>
    
    public init(_ creationBlock: @escaping FactoryCreationBlock<T>) {
        self.creationBlock = creationBlock
    }
    
    public func create() -> T {
        return creationBlock()
    }
}

/*
 Global configurations
 
 For some use cases, we have to setup these configurations to make our application work
 correctly
 */
public struct DDConfigurations {
    
    /*
     Factory for searching top page in our main window
     
     If your rootViewController is a custom one (such as Drawer...)
     then override this block to make navigation service can find the correct top page
     */
    public static var topPageFindingBlock: Factory<UIViewController?> = Factory {
        let myWindow = UIApplication.shared.windows
            .filter { !($0.rootViewController is UIAlertController) }
            .first
        
        guard let rootPage = myWindow?.rootViewController else {
            return nil
        }
        
        var currPage: UIViewController?
        if let drawerPage = rootPage as? DrawerPage {
            currPage = drawerPage.detailPage
        } else {
            currPage = rootPage.presentedViewController ?? rootPage
        }
        
        while currPage?.presentedViewController != nil {
            currPage = currPage?.presentedViewController
        }
        
        if currPage is PresenterPage {
            currPage = currPage?.children.first
        }
        
        while currPage is UINavigationController || currPage is UITabBarController {
            if let navPage = currPage as? UINavigationController {
                currPage = navPage.viewControllers.last
            }
            
            if let tabPage = currPage as? UITabBarController {
                currPage = tabPage.selectedViewController
            }
        }
        
        return currPage
    }
    
    /*
     Block for destroying a page (mainly clean up DisposeBag), using for navigation service
     
     If you have a custom page more than UINavigationController and UITabBarController,
     then override this block for your customs
     */
    public static var destroyPageBlock: DestroyPageBlock = { page in
        var viewControllers = [UIViewController]()
        if let navPage = page as? UINavigationController {
            viewControllers = navPage.viewControllers
        }
        
        if let tabPage = page as? UITabBarController {
            viewControllers = tabPage.viewControllers ?? []
        }
        
        // recursively call destroy on child viewcontrollers
        viewControllers.forEach { DDConfigurations.destroyPageBlock($0) }
        
        // destroy current page
        (page as? IDestroyable)?.destroy()
        
        // remove animator delegate
        (page as? ITransitionView)?.animatorDelegate = nil
    }
    
    /*
     Factory for creating local hud.
     Local hud is a loader indicator places inside a page
     
     If we want to make local hud different layouts, show and hide animations, then
     inherit from LocalHud class to implement your custom local hud
     */
    public static var localHudFactory: Factory<LocalHud> = Factory { DefaultLocalHud() }
    
    /*
     Factory for creating back button.
     
     Each page has a properties for showing back button.
     With back button, we can have more controlling on page navigation
     */
    public static var backButtonFactory: Factory<UIBarButtonItem> = Factory {
        let barButton = UIBarButtonItem()
        barButton.setTitleTextAttributes([.font: Font.system.normal(withSize: 18)], for: .normal)
        barButton.title = "\u{2190}"
        return barButton
    }
}

















