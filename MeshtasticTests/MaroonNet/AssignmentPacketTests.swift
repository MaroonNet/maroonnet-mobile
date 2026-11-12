import CoreLocation
import Foundation
import Testing
@testable import Meshtastic

@Suite("AssignmentPacket")
struct AssignmentPacketTests {

	// MARK: - Shared example (decision record v1.1, Section 4)

	/// ID 7, "Sector B2", 4 corners. 49 bytes. Elijah's encoder must produce exactly this.
	static let exampleHex =
		"4d4e0101070004097014af17d0086bc17014af17708f6cc1109bb017708f6cc1109bb017d0086bc1536563746f72204232"

	static let exampleCorners: [(Double, Double)] = [
		(39.735, -104.995), (39.735, -104.985), (39.745, -104.985), (39.745, -104.995),
	]

	static var example: [UInt8] {
		let hex = Array(exampleHex)
		return stride(from: 0, to: hex.count, by: 2).map { UInt8(String(hex[$0...$0 + 1]), radix: 16)! }
	}

	// MARK: - Helpers

	/// Builds a packet by the Section 3 rules. Test-only; the phone never sends assignments.
	static func packet(
		id: UInt16 = 1,
		corners: [(Double, Double)],
		name: String = "",
		version: UInt8 = 1,
		type: UInt8 = 1
	) -> [UInt8] {
		let nameBytes = Array(name.utf8)
		var bytes: [UInt8] = [
			0x4D, 0x4E, version, type,
			UInt8(id & 0xFF), UInt8(id >> 8),
			UInt8(corners.count), UInt8(nameBytes.count),
		]
		for (latitude, longitude) in corners {
			for value in [Int32((latitude * 1e7).rounded()), Int32((longitude * 1e7).rounded())] {
				bytes += withUnsafeBytes(of: value.littleEndian) { Array($0) }
			}
		}
		return bytes + nameBytes
	}

	static func decode(_ bytes: [UInt8]) -> Assignment? {
		AssignmentPacket.decode(Data(bytes))
	}

	static let triangle: [(Double, Double)] = [(0, 0), (0, 1), (1, 0)]
	static let square: [(Double, Double)] = [(0, 0), (0, 1), (1, 1), (1, 0)]
	static let pentagon: [(Double, Double)] = [(0, 0), (0, 1), (1, 1), (1.5, 0.5), (1, 0)]

	// MARK: - The shared example

	@Test func exampleIs49Bytes() {
		#expect(Self.example.count == 49)
	}

	@Test func builderMatchesTheSharedExample() {
		#expect(Self.packet(id: 7, corners: Self.exampleCorners, name: "Sector B2") == Self.example)
	}

	@Test func decodesTheSharedExample() throws {
		let assignment = try #require(Self.decode(Self.example))
		#expect(assignment.id == 7)
		#expect(assignment.name == "Sector B2")
		#expect(assignment.corners.count == 4)
		for (corner, (latitude, longitude)) in zip(assignment.corners, Self.exampleCorners) {
			#expect(abs(corner.latitude - latitude) < 1e-7)
			#expect(abs(corner.longitude - longitude) < 1e-7)
		}
	}

	@Test func decodedExampleWorksWithTheInsideCheck() throws {
		let assignment = try #require(Self.decode(Self.example))
		#expect(assignment.contains(CLLocationCoordinate2D(latitude: 39.740, longitude: -104.990)))
		#expect(!assignment.contains(CLLocationCoordinate2D(latitude: 39.750, longitude: -104.990)))
	}

	// MARK: - Accepted

	@Test func acceptsThreeAndFiveCorners() {
		#expect(Self.decode(Self.packet(corners: Self.triangle))?.corners.count == 3)
		#expect(Self.decode(Self.packet(corners: Self.pentagon))?.corners.count == 5)
	}

	@Test func readsTheIDLittleEndian() {
		// 258 is bytes 02 01; read in the wrong order it would be 513.
		#expect(Self.decode(Self.packet(id: 258, corners: Self.square))?.id == 258)
		#expect(Self.decode(Self.packet(id: 65_535, corners: Self.square))?.id == 65_535)
	}

	@Test func acceptsEmptyAnd20ByteNames() {
		#expect(Self.decode(Self.packet(corners: Self.square, name: ""))?.name == "")
		let twenty = String(repeating: "A", count: 20)
		#expect(Self.decode(Self.packet(corners: Self.square, name: twenty))?.name == twenty)
	}

	@Test func readsNegativeLatitudeAndLongitude() throws {
		let south: [(Double, Double)] = [(-33.9, 151.1), (-33.9, 151.2), (-33.8, 151.2)]
		let assignment = try #require(Self.decode(Self.packet(corners: south)))
		#expect(abs(assignment.corners[0].latitude - (-33.9)) < 1e-7)
		#expect(abs(assignment.corners[0].longitude - 151.1) < 1e-7)
	}

	// MARK: - Ignored (each breaks one Section 3 rule)

	@Test func ignoresWrongMarker() {
		var bytes = Self.example
		bytes[1] = 0x00
		#expect(Self.decode(bytes) == nil)
	}

	@Test func ignoresUnknownVersion() {
		#expect(Self.decode(Self.packet(corners: Self.square, version: 2)) == nil)
	}

	@Test func ignoresUnknownType() {
		#expect(Self.decode(Self.packet(corners: Self.square, type: 2)) == nil)
	}

	@Test func ignoresTwoOrSixCorners() {
		let two: [(Double, Double)] = [(0, 0), (1, 1)]
		let six = Self.pentagon + [(0.5, -0.5)]
		#expect(Self.decode(Self.packet(corners: two)) == nil)
		#expect(Self.decode(Self.packet(corners: six)) == nil)
	}

	@Test func ignores21ByteName() {
		let name = String(repeating: "A", count: 21)
		#expect(Self.decode(Self.packet(corners: Self.square, name: name)) == nil)
	}

	@Test func ignoresWrongLength() {
		#expect(Self.decode(Array(Self.example.dropLast())) == nil)
		#expect(Self.decode(Self.example + [0x00]) == nil)
	}

	@Test func ignoresEmptyAndHeaderOnlyPayloads() {
		#expect(Self.decode([]) == nil)
		#expect(Self.decode(Array(Self.example.prefix(8))) == nil)
	}
}
