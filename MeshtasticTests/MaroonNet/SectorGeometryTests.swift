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

	/// A diamond (square turned 45°): every edge is slanted.
	/// North 39.750, east -104.975, south 39.730, west -105.005.
	private var diamond: [CLLocationCoordinate2D] {
		[c(39.750, -104.990), c(39.740, -104.975), c(39.730, -104.990), c(39.740, -105.005)]
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

	@Test("Clockwise or counterclockwise gives the same answer")
	func reversedCorners() {
		#expect(SectorGeometry.contains(c(39.740, -104.990), corners: square.reversed()))
		#expect(!SectorGeometry.contains(c(39.740, -104.980), corners: square.reversed()))
	}

	@Test("Corners out of order describe a different shape")
	func shuffledCorners() {
		// Swapping two corners turns the square into a bow tie (two triangles meeting in the
		// middle). A point near the middle of the bottom edge is inside the square but outside
		// the bow tie: contains trusts the order it is given.
		let bowTie = [square[0], square[2], square[1], square[3]]
		let nearBottomMiddle = c(39.736, -104.990)
		#expect(SectorGeometry.contains(nearBottomMiddle, corners: square))
		#expect(!SectorGeometry.contains(nearBottomMiddle, corners: bowTie))
	}

	@Test("Point in the notch of a U is outside")
	func uNotch() {
		#expect(!SectorGeometry.contains(c(39.72, -104.985), corners: uShape))
	}

	@Test("Point in an arm of a U is inside")
	func uArm() {
		#expect(SectorGeometry.contains(c(39.72, -104.995), corners: uShape))
	}

	@Test("Three-corner sector works")
	func triangle() {
		let triangle = [c(39.735, -104.995), c(39.735, -104.985), c(39.745, -104.990)]
		#expect(SectorGeometry.contains(c(39.738, -104.990), corners: triangle))
		// Near the top, just west of the slanted left edge (which crosses 39.744 at -104.9905).
		#expect(!SectorGeometry.contains(c(39.744, -104.993), corners: triangle))
	}

	@Test("Slanted edges: just inside and just outside")
	func slantedEdges() {
		// Test latitudes (39.745, 39.733) match no corner, so each answer depends on where
		// a slanted edge crosses that latitude. Inside and outside points are about 40 m apart.
		// North-east edge crosses 39.745 at -104.9825.
		#expect(SectorGeometry.contains(c(39.745, -104.9830), corners: diamond))
		#expect(!SectorGeometry.contains(c(39.745, -104.9820), corners: diamond))
		// North-west edge crosses 39.745 at -104.9975.
		#expect(SectorGeometry.contains(c(39.745, -104.9970), corners: diamond))
		#expect(!SectorGeometry.contains(c(39.745, -104.9980), corners: diamond))
		// South-east edge crosses 39.733 at -104.9855.
		#expect(SectorGeometry.contains(c(39.733, -104.9860), corners: diamond))
		#expect(!SectorGeometry.contains(c(39.733, -104.9850), corners: diamond))
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
