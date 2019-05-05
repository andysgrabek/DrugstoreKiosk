//
//  ConflictsViewController.swift
//  Drugstore
//
//  Created by Andrzej Grabowski on 30/12/2018.
//  Copyright © 2018 Andrzej Grabowski. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class ConflictsViewController: UIPageViewController {
    
    var conflictViewControllers = [ConflictViewController]()
    
    override func viewDidLoad() {
        self.dataSource = self
        let storyboard = UIStoryboard(name: "Conflict", bundle: nil)
        for conflict in DetectedConflicts.conflicts {
            let vc: ConflictViewController = storyboard.instantiateInitialViewController() as! ConflictViewController
            vc.conflict = conflict
            vc.delegate = self
            conflictViewControllers.append(vc)
        }
        if let firstVC = conflictViewControllers.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func setSelected(conflictIndex: Int) {
        let vc = conflictViewControllers[conflictIndex]
        setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }
    
    func nextPage( ) {
        let currentIndex = conflictViewControllers.firstIndex(of: viewControllers?.first as! ConflictViewController)
        if currentIndex! + 1 < conflictViewControllers.count {
            setViewControllers([conflictViewControllers[currentIndex! + 1]], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func previousPage() {
        let currentIndex = conflictViewControllers.firstIndex(of: viewControllers?.first as! ConflictViewController)
        if currentIndex! > 0 {
            setViewControllers([conflictViewControllers[currentIndex! - 1]], direction: .reverse, animated: true, completion: nil)
        }
    }
    
}

extension ConflictsViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = conflictViewControllers.index(of: viewController as! ConflictViewController) else {
            return nil
        }
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard conflictViewControllers.count > previousIndex else {
            return nil
        }
        
        return conflictViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = conflictViewControllers.index(of: viewController as! ConflictViewController) else {
            return nil
        }
        
        let nextIndex = vcIndex + 1
        
        guard nextIndex != conflictViewControllers.count else {
            return nil
        }
        
        guard conflictViewControllers.count > nextIndex else {
            return nil
        }
        
        return conflictViewControllers[nextIndex]
    }
    
    
}
