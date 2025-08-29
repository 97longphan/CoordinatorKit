# 🧭 iOS Coordinator Architecture with Router-based Navigation

## 1. Tổng quan

Kiến trúc này tổ chức navigation theo hướng **Coordinator tách biệt hoàn toàn khỏi ViewController**, giúp:

- Điều hướng có kiểm soát (push/present) qua `Router`
- Dễ quản lý vòng đời màn hình (`children`, `parentCoordinator`)
- Hỗ trợ xử lý deeplink ở mọi cấp
- Giao tiếp ngược từ các Coordinator con mà không phụ thuộc vào delegate truyền tay

Từng flow sẽ được điều phối bởi một Coordinator riêng, có thể được `push` hoặc `present` thông qua `Router`.

---

## 2. Coordinator Architecture

### 🔹 Protocol `Coordinator`

```swift
protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    
    func start()
    func childDidFinish(_ child: Coordinator)
}
````

#### ▸ `parentCoordinator`

* Trỏ đến coordinator cha — giúp gửi dữ liệu ngược hoặc cleanup sau khi hoàn tất flow.

#### ▸ `children`

* Danh sách các coordinator con đang hoạt động
* Khi một flow kết thúc, cần gọi `parent.childDidFinish(self)` để cleanup khỏi danh sách

#### ▸ `start()`

* Entry point khởi động flow — tất cả coordinator con đều cần override hàm này để bắt đầu luồng.

#### ▸ `childDidFinish(_:)`

* Mặc định remove khỏi `children`, có thể override nếu muốn xử lý thêm.

---

## 3. Tại sao cần `RouterCoordinator`

`RouterCoordinator` là một protocol đánh dấu rằng Coordinator đó **có khả năng điều hướng**, nghĩa là nó **được gắn với một `RouterProtocol`**.

```swift
protocol RouterCoordinator: Coordinator {
    var router: RouterProtocol { get set }
    var presentationStyle: RouterPresentationStyle { get }
    var parentRouter: RouterProtocol { get set }
}
```

### ✅ Lý do cần thiết:

* Không phải tất cả `Coordinator` đều có khả năng điều hướng (ví dụ như `AppCoordinator` chỉ gán rootViewController)
* Với những coordinator **có push/present**, cần một `Router` để điều hướng và quản lý vòng đời VC tương ứng
* `RouterCoordinator` chính là "marker interface" giúp tách biệt và xử lý đúng logic cho các coordinator điều hướng

---

## 4. Cách hoạt động của `Router` và `coordinatorContexts`

### 🧭 `RouterProtocol` xử lý:

* `push(...)`: thêm VC vào navigation stack
* `present(...)`: trình bày modal
* `dismiss(...)`: đóng modal
* `pop(...)`: quay lại VC trước
* `popToCoordinator(...)`, `popToRootCoordinator(...)`: quay lại VC xác định
* `showAlert(...)`: hiển thị alert với lifecycle tương tự

### 📦 `coordinatorContexts`: lưu thông tin lifecycle mỗi lần điều hướng

```swift
private var coordinatorContexts: [ObjectIdentifier: RouterContext] = [:]
```

* Khi `Router` thực hiện push/present, nó lưu:

  * ViewController đang hiển thị
  * Callback khi pop/dismiss (`onNavigateBack`)
  * PresentationDelegate (để detect gesture dismiss)
* Khi ViewController bị pop/dismiss, Router sẽ:

  * Gọi `executeClosure(for:)`
  * Gọi `onNavigateBack`
  * Xoá khỏi `coordinatorContexts`

---

## 5. Tạo một RouterCoordinator cần gì?

Khi bạn tạo một `RouterCoordinator`, bạn cần truyền:

* Một `RouterProtocol` — quản lý điều hướng
* Một `RouterPresentationStyle` — xác định flow này là push hay present
* Nếu flow là `.present`, bạn **phải truyền đúng `parentRouter`** để có thể dismiss về sau

### ✅ Ví dụ khởi tạo:

```swift
let router = Router(navigationController: nav)
let coordinator = MyFlowCoordinator(router: router, presentationStyle: .push)
coordinator.parentCoordinator = self
children.append(coordinator)
coordinator.start()
```

→ Nếu `.present`, cần update `router = presentingRouter`, đồng thời giữ lại `parentRouter` để dismiss được đúng chỗ.

---

## 6. Mỗi RouterCoordinator hoạt động như thế nào?

* Khi `start()`, Coordinator gọi `perform(viewController, from: self)`:

  * Nếu `.push`, gọi `router.push(...)`, gắn `onPop`
  * Nếu `.present`, tạo navController, gọi `router.present(...)`, gắn delegate dismiss

* Khi ViewController bị pop/dismiss, hệ thống tự động detect và gọi lại `onNavigateBack` đã gắn trong RouterContext

* Khi Coordinator hoàn tất flow, gọi `parentCoordinator?.childDidFinish(self)` để cleanup

---

## 7. Điều hướng: Push và Present hoạt động thế nào?

Trong hệ thống này, mọi điều hướng (`push` / `present`) đều được thực hiện qua `RouterCoordinator`, sử dụng hàm `perform(...)`:

```swift
func perform<V: UIViewController>(
    _ viewController: V,
    isAnimated: Bool = true,
    from coordinator: Coordinator,
    onFinish: (() -> Void)? = nil
)
````

