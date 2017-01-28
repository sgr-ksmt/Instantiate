//
//  Storyboard.swift
//  Instantiate
//
//  Created by tarunon on 2016/12/04.
//  Copyright © 2016年 tarunon. All rights reserved.
//

import Foundation

public protocol StoryboardType {
    static var storyboard: UIStoryboard { get }
}

public enum InstantiateSource {
    case initial
    case identifier(Identifier)
}

public protocol StoryboardInstantiatable: Instantiatable, StoryboardType {
    static var instantiateSource: InstantiateSource { get }
}

public extension StoryboardInstantiatable where Self: NSObject {
    static var instantiateSource: InstantiateSource {
        return .initial
    }
}

public extension StoryboardInstantiatable where Self: UIViewController {
    public static func instantiate(with parameter: Parameter) -> Self {
        let storyboard = (self as StoryboardType.Type).storyboard
        let _self: Self
        switch self.instantiateSource {
        case .initial:
            _self = storyboard.instantiateInitialViewController() as! Self
        case .identifier(let identifier):
            _self = storyboard.instantiateViewController(withIdentifier: identifier.rawValue) as! Self
        }
        _self.bind(to: parameter)
        return _self
    }
}
