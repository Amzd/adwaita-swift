//
//  WindowTitle.swift
//  Adwaita
//
//  Created by auto-generation on 02.05.24.
//

import CAdw
import LevenshteinTransformations

/// A helper widget for setting a window's title and subtitle.
/// 
/// <picture><source srcset="window-title-dark.png" media="(prefers-color-scheme: dark)"><img src="window-title.png" alt="window-title"></picture>
/// 
/// `AdwWindowTitle` shows a title and subtitle. It's intended to be used as the
/// title child of [class@Gtk.HeaderBar] or [class@HeaderBar].
/// 
/// ## CSS nodes
/// 
/// `AdwWindowTitle` has a single CSS node with name `windowtitle`.
public struct WindowTitle: Widget {

    /// Additional update functions for type extensions.
    var updateFunctions: [(ViewStorage, [(AnyView) -> AnyView], Bool) -> Void] = []
    /// Additional appear functions for type extensions.
    var appearFunctions: [(ViewStorage, [(AnyView) -> AnyView]) -> Void] = []

    /// The subtitle to display.
    /// 
    /// The subtitle should give the user additional details.
    var subtitle: String
    /// The title to display.
    /// 
    /// The title typically identifies the current view or content item, and
    /// generally does not use the application name.
    var title: String
    /// The application.
    var app: GTUIApp?
    /// The window.
    var window: GTUIApplicationWindow?

    /// The debug tree parameters.
    public var debugTreeParameters: [(String, value: CustomStringConvertible)] {
        [("subtitle", value: "\(subtitle)"), ("title", value: "\(title)"), ("app", value: "\(app)"), ("window", value: "\(window)")]
    }

    /// The debug tree's content.
    public var debugTreeContent: [(String, body: Body)] {
        var content: [(String, body: Body)] = []

        return content
    }

    /// Initialize `WindowTitle`.
    public init(subtitle: String, title: String) {
        self.subtitle = subtitle
        self.title = title
    }

    /// Get the widget's view storage.
    /// - Parameter modifiers: The view modifiers.
    /// - Returns: The view storage.
    public func container(modifiers: [(AnyView) -> AnyView]) -> ViewStorage {
        let storage = ViewStorage(adw_window_title_new(title, subtitle)?.opaque())
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

            if updateProperties {
                adw_window_title_set_subtitle(widget, subtitle)
            }
            if updateProperties {
                adw_window_title_set_title(widget, title)
            }


        }
        for function in updateFunctions {
            function(storage, modifiers, updateProperties)
        }
    }

    /// The subtitle to display.
    /// 
    /// The subtitle should give the user additional details.
    public func subtitle(_ subtitle: String) -> Self {
        var newSelf = self
        newSelf.subtitle = subtitle
        
        return newSelf
    }

    /// The title to display.
    /// 
    /// The title typically identifies the current view or content item, and
    /// generally does not use the application name.
    public func title(_ title: String) -> Self {
        var newSelf = self
        newSelf.title = title
        
        return newSelf
    }

}
