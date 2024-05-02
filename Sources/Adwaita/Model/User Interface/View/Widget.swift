//
//  Widget.swift
//  Adwaita
//
//  Created by david-swift on 16.08.23.
//

/// A widget is a view that know about its GTUI widget.
public protocol Widget: AnyView {

    /// The debug tree parameters.
    var debugTreeParameters: [(String, value: CustomStringConvertible)] { get }
    /// The debug tree's content.
    var debugTreeContent: [(String, body: Body)] { get }
    /// The view storage.
    /// - Parameter modifiers: Modify views before being updated.
    func container(modifiers: [(AnyView) -> AnyView]) -> ViewStorage
    /// Update the stored content.
    /// - Parameters:
    ///     - storage: The storage to update.
    ///     - modifiers: Modify views before being updated
    ///     - updateProperties: Whether to update the view's properties.
    func update(_ storage: ViewStorage, modifiers: [(AnyView) -> AnyView], updateProperties: Bool)

}

extension Widget {

    /// A widget's view is empty.
    public var viewContent: Body { [] }

    /// A description of the view.
    public func getViewDescription(parameters: Bool) -> String {
        var content = ""
        for element in debugTreeContent {
            if content.isEmpty {
                content += """
                 {
                    \(indented: element.body.getDebugTree(parameters: parameters))
                }
                """
            } else {
                content += """
                 \(element.0): {
                    \(indented: element.body.getDebugTree(parameters: parameters))
                }
                """
            }
        }
        if parameters {
            let parametersString = debugTreeParameters.map { "\($0.0): \($0.value)" }.joined(separator: ", ")
            return "\(Self.self)(\(parametersString))\(content)"
        }
        return "\(Self.self)\(content)"
    }

}
