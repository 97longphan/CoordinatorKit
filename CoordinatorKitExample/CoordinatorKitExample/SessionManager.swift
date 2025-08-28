//
//  SessionManager.swift
//  CoordinatorCore
//
//  Created by LONGPHAN on 3/7/25.
//

import Foundation
protocol SessionManaging {
    var isLoggedIn: Bool { get }
    func login()
    func logout()
}

final class SessionManager: SessionManaging {
    static let shared = SessionManager()
    private init() {}

    private(set) var isLoggedIn: Bool = false

    func login() {
        isLoggedIn = true
    }

    func logout() {
        isLoggedIn = false
    }
}
