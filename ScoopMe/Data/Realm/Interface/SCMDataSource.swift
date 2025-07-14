//
//  SCMDataSource.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/15/25.
//

import Foundation
import RealmSwift

protocol SCMDataSource: AnyObject {
    associatedtype FetchModel: Object
    associatedtype MessageModel: Object
    
    func create(chatRoom: FetchModel) throws
    func fetch(roomID: String) throws -> FetchModel
    func save(roomID: String, _ message: MessageModel) throws
    func delete(roomID: String, chatID: String, _ message: MessageModel) throws
}
