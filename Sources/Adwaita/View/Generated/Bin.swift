//
//  Bin.swift
//  Adwaita
//
//  Created by auto-generation on 02.05.24.
//

import CAdw
import LevenshteinTransformations

/// A widget with one child.
/// 
/// <picture><source srcset="bin-dark.png" media="(prefers-color-scheme: dark)"><img src="bin.png" alt="bin"></picture>
/// 
/// The `AdwBin` widget has only one child, set with the [property@Bin:child]
/// property.
/// 
/// It is useful for deriving subclasses, since it provides common code needed
/// for handling a single child widget.
public struct Bin: Widget {

    /// Additional update functions for type extensions.
    var updateFunctions: [(ViewStorage, [(AnyView) -> AnyView], Bool) -> Void] = []
    /// Additional appear functions for type extensions.
    var appearFunctions: [(ViewStorage, [(AnyView) -> AnyView]) -> Void] = []

    /// The child widget of the `AdwBin`.
    var child:  (() -> Body)?
    /// The application.
    var app: GTUIApp?
    /// The window.
    var window: GTUIApplicationWindow?

    /// The debug tree parameters.
    public var debugTreeParameters: [(String, value: CustomStringConvertible)] {
        [("app", value: "\(app)"), ("window", value: "\(window)")]
    }

    /// The debug tree's content.
    public var debugTreeContent: [(String, body: Body)] {
        var content: [(String, body: Body)] = [("child", body: self.child?() ?? []),]

        return content
    }

    /// Initialize `Bin`.
    public init() {
    }

    /// Get the widget's view storage.
    /// - Parameter modifiers: The view modifiers.
    /// - Returns: The view storage.
    public func container(modifiers: [(AnyView) -> AnyView]) -> ViewStorage {
        let storage = ViewStorage(adw_bin_new()?.opaque())
        update(storage, modifiers: modifiers, updateProperties: true)
        if let childStorage = child?().widget(modifiers: modifiers).storage(modifiers: modifiers) {
            storage.content["child"] = [childStorage]
            adw_bin_set_child(storage.pointer?.cast(), childStorage.pointer?.cast())
        }

        for function in appearFunctions {
            function(storage, modifiers)
        }
        return storage
    }

    /// Update the widget's view storage.
    /// - Parameters:
    ///     - storage: The view storage.
    ///     - modifiers: The view modifiers.
    ///     - updateProperties: Whether to update the view's properties.
    public func update(_ storage: ViewStorage, modifiers: [(AnyView) -> AnyView], updateProperties: Bool) {
        storage.modify { widget in

            if let widget = storage.content["child"]?.first {
                child?().widget(modifiers: modifiers).update(widget, modifiers: modifiers, updateProperties: updateProperties)
            }


        }
        for function in updateFunctions {
            function(storage, modifiers, updateProperties)
        }
    }

    /// The child widget of the `AdwBin`.
    public func child(@ViewBuilder _ child: @escaping (() -> Body)) -> Self {
        var newSelf = self
        newSelf.child = child
        
        return newSelf
    }

}
