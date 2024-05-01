//
//  PictureDemo.swift
//  Adwaita
//
//  Created by david-swift on 21.04.24.
//

// swiftlint:disable missing_docs

import Adwaita
import Foundation

struct PictureDemo: SimpleView {

    var url: URL?
    var app: GTUIApp
    var window: GTUIWindow

    var data: Data {
        guard let url, let data = try? Data(contentsOf: url)  else {
            return .init()
        }
        return data
    }

    var view: Body {
        Picture()
            .data(data)
        Button("Import") {
            app.addWindow("picture", parent: window)
        }
        .halign(.center)
        .style("pill")
        .style("suggested-action")
        .padding()
    }

}

// swiftlint:enable missing_docs
