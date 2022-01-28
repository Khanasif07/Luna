//
//  PairLunaCgmSimulatorViewModel.swift
//  Luna
//
//  Created by Francis Pascual on 1/27/22.
//

import Combine
import Foundation


class PairLunaCgmSimulatorViewModel : ObservableObject {
    private let scanner: PairingScannerInteractor
    
    private var scanResultsDictionary: Dictionary<UUID, ViewScanResult> = [:]
    @Published var scanResults : [ViewScanResult] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(scanner: PairingScannerInteractor) {
        self.scanner = scanner
        scanner.scanResults
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { error in
                
            }, receiveValue: { result in
                self.scanResultsDictionary[result.id] = result
                self.scanResults = Array(self.scanResultsDictionary.values)
            })
            .store(in: &cancellables)
    }
    
    func scan() {
        clear()
        scanner.scan()
    }
    
    func stopScan() {
        scanner.stopScan()
    }
    
    private func clear() {
        scanResultsDictionary = [:]
        scanResults = []
    }
}

#if DEBUG

extension PairLunaCgmSimulatorViewModel {
    static var preview : PairLunaCgmSimulatorViewModel {
        PairLunaCgmSimulatorViewModel(scanner: MockBleScanInteractor())
    }
}

#endif
