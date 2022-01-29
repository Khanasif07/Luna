//
//  GlucoseReadRepository.swift
//  Luna
//
//  Created by Francis Pascual on 1/29/22.
//

import Foundation
import Combine

protocol GlucoseReadRepository {
    func getLatestGlucose() async throws -> Glucose?
    var latestGlucose: AnyPublisher<Glucose?, Error> { get }
    func observeGlucoseRange(start: Date, endExclusive: Date) -> AnyPublisher<[Glucose], Error>
    func getGlucoseRange(start: Date, endExclusive: Date) async throws -> [Glucose]
    func getGlucoseReceivedSince(_ time: Date, filter: DateInterval) async throws -> [ReceiveTimeRecord<Glucose>]
}

protocol GlucoseWriteRepository {
    func writeGlucose(records: [Record<Glucose>]) async throws
    func deleteAllGlucose(sourceId: String) async throws
}
