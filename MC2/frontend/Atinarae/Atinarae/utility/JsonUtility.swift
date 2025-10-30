//
//  JsonUtility.swift
//  Atinarae
//
//  Created by HyunwooPark on 2023/05/04.
//

import UIKit
import SwiftUI

private func readLocalFile(forName name: String) -> Data? {
    do {
        if let bundlePath = Bundle.main.path(forResource: name,
                                             ofType: "json"),
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
            return jsonData
        }
    } catch {
        print(error)
    }
    
    return nil
}
