//
//  RequestPluginType.swift
//  RxHttpClient
//
//  Created by Anton Efimenko on 27.01.17.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import Foundation

public protocol RequestPluginType {
    func prepare(request: URLRequest) -> URLRequest
    func beforeSend(request: URLRequest)
    func afterSuccess(response: URLResponse?, data: Data?)
    func afterFailure(response: URLResponse?, error: Error, data: Data?)
}

public final class CompositeHttpClientBehavior : RequestPluginType {
    let behaviors: [RequestPluginType]
    
    public init(behaviors: [RequestPluginType]) {
        self.behaviors = behaviors
    }
    
    public func prepare(request: URLRequest) -> URLRequest {
        return behaviors.reduce(request, { $0.1.prepare(request: $0.0) })
    }
    
    public func beforeSend(request: URLRequest) {
        behaviors.forEach { $0.beforeSend(request: request) }
    }
    
    public func afterFailure(response: URLResponse?, error: Error, data: Data?) {
        behaviors.forEach { $0.afterFailure(response: response, error: error, data: data) }
    }
    
    public func afterSuccess(response: URLResponse?, data: Data?) {
        behaviors.forEach { $0.afterSuccess(response: response, data: data) }
    }
}
