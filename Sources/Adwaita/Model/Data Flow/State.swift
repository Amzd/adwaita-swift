//
//  State.swift
//  Adwaita
//
//  Created by david-swift on 06.08.23.
//

import CAdw
import Foundation

/// A property wrapper for properties in a view that should be stored throughout view updates.
@propertyWrapper
public struct State<Value>: StateProtocol {

    /// Access the stored value. This updates the views when being changed.
    public var wrappedValue: Value {
        get {
            rawValue
        }
        nonmutating set {
            rawValue = newValue
            content.storage.update = true
            Self.updateViews(force: forceUpdates)
        }
    }

    /// Get the value as a binding using the `$` prefix.
    public var projectedValue: Binding<Value> {
        .init {
            wrappedValue
        } set: { newValue in
            self.wrappedValue = newValue
        }
    }

    // swiftlint:disable force_cast
    /// Get and set the value without updating the views.
    public var rawValue: Value {
        get {
            content.storage.value as! Value
        }
        nonmutating set {
            content.storage.value = newValue
            writeValue?(newValue)
        }
    }
    // swiftlint:enable force_cast

    /// The stored value.
    public let content: State<Any>.Content

    /// Whether to force update the views when the value changes.
    public var forceUpdates: Bool

    /// The function for updating the value in the settings file.
    private var writeValue: ((Value) -> Void)?

    /// The value with an erased type.
    public var value: Any {
        get {
            wrappedValue
        }
        nonmutating set {
            if let newValue = newValue as? Value {
                content.storage.value = newValue
            }
        }
    }

    /// Initialize a property representing a state in the view with an autoclosure.
    /// - Parameters:
    ///     - wrappedValue: The wrapped value.
    ///     - forceUpdates: Whether to force update all available views when the property gets modified.
    public init(wrappedValue: @autoclosure @escaping () -> Value, forceUpdates: Bool = false) {
        content = .init(getInitialValue: wrappedValue)
        self.forceUpdates = forceUpdates
    }

    /// A class storing the state's content.
    public class Content {

        /// The storage.
        public var storage: Storage {
            get {
                if let internalStorage {
                    return internalStorage
                }
                let value = getInitialValue()
                let storage = Storage(value: value)
                internalStorage = storage
                return storage
            }
            set {
                internalStorage = newValue
            }
        }
        /// The internal storage.
        var internalStorage: Storage?
        /// The initial value.
        private var getInitialValue: () -> Any

        /// Initialize the content without already initializing the storage or initializing the value.
        /// - Parameter initialValue: The initial value.
        public init(getInitialValue: @escaping () -> Value) {
            self.getInitialValue = getInitialValue
        }

    }

    /// A class storing the value.
    public class Storage {

        /// The stored value.
        public var value: Any
        /// Whether to update the affected views.
        public var update = false

        /// Initialize the storage.
        /// - Parameters:
        ///     - value: The value.
        public init(value: Any) {
            self.value = value
        }

    }

    /// Update all of the views.
    /// - Parameter force: Whether to force all views to update.
    public static func updateViews(force: Bool = false) {
        UpdateManager.updateViews(force: force)
    }

    /// The directory used for storing user data.
    /// - Returns: The URL.
    public static func userDataDir() -> URL {
        .init(fileURLWithPath: .init(cString: g_get_user_data_dir()))
    }

    /// Copy a text to the clipboard.
    /// - Parameter text: The text.
    public static func copy(_ text: String) {
        let clipboard = gdk_display_get_clipboard(gdk_display_get_default())
        gdk_clipboard_set_text(clipboard, text)
    }

    /// Get the settings directory path.
    /// - Returns: The path.
    private static func dirPath(folder: String?) -> URL {
        Self.userDataDir()
            .appendingPathComponent(folder ?? GTUIApp.appID, isDirectory: true)
    }

    /// Get the settings file path.
    /// - Returns: The path.
    private static func filePath(key: String, folder: String?) -> URL {
        dirPath(folder: folder).appendingPathComponent("\(key ?? "temporary").json")
    }

}

extension State where Value: Codable {

    /// Initialize a property representing a state in the view.
    /// - Parameters:
    ///     - wrappedValue: The wrapped value.
    ///     - key: The unique storage key of the property.
    ///     - folder: The path to the folder containing the JSON file.
    ///     - forceUpdates: Whether to force update all available views when the property gets modified.
    ///
    /// The folder path will be appended to the XDG data home directory.
    public init(
        wrappedValue: @autoclosure @escaping () -> Value,
        _ key: String,
        folder: String? = nil,
        forceUpdates: Bool = false
    ) {
        content = .init {
            if let value = Self.readValue(key: key, folder: folder) {
                return value
            }
            return wrappedValue()
        }
        self.forceUpdates = forceUpdates
        self.writeValue = { Self.writeCodableValue(key: key, folder: folder, value: $0) }
        Self.checkFile(key: key, folder: folder)
    }

    /// Check whether the settings file exists, and, if not, create it.
    private static func checkFile(key: String, folder: String?) {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dirPath(folder: folder).path) {
            try? fileManager.createDirectory(
                at: .init(fileURLWithPath: dirPath(folder: folder).path),
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        if !fileManager.fileExists(atPath: filePath(key: key, folder: folder).path) {
            fileManager.createFile(atPath: filePath(key: key, folder: folder).path, contents: .init(), attributes: nil)
        }
    }

    /// Update the local value with the value from the file.
    private static func readValue(key: String, folder: String?) -> Value? {
        let data = try? Data(contentsOf: filePath(key: key, folder: folder))
        if let data, let value = try? JSONDecoder().decode(Value.self, from: data) {
            return value
        }
        return nil
    }

    /// Update the value on the file with the local value.
    private static func writeCodableValue(key: String, folder: String?, value: Value) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(value)
        try? data?.write(to: filePath(key: key, folder: folder))
    }

}
