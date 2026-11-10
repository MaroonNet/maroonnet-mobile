//
//  DemoAssignment.swift
//  MaroonNet Field
//
//  MaroonNet: a demo search area for test builds only, so the map and banner can be tried
//  before real assignments arrive over the mesh. Not compiled into TestFlight builds.
//

#if DEBUG
import CoreLocation
import Foundation

extension Assignment {
	/// About 450 m x 500 m around the Auraria campus, Denver. Edit the corners to move it.
	static let demo = Assignment(
		id: 0,
		name: "Demo Sector",
		corners: [
			CLLocationCoordinate2D(latitude: 39.7440, longitude: -105.0090),
			CLLocationCoordinate2D(latitude: 39.7440, longitude: -105.0030),
			CLLocationCoordinate2D(latitude: 39.7480, longitude: -105.0030),
			CLLocationCoordinate2D(latitude: 39.7480, longitude: -105.0090)
		],
		receivedAt: Date()
	)
}
#endif