Tùy vào `presentationStyle` được cấu hình, hệ thống sẽ xử lý theo hai hướng:

---

### 🌀 Push hoạt động thế nào?

Khi `presentationStyle == .push`:

```swift
router.push(drawable: viewController, to: coordinator, isAnimated: isAnimated, onNavigateBack: onFinish)
```

#### Các bước:

1. Nếu `viewController` là `BaseViewController`, Router sẽ gán `onPop`:

   ```swift
   obsVC.onPop = { [weak self, weak vc] in
       self?.executeClosure(for: vc)
   }
   ```

2. Router lưu `RouterContext` chứa:

   * ViewController
   * onNavigateBack callback

3. Gọi `navigationController.pushViewController(...)` để điều hướng

4. Khi VC bị pop (gesture / back button / gọi code):

   * `didMove(toParent: nil)` trong `BaseViewController` được gọi
   * `onPop?()` được gọi → `Router.executeClosure(...)` chạy
   * Callback `onNavigateBack` được gọi, và cleanup `RouterContext`

---

### 🧭 Present hoạt động thế nào?

Khi `presentationStyle == .present(...)`:

```swift
let nav = UINavigationController(rootViewController: viewController)
nav.modalPresentationStyle = style

let presentingRouter = Router(navigationController: nav)

parentRouter = router
router.present(drawable: nav, coordinator: coordinator, isAnimated: isAnimated, onDismiss: onFinish)
router = presentingRouter
```

#### Các bước:

1. Tạo `UINavigationController` chứa ViewController

2. Tạo `Router` mới để quản lý điều hướng trong modal flow

3. Gọi `present(...)` từ `parentRouter` → trình bày `nav` lên

4. Trong `Router.present(...)`:

   * Nếu VC cho phép delegate, gán `RouterPresentationDelegate` vào `presentationController?.delegate`
   * Lưu `RouterContext` chứa:

     * ViewController
     * onDismiss callback
     * delegate nếu có

5. Khi modal bị dismiss:

   * Nếu **dismiss bằng gesture**: delegate sẽ gọi `onDismiss` → `executeClosure(...)`
   * Nếu **VC gọi `.dismiss(...)` thủ công**: bạn phải gọi `Router.dismiss(...)` để trigger cleanup
  Dưới đây là phần cập nhật thêm cho mục **7 – Present hoạt động thế nào**, giải thích chính xác cơ chế dismiss toàn bộ flow khi present (ví dụ: `Step1` → `Step2` → `Step3`, muốn dismiss từ `Step3`, phải callback về `Step1` rồi dùng `parentRouter.dismiss(...)`).

#### 🔁 Dismiss toàn bộ flow đã được present

Trong flow present, ví dụ:

```

Step1 (presented)
└─ push → Step2
└─ push → Step3

````

Khi muốn dismiss toàn bộ flow này từ `Step3`, **không thể tự gọi dismiss tại Step3** — vì chỉ `Step1Coordinator` là thằng được `present(...)` thật sự.

✅ Giải pháp:

1. Tại `Step3`, callback ngược về `Step1` thông qua delegate (`FinishFlowPushDelegate`, hoặc dùng `findAncestor(...)`)
2. Tại `Step1Coordinator`, gọi:

```swift
parentRouter.dismiss(coordinator: self, isAnimated: true) { ... }
````

3. Router sẽ tìm VC tương ứng trong `RouterContext`, thực hiện dismiss modal và cleanup context.

➡️ Đây là lý do cần truyền đúng `parentRouter` lúc `present` để có thể dismiss chính xác coordinator gốc.

---

```swift
// Step3Coordinator
if let delegate = findAncestor(ofType: FinishFlowPushDelegate.self) {
    delegate.didFinishFlow()
}

// Step1Coordinator (conform FinishFlowPushDelegate)
func didFinishFlow() {
    if presentationStyle.isUsingPresent {
        parentRouter.dismiss(coordinator: self, isAnimated: true) { ... }
    }
}
```

⛔ Không gọi `.dismiss(...)` trực tiếp từ `Step3`, vì Step3 không được present trực tiếp → sẽ không dismiss đúng root và không cleanup được `RouterContext`.

---

```swift
// Trong Router.dismiss()
executeClosure(for: vc)
vc.dismiss(animated: isAnimated, completion: completion)
```

---

## Tóm lại:

### Push

