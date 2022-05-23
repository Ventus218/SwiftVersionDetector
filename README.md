# SwiftVersionDetector

<!-- Badges -->

<p>
    <img src="https://img.shields.io/badge/Swift-5.0+-F06C33.svg" />
    <img src="https://img.shields.io/badge/macOS-10.10+-179AC8.svg" />
    <img src="https://img.shields.io/badge/Linux-compatible-blueviolet" />
    <a href="https://github.com/apple/swift-package-manager">
      <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" />
    </a>
</p>

**SwiftVersionDetector** allows you to detect Swift version at runtime.

Note that detecting the Swift version of the machine on which your app is being executed is extremely different from [Swift conditional compilation](https://docs.swift.org/swift-book/ReferenceManual/Statements.html#ID538) which allows to get Swift version only at compile-time.

## Usage

```swift
let version = try SwiftVersionDetector.detectRuntimeSwiftVersion()
print(version.major) // Prints "5"
print(version.minor) // Prints "3"
print(version) // Prints "Swift version 5.3"
```

## Installation

### Xcode Projects

Select `File` -> `Swift Packages` -> `Add Package Dependency` and enter `https://github.com/Ventus218/SwiftVersionDetector`.

### Swift Package Manager Projects

You can add `SwiftVersionDetector` as a package dependency in your `Package.swift` file:

Remember to update the version :)

```swift
let package = Package(
    //...
    dependencies: [
        .package(url: "https://github.com/Ventus218/SwiftVersionDetector", from: "x.y.z"),
    ],
    //...
)
```

From there, refer to the `SwiftVersionDetector` "product" delivered by the `SwiftVersionDetector` "package" inside of any of your project's target dependencies:

```swift
targets: [
    .target(
        name: "YourAppName",
        dependencies: [
            .product(
                name: "SwiftVersionDetector",
                package: "SwiftVersionDetector"
            ),
        ],
        ...
    ),
    ...
]
```

<!-- Proceed from above choice accordingly (and delete this comment) -->

Then simply `import SwiftVersionDetector` wherever you’d like to use it.

## Contributing

Contributions to `SwiftVersionDetector` are most welcome. Check out some of the [issue templates](./.github/ISSUE_TEMPLATES/) for more info.

## License

`SwiftVersionDetector` is available under the MIT license. See the [LICENSE file](./LICENSE.txt) for more info.
