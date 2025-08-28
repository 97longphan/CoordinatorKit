// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "CoordinatorKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CoordinatorKit",
            targets: ["CoordinatorKit"]
        )
    ],
    targets: [
        .target(
            name: "CoordinatorKit",
            path: "Sources/CoordinatorKit"
        )
    ]
)
