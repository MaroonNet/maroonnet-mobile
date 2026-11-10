//
//  AssignmentMapContent.swift
//  MaroonNet Field
//
//  MaroonNet: how the current search assignment appears on Meshtastic's map: the area
//  drawn as a maroon polygon, and a banner saying whether the searcher is inside it.
//

import CoreLocation
import MapKit
import SwiftUI
import UIKit

/// Builds the map overlay for the current assignment.
@MainActor
enum AssignmentMapContent {
	/// MaroonNet maroon.
	static let maroon = UIColor(red: 0.50, green: 0.0, blue: 0.13, alpha: 1)

	/// The overlay last built. Meshtastic's map redraws an overlay whenever it gets a new
	/// object for it, so we hand back the same object until the assignment changes.
	private static var cached: (key: String, overlay: ClusterMapOverlay)?

	static func overlays(for assignment: Assignment?) -> [ClusterMapOverlay] {
		guard let assignment else { return [] }
		let key = "maroonnet-assignment-\(assignment.id)-\(assignment.receivedAt.timeIntervalSince1970)"
		if let cached, cached.key == key {
			return [cached.overlay]
		}
		var corners = assignment.corners
		let polygon = MKPolygon(coordinates: &corners, count: corners.count)
		let style = ClusterMapOverlayStyle(
			strokeUIColor: maroon,
			fillUIColor: maroon.withAlphaComponent(0.15),
			lineWidth: 3
		)
		let overlay = ClusterMapOverlay(id: key, overlay: polygon, style: style)
		cached = (key, overlay)
		return [overlay]
	}
}

/// The Inside / Outside banner at the top of the map while there is an assignment.
struct AssignmentBanner: View {
	@ObservedObject private var locations = LocationsHandler.shared
	private let store = AssignmentStore.shared

	var body: some View {
		if let assignment = store.current {
			let position = locations.locationsArray.last?.coordinate ?? LocationsHandler.currentLocation
			HStack(spacing: 8) {
				Image(systemName: "square.dashed")
				Text(assignment.name)
					.fontWeight(.semibold)
				if let position {
					let inside = assignment.contains(position)
					Text(inside ? "INSIDE" : "OUTSIDE")
						.fontWeight(.bold)
						.foregroundStyle(inside ? Color.green : Color.orange)
				} else {
					Text("Waiting for your position")
						.foregroundStyle(.secondary)
				}
			}
			.font(.callout)
			.padding(.horizontal, 14)
			.padding(.vertical, 8)
			.background(.thinMaterial, in: Capsule())
		}
	}
}
