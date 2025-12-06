//
//  CitySearchCompleter.swift
//  Sora
//
//  Created by Chernokoz on 06.12.2025.
//

import Foundation
import MapKit
import Combine

final class CitySearchCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    
    @Published var completions: [CitySearchCompletion] = []
    
    private let completer = MKLocalSearchCompleter()

    @Published var queryFragment: String = "" {
        didSet {
            if queryFragment.isEmpty {
                completions = []
            } else {
                completer.queryFragment = queryFragment
            }
        }
    }
    
    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = .address
    }
    
    // MARK: - MKLocalSearchCompleterDelegate
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completions = completer.results
            .filter { $0.title.lowercased().starts(with: self.queryFragment.lowercased()) }
            .map {
                let subtitle = $0.subtitle.components(separatedBy: ", ").last ?? $0.subtitle
                return CitySearchCompletion(title: $0.title, subtitle: subtitle)
            }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Ошибка автодополнения: \(error.localizedDescription)")
    }
}
