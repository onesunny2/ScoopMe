//
//  NetworkServiceProtocol.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/15/25.
//

import Foundation
import Combine
import SCMLogger
internal import SCMNetwork

protocol NetworkServiceProtocol: ObservableObject, AnyObject {
    var network: SCMNetworkImpl { get }
}
