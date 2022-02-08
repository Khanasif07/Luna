//
//  LunaCgmSimulatorService.swift
//  Luna
//
//  Created by Francis Pascual on 1/30/22.
//

import Combine
import Foundation
import LunaBluetooth

class LunaCgmSimulatorService {
    private let central: BluetoothCentral<SimulatorPeripheral>
    private let glucoseRepository: GlucoseWriteRepository
    private let queue: DispatchQueue
    private var activationCancellable: AnyCancellable? = nil
    private var glucoseCancellables: Dictionary<UUID, AnyCancellable> = [:]
    
    init(glucoseRepository: GlucoseWriteRepository, queue: DispatchQueue) {
        self.central = BluetoothCentral<SimulatorPeripheral>(centralId: "LunaCgmSimulator", queue: queue)
        self.glucoseRepository = glucoseRepository
        self.queue = queue

        activationCancellable = central.peripheralEvents
            .receive(on: queue)
            .sink { event in
                switch(event) {
                case .activated(let peripheral):
                    self.glucoseCancellables[peripheral.id] = peripheral.latestGlucose
                        .receive(on: queue)
                        .sink(receiveValue: { bleGlucose in
                            self.recordGlucose(peripheralId: peripheral.id, bleGlucose: bleGlucose)
                        })
                case .deactivated(peripheral: let peripheral):
                    self.glucoseCancellables[peripheral.id] = nil
                }
            }
    }
    
    var scanResults: AnyPublisher<ScanResult<SimulatorPeripheral>, Never> {
        central.scanResults
    }
    
    var peripheralEvents : AnyPublisher<PeripheralEvent<SimulatorPeripheral>, Never> {
        central.peripheralEvents
    }
    
    func restore(deviceId: UUID) {
        central.restoreConnect(to: deviceId)
    }
    
    func scan() {
        central.scan()
    }
    
    func stopScan() {
        central.stopScan()
    }

    func connect(to peripheral: SimulatorPeripheral) {
        central.connect(to: peripheral)
    }
    
    func disconnect(from peripheralId: UUID) {
        central.disconnect(from: peripheralId)
    }
    
    private func recordGlucose(peripheralId: UUID, bleGlucose: BleSimulatorGlucose?) {
        guard let bleGlucose = bleGlucose else { return }
        let glucose = bleGlucose.toGlucose()
        
        let record = Record(
            value: glucose,
            sourceId: peripheralId.uuidString,
            sourceType: GlucoseSource.lunaCgmSimulator,
            sourceEntityId: bleGlucose.entityId,
            receiveTime: Date(),
            timeZone: TimeZone.current
        )
        Task {
            do {
                try await glucoseRepository.writeGlucose(records: [record])
            } catch {
                print("Failed to write glucose")
            }
        }
    }
}
