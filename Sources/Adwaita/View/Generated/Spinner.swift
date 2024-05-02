//
//  Spinner.swift
//  Adwaita
//
//  Created by auto-generation on 02.05.24.
//

import CAdw
import LevenshteinTransformations

/// A `GtkSpinner` widget displays an icon-size spinning animation.
/// 
/// It is often used as an alternative to a [class@Gtk.ProgressBar]
/// for displaying indefinite activity, instead of actual progress.
/// 
/// ![An example GtkSpinner](spinner.png)
/// 
/// To start the animation, use [method@Gtk.Spinner.start], to stop it
/// use [method@Gtk.Spinner.stop].
/// 
/// # CSS nodes
/// 
/// `GtkSpinner` has a single CSS node with the name spinner.
/// When the animation is active, the :checked pseudoclass is
/// added to this node.
public struct Spinner: Widget {

    /// Additional update functions for type extensions.
    var updateFunctions: [(ViewStorage, [(AnyView) -> AnyView], Bool) -> Void] = []
    /// Additional appear functions for type extensions.
    var appearFunctions: [(ViewStorage, [(AnyView) -> AnyView]) -> Void] = []

    /// The accessible role of the given `GtkAccessible` implementation.
    /// 
    /// The accessible role cannot be changed once set.
    var accessibleRole: String?
    /// Whether the spinner is spinning
    var spinning: Bool?
    /// The application.
    var app: GTUIApp?
    /// The window.
    var window: GTUIApplicationWindow?

    /// The debug tree parameters.
    public var debugTreeParameters: [(String, value: CustomStringConvertible)] {
        [("accessibleRole", value: "\(accessibleRole)"), ("spinning", value: "\(spinning)"), ("app", value: "\(app)"), ("window", value: "\(window)")]
    }

    /// The debug tree's content.
    public var debugTreeContent: [(String, body: Body)] {
        var content: [(String, body: Body)] = []

        return content
    }

    /// Initialize `Spinner`.
    public init() {
    }

    /// Get the widget's view storage.
    /// - Parameter modifiers: The view modifiers.
    /// - Returns: The view storage.
    public func container(modifiers: [(AnyView) -> AnyView]) -> ViewStorage {
        let storage = ViewStorage(gtk_spinner_new()?.opaque())
        update(storage, modifiers: modifiers, updateProperties: true)

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

            if let spinning, updateProperties {
                gtk_spinner_set_spinning(widget, spinning.cBool)
            }


        }
        for function in updateFunctions {
            function(storage, modifiers, updateProperties)
        }
    }

    /// The accessible role of the given `GtkAccessible` implementation.
    /// 
    /// The accessible role cannot be changed once set.
    public func accessibleRole(_ accessibleRole: String?) -> Self {
        var newSelf = self
        newSelf.accessibleRole = accessibleRole
        
        return newSelf
    }

    /// Whether the spinner is spinning
    public func spinning(_ spinning: Bool? = true) -> Self {
        var newSelf = self
        newSelf.spinning = spinning
        
        return newSelf
    }

}
