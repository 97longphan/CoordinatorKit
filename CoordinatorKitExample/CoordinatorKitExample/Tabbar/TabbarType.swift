//
//  TabbarType.swift
//  CoordinatorCore
//
//  Created by LONGPHAN on 2/7/25.
//

import Foundation
import CoordinatorKit

// Chuyển sang factory khi cần linh hoạt
enum TabbarType: Int, CaseIterable {
    case tab1
    case tab2

    var title: String {
        switch self {
        case .tab1: return "Tab1"
        case .tab2: return "Tab2"
        }
    }

    var icon: String {
        switch self {
        case .tab1: return "house"
        case .tab2: return "person"
        }
    }

    func makeCoordinator(router: Router) -> Coordinator {
        switch self {
        case .tab1:
            return Tabbar1Coordinator(router: router)
        case .tab2:
            return Tabbar2Coordinator(router: router)
        }
    }
}
