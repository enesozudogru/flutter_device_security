# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]
- iOS biometric authentication support
- Rooted/jailbroken device detection
- VPN detection capabilities

## [0.0.2] - 2026-01-02

### Added
- Comprehensive API documentation for all public classes and methods
- Library-level documentation with detailed descriptions
- Method parameter and return value documentation
- Platform interface documentation improvements

### Changed
- Enhanced documentation coverage to meet pub.dev requirements (>20%)
- Improved code readability with detailed comments

### Fixed
- MaterialApp integration in example app
- Directionality widget missing error resolved
- Proper widget structure implementation

## [0.0.1] - 2026-01-02
- iOS biometric authentication support
- Rooted/jailbroken device detection
- VPN detection capabilities

### Added
- Initial release of Flutter Device Security plugin
- Device lock detection (PIN, pattern, password)
- Android USB debugging detection
- Device version verification with remote API
- Android biometric authentication check
- Platform-specific implementations for Android and iOS
- Comprehensive error handling
- Example application with UI

### Platform Support
- **Android**: Device lock, USB debugging, biometric, OS version
- **iOS**: Device lock, OS version

### Dependencies
- plugin_platform_interface: ^2.0.2
- dio: ^5.9.0
