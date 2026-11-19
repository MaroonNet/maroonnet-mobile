//
//  Assignment.swift
//  MaroonNet Field
//
//  MaroonNet: a search assignment from the command post, and the store that keeps the
//  searcher's current assignments. The packet decoder puts assignments in; the map and
//  the Inside / Outside banner read them out.
//

import CoreLocation
import Foundation
import Observation

/// One search assignment: an area given as 3 to 5 corner points, in order around the edge.
struct Assignment: Identifiable {
	let id: Int
	let name: String
	let corners: [CLLocationCoordinate2D]
	let receivedAt: Date

	/// True when the corners describe an area MaroonNet accepts (3 to 5 points).
    /// Corner counts allowed for a sector (packet record v1.2, Section 3).
    static let allowedCornerCounts = 3...24

    var isValid: Bool {
        Self.allowedCornerCounts.contains(corners.count)
	}

	/// True when `position` is inside this assignment's area.
	func contains(_ position: CLLocationCoordinate2D) -> Bool {
		SectorGeometry.contains(position, corners: corners)
	}
}

/// Keeps the searcher's assignments. A new assignment with an ID already held replaces
/// the old one (agreed with the command post, assignment packet record point 6).
@MainActor @Observable
final class AssignmentStore {
	static let shared: AssignmentStore = {
		let store = AssignmentStore()
		#if DEBUG
		// Test builds start with a demo area, so the map and banner can be tried without a radio.
		store.receive(.demo)
		#endif
		return store
	}()

	/// Every assignment received, by ID.
	private(set) var assignments: [Int: Assignment] = [:]

	/// The most recently received valid assignment. The map shows this one.
	private(set) var current: Assignment?

	/// Stores `assignment` and makes it current. Returns false, and changes nothing,
	/// if the assignment is not a valid area.
	@discardableResult
	func receive(_ assignment: Assignment) -> Bool {
		guard assignment.isValid else { return false }
		assignments[assignment.id] = assignment
		current = assignment
		return true
	}

	/// Forgets every assignment, for example at the end of a mission.
	func removeAll() {
		assignments.removeAll()
		current = nil
	}
}
