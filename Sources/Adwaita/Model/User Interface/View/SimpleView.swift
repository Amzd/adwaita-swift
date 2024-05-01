//
//  SimpleView.swift
//  Adwaita
//
//  Created by david-swift on 28.04.24.
//

/// A structure conforming to `SimpleView` is referred to as a view.
/// It can be part of a body.
///
/// ```swift
/// struct Test: SimpleView {
///
///     var view: Body {
///         AnotherView()
///     }
///
/// }
/// ```
///
/// A simple view cannot save state. Use ``View`` for saving state.
///
public protocol SimpleView: AnyView {

    /// The view's content.
    @ViewBuilder var view: Body { get }

}

extension SimpleView {

    /// The view's content.
    public var viewContent: Body {
        view
    }

}
