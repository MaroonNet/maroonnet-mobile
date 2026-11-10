//
//  AssignmentStoreTests.swift
//  MaroonNet Field
//
//  MaroonNet: checks how the store keeps, replaces and rejects assignments.
//

import Testing
import CoreLocation
import Foundation
@testable import Meshtastic

@MainActor
@Suite("MaroonNet assignment store")
struct AssignmentStoreTests {

	private func c(_ latitude: Double, _ longitude: Double) -> CLLocationCoordinate2D {
		CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}

	private func square(id: Int, name: String) -> Assignment {
		Assignment(id: id, name: name,
				   corners: [c(39.735, -104.995), c(39.735, -104.985), c(39.745, -104.985), c(39.745, -104.995)],
				   receivedAt: Date())
	}

	@Test("A received assignment is stored and becomes current")
	func receiveStores() {
		let store = AssignmentStore()
		#expect(store.receive(square(id: 7, name: "Sector B2")))
		#expect(store.assignments.count == 1)
		#expect(store.current?.id == 7)
	}

	@Test("Same ID replaces the old assignment")
	func sameIDReplaces() {
		let store = AssignmentStore()
		store.receive(square(id: 7, name: "Sector B2"))
		store.receive(square(id: 7, name: "Sector B2 revised"))
		#expect(store.assignments.count == 1)
		#expect(store.current?.name == "Sector B2 revised")
	}

	@Test("A different ID is kept too, and the newest is current")
	func differentIDKept() {
		let store = AssignmentStore()
		store.receive(square(id: 7, name: "Sector B2"))
		store.receive(square(id: 8, name: "Sector C1"))
		#expect(store.assignments.count == 2)
		#expect(store.current?.id == 8)
	}

	@Test("An area with too few corners is rejected and changes nothing")
	func invalidRejected() {
		let store = AssignmentStore()
		let line = Assignment(id: 9, name: "Bad", corners: [c(39.74, -104.99), c(39.75, -104.98)], receivedAt: Date())
		#expect(!store.receive(line))
		#expect(store.assignments.isEmpty)
		#expect(store.current == nil)
	}

	@Test("Assignment.contains uses the sector geometry")
	func containsPosition() {
		let area = square(id: 7, name: "Sector B2")
		#expect(area.contains(c(39.740, -104.990)))
		#expect(!area.contains(c(39.740, -104.980)))
	}

	@Test("removeAll clears every assignment")
	func clearAll() {
		let store = AssignmentStore()
		store.receive(square(id: 7, name: "Sector B2"))
		store.removeAll()
		#expect(store.assignments.isEmpty)
		#expect(store.current == nil)
	}
}