* Gán `onPop` trong `BaseViewController`
* Khi bị pop, trigger `onNavigateBack` từ `RouterContext`

### Present

* Gán `presentationDelegate` để bắt gesture dismiss
* Nếu gọi `.dismiss(...)`, phải gọi `Router.dismiss(...)` để đảm bảo cleanup đúng cách

---

## 8. Giao tiếp từ Coordinator con về cha bằng findAncestor

Trong mô hình Coordinator của hệ thống này, mỗi Coordinator đều giữ `parentCoordinator`, vì vậy có thể duyệt ngược cây coordinator để tìm các "ancestor" phù hợp.

Hàm `findAncestor(ofType:)` đã được tích hợp sẵn:

```swift
extension Coordinator {
    func findAncestor<T>(ofType type: T.Type) -> T? {
        var current: Coordinator? = self.parentCoordinator
        while let currentCoordinator = current {
            if let match = currentCoordinator as? T {
                return match
            }
            current = currentCoordinator.parentCoordinator
        }
        return nil
    }
}
````

---

### ✅ Mục đích

Hàm này dùng để **giao tiếp từ Coordinator con về một coordinator cha bất kỳ trong cây**, mà không cần truyền delegate thủ công qua từng lớp.

---

### ✅ Cách dùng trong thực tế

#### VD 1: Gọi delegate đổi tabbar từ `Step3Coordinator`

```swift
if let eventHandler = self.findAncestor(ofType: TabbarDelegate.self) {
    eventHandler.changeTabbarTo(.tab1)
} else {
    print("⚠️ [Coordinator] No TabbarDelegate found in chain")
}
```

#### VD 2: Gọi delegate yêu cầu kết thúc flow (dismiss toàn bộ)

```swift
if let eventHandler = self.findAncestor(ofType: FinishFlowPushDelegate.self) {
    eventHandler.didFinishFlow()
} else {
    print("⚠️ [Coordinator] No FinishFlowCoordinatorDelegate found in chain")
}
```

---

### 📌 Ghi chú:

* `findAncestor(...)` chỉ hoạt động khi cây coordinator được thiết lập đúng:

  * `child.parentCoordinator = self`
  * `self.children.append(child)`

* Không cần dùng `[weak self]` khi gọi `findAncestor(...)`, vì nó không giữ strong reference mới nào.

---

### Ưu điểm:

* Không cần truyền delegate thủ công
* Dễ mở rộng và tái sử dụng
* Phù hợp với hệ thống coordinator dạng cây (tree)

---

## 9. Deeplink hoạt động thế nào

Hệ thống hỗ trợ deeplink thông qua cơ chế `DeeplinkPlugin`.

---

### ✅ Cách xử lý deeplink

1. Tại `AppDelegate`, gọi:

```swift
DeeplinkManager.shared.setup(delegate: appCoordinator)
````

2. Khi deeplink được trigger:

```swift
DeeplinkManager.shared.handle(url: url)
```

3. Hệ thống sẽ chọn plugin phù hợp:

```swift
plugins.first(where: { $0.isApplicable(component: component) })
```

4. Nếu đã đăng nhập:

   * Gọi `AppCoordinator.handleDeeplink(...)`
   * Tìm `topMostRouter` để present flow deeplink

```swift
if session.isLoggedIn, let topMostRouter = topMostRouter {
    performDeepLink(component: component, plugin: plugin, router: topMostRouter)
}
```

5. Nếu chưa đăng nhập:

   * Lưu deeplink vào `pendingDeeplink`
   * Sau khi login, deeplink sẽ được xử lý lại

---

### ✅ Tìm router đang active nhất

Trong `Coordinator` có sẵn tiện ích:

```swift
var topMostRouter: RouterProtocol? {
    (topMostCoordinator as? RouterCoordinator)?.router
}
```

Cách hoạt động:

* Duyệt đệ quy vào cây coordinator:

  * Nếu là `TabbarCoordinator`, lấy tab đang active (`currentTabCoordinator`)
  * Nếu là `BaseRouterCoordinator`, duyệt vào `children.last`
  * Trả về Router của coordinator ở cuối

→ Kết quả là **router đang hiển thị UI cuối cùng**, dùng để `present` hoặc `push` flow từ deeplink.

---

### ✅ Plugin tạo Coordinator:

Mỗi plugin sẽ triển khai hàm:

```swift
func buildCoordinator(component: DeeplinkPluginComponent, router: RouterProtocol) -> Coordinator?
```

→ Trả về coordinator tương ứng để handle deeplink đó, có thể là `PresentStep2Coordinator`, v.v.

```swift
coordinator.parentCoordinator = self
children.append(coordinator)
coordinator.start()
```

---

### 🔁 Tổng kết flow

```text
AppCoordinator
  |
  └── handleDeeplink(component, plugin)
         |
         └── buildCoordinator(...)
                |
                └── present/push từ topMostRouter
```

---





