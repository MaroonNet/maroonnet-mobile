//
//  SectorGeometry.swift
//  MaroonNet Field
//
//  MaroonNet: geometry for search sectors. A sector arrives as 4–5 corner points;
//  the phone decides by itself whether the searcher is inside it.
//

import CoreLocation

enum SectorGeometry {

	/// Returns true when `point` lies inside the polygon formed by `corners`.
	///
	/// Corners are listed in order around the edge (either direction); the last corner
	/// connects back to the first. Fewer than 3 corners is not an area, so the answer is false.
	///
	/// Ray casting: from the point, look along a line to the east and count how many polygon
	/// edges it crosses. Odd means inside, even means outside. Latitude and longitude are
	/// treated as flat y and x, which is accurate for sectors a few kilometres across.
	/// Not meant for areas that cross the 180° meridian or reach a pole.
	static func contains(_ point: CLLocationCoordinate2D, corners: [CLLocationCoordinate2D]) -> Bool {
		guard corners.count >= 3 else { return false }

		var inside = false
		var previous = corners.count - 1
		for current in 0..<corners.count {
			let a = corners[current]
			let b = corners[previous]

			// Does edge a–b reach across the point's latitude (one end above, one end below)?
			if (a.latitude > point.latitude) != (b.latitude > point.latitude) {
				// Where along that latitude does the edge cross? (straight-line interpolation)
				let fraction = (point.latitude - a.latitude) / (b.latitude - a.latitude)
				let crossingLongitude = a.longitude + fraction * (b.longitude - a.longitude)

				// Count it only if the crossing is east of the point.
				if point.longitude < crossingLongitude {
					inside.toggle()
				}
			}
			previous = current
		}
		return inside
	}
}
