//
//  Router.swift
//  Coordinator-core
//
//  Created by LONGPHAN on 25/6/25.
//

import UIKit

// MARK: - Drawable


/// Giao diện đại diện cho bất kỳ thành phần nào có thể được hiển thị (VC)
public protocol Drawable {
    var viewController: UIViewController? { get }
    var canDelegate: Bool { get }
}

extension UIViewController: Drawable {
    public var viewController: UIViewController? { self }
    public var canDelegate: Bool { true }
}

// MARK: - Typealiases

public typealias NavigationBackClosure = (() -> Void)

// MARK: - RouterProtocol


public protocol RouterProtocol: AnyObject {
    var navigationController: UINavigationController { get }
    
    func push(drawable: Drawable,
              to coordinator: Coordinator,
              isAnimated: Bool,
              onNavigateBack: NavigationBackClosure?)
    
    func pop(isAnimated: Bool)
    
    func popToRootCoordinator(isAnimated: Bool)
    
    func popToCoordinator(coordinator: Coordinator, isAnimated: Bool)
    
    func present(drawable: Drawable,
                 coordinator: Coordinator,
                 isAnimated: Bool,
                 onDismiss: NavigationBackClosure?)
    
    func dismiss(coordinator: Coordinator, isAnimated: Bool, completion: (() -> Void)?)
    
    func showAlert(title: String,
                   message: String,
                   actions: [(String, UIAlertAction.Style, (() -> Void)?)],
                   from coordinator: Coordinator,
                   animated: Bool)
}

// MARK: - RouterContext

private struct RouterContext {
    weak var viewController: UIViewController?
    var onNavigateBack: NavigationBackClosure?
    var presentationDelegate: RouterPresentationDelegate?
}

// MARK: - Router

public final class Router: NSObject, RouterProtocol {
    
    // MARK: Properties
    public let navigationController: UINavigationController
    private var coordinatorContexts: [ObjectIdentifier: RouterContext] = [:]
    
    // MARK: Init
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    // MARK: Navigation Methods
    public func push(drawable: Drawable,
              to coordinator: Coordinator,
              isAnimated: Bool,
              onNavigateBack: NavigationBackClosure?) {
        
        guard let vc = drawable.viewController else { return }
        
        // Gán onPop nếu VC cho phép quan sát
        if let obsVC = vc as? BaseViewControllerCoordinator {
            obsVC.onPop = { [weak self, weak vc] in
                guard let self, let vc else { return }
                self.executeClosure(for: vc)
            }
        }
        
        let id = ObjectIdentifier(coordinator)
        coordinatorContexts[id] = RouterContext(
            viewController: vc,
            onNavigateBack: onNavigateBack,
            presentationDelegate: nil
        )
        
        navigationController.pushViewController(vc, animated: isAnimated)
    }
    
    public func pop(isAnimated: Bool) {
        navigationController.popViewController(animated: isAnimated)
    }
    
    public func popToRootCoordinator(isAnimated: Bool) {
        // Kiểm tra xem có ít nhất 1 VC trong stack không
        guard !navigationController.viewControllers.isEmpty else {
            print("⚠️ Không có viewController nào trong stack")
            return
        }
        
        let currentStack = navigationController.viewControllers
        let poppedVCs = currentStack.dropFirst()
        
        for vc in poppedVCs {
            executeClosure(for: vc)
        }
        
        navigationController.popToRootViewController(animated: isAnimated)
    }
    
    public func popToCoordinator(coordinator: Coordinator, isAnimated: Bool) {
        let id = ObjectIdentifier(coordinator)
        guard let toVC = coordinatorContexts[id]?.viewController else {
            print("⚠️ Không tìm thấy ViewController tương ứng với \(coordinator)")
            return
        }
        
        // Lấy danh sách các viewController hiện tại
        let currentStack = navigationController.viewControllers
        
        // Lấy danh sách các VC sẽ bị pop
        guard let index = currentStack.firstIndex(of: toVC) else {
            print("⚠️ Không tìm thấy toVC trong navigation stack")
            return
        }
        
        let poppedVCs = currentStack.suffix(from: index + 1)
        
        // Gọi executeClosure để cleanup RouterContext và gọi onNavigateBack
        for vc in poppedVCs {
            executeClosure(for: vc)
        }
        
        navigationController.popToViewController(toVC, animated: isAnimated)
    }
    
    public func present(drawable: Drawable,
                 coordinator: Coordinator,
                 isAnimated: Bool,
                 onDismiss: NavigationBackClosure?) {
        
        guard let vc = drawable.viewController else { return }
        
        // Nếu drawable cho phép set delegate
        var delegate: RouterPresentationDelegate? = nil
        
        // Có những drawable không cho phép sử dụng delegate, như kiểu UIAlertViewController
        if drawable.canDelegate {
            delegate = RouterPresentationDelegate(onDismiss: { [weak self, weak vc] in
                guard let self, let vc else { return }
                self.executeClosure(for: vc)
            })
            
            vc.presentationController?.delegate = delegate
        }
        
        // Lưu context để cleanup sau
        let id = ObjectIdentifier(coordinator)
        coordinatorContexts[id] = RouterContext(
            viewController: vc,
            onNavigateBack: onDismiss,
            presentationDelegate: delegate
        )
        
        navigationController.topViewController?.present(vc, animated: isAnimated)
    }
    
    
    public func dismiss(coordinator: Coordinator, isAnimated: Bool, completion: (() -> Void)?) {
        let id = ObjectIdentifier(coordinator)
        guard let vc = coordinatorContexts[id]?.viewController else { return }
        
        executeClosure(for: vc)
        vc.dismiss(animated: isAnimated, completion: completion)
    }
    
    // MARK: Cleanup
    
    private func executeClosure(for viewController: UIViewController) {
        if let (key, context) = coordinatorContexts.first(where: { $0.value.viewController === viewController }) {
            context.onNavigateBack?()
            coordinatorContexts.removeValue(forKey: key)
        }
    }
    
    public func showAlert(title: String,
                   message: String,
                   actions: [(String, UIAlertAction.Style, (() -> Void)?)],
                   from coordinator: Coordinator,
                   animated: Bool) {
        let builder = AlertBuilder(title: title, message: message)
        for (title, style, handler) in actions {
            builder.addAction(title: title, style: style, handler: handler)
        }
        let alertDrawable = builder.build()
        present(drawable: alertDrawable, coordinator: coordinator, isAnimated: animated, onDismiss: nil)
    }
}

// MARK: - Modal Dismiss Delegate

final class RouterPresentationDelegate: NSObject, UIAdaptivePresentationControllerDelegate {
    let onDismiss: NavigationBackClosure
    
    init(onDismiss: @escaping NavigationBackClosure) {
        self.onDismiss = onDismiss
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        onDismiss()
    }
    
    deinit {
        print("🔥 RouterPresentationDelegate deinit")
    }
}
