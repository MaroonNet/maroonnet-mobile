//
//  SectorGeometryTests.swift
//  MaroonNet Field
//
//  MaroonNet: checks SectorGeometry.contains with hand-worked shapes near Denver.
//

import Testing
import CoreLocation
@testable import Meshtastic

@Suite("MaroonNet sector geometry")
struct SectorGeometryTests {

	/// Shorthand for a coordinate: latitude first, then longitude.
	private func c(_ latitude: Double, _ longitude: Double) -> CLLocationCoordinate2D {
		CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}

	/// A square about 1 km across.
	private var square: [CLLocationCoordinate2D] {
		[c(39.735, -104.995), c(39.735, -104.985), c(39.745, -104.985), c(39.745, -104.995)]
	}

	/// A "U" open to the north: two arms with a notch between them.
	private var uShape: [CLLocationCoordinate2D] {
		[c(39.70, -105.00), c(39.70, -104.97), c(39.73, -104.97), c(39.73, -104.98),
		 c(39.71, -104.98), c(39.71, -104.99), c(39.73, -104.99), c(39.73, -105.00)]
	}

	@Test("Point in the middle of a square is inside")
	func insideSquare() {
		#expect(SectorGeometry.contains(c(39.740, -104.990), corners: square))
	}

	@Test("Point east of a square is outside")
	func eastOfSquare() {
		#expect(!SectorGeometry.contains(c(39.740, -104.980), corners: square))
	}

	@Test("Point west of a square is outside (line crosses two edges)")
	func westOfSquare() {
		#expect(!SectorGeometry.contains(c(39.740, -105.000), corners: square))
	}

	@Test("Corner order does not matter")
	func reversedCorners() {
		#expect(SectorGeometry.contains(c(39.740, -104.990), corners: square.reversed()))
	}

	@Test("Point in the notch of a U is outside")
	func uNotch() {
		#expect(!SectorGeometry.contains(c(39.72, -104.985), corners: uShape))
	}

	@Test("Point in an arm of a U is inside")
	func uArm() {
		#expect(SectorGeometry.contains(c(39.72, -104.995), corners: uShape))
	}

	@Test("Five-corner sector works")
	func pentagon() {
		let pentagon = [c(39.74, -105.00), c(39.74, -104.98), c(39.75, -104.97), c(39.76, -104.99), c(39.75, -105.01)]
		#expect(SectorGeometry.contains(c(39.75, -104.99), corners: pentagon))
		#expect(!SectorGeometry.contains(c(39.765, -104.99), corners: pentagon))
	}

	@Test("Fewer than three corners is not an area")
	func tooFewCorners() {
		#expect(!SectorGeometry.contains(c(39.74, -104.99), corners: Array(square.prefix(2))))
	}
}
