import CoreLocation
import Foundation

/// MaroonNet assignment packet, byte layout version 1.
/// Contract: MaroonNet Assignment Packet decision record v1.2, Section 3.
/// Arrives as the payload of a Meshtastic packet on port 256 (PRIVATE_APP).
/// All multi-byte numbers are little-endian.
///
/// | Offset  | Size  | Field                                              |
/// |---------|-------|----------------------------------------------------|
/// | 0       | 2     | Marker "MN" (4D 4E)                                |
/// | 2       | 1     | Version, 1                                         |
/// | 3       | 1     | Message type, 1 = assignment                       |
/// | 4       | 2     | Assignment ID, UInt16                              |
/// | 6       | 1     | Corner count n, 3 to 24                           |
/// | 7       | 1     | Name length k, 0 to 20                             |
/// | 8       | 8 x n | Corners: Int32 latitude, Int32 longitude, deg x 1e7 |
/// | 8 + 8n  | k     | Name, UTF-8                                        |
enum AssignmentPacket {
	static let marker: [UInt8] = [0x4D, 0x4E]
	static let version: UInt8 = 1
	static let typeAssignment: UInt8 = 1
	static let headerSize = 8
	static let cornerSize = 8
    static let cornerCounts = Assignment.allowedCornerCounts
	static let maxNameLength = 20

	/// Reads a port-256 payload into an assignment.
	/// Returns nil when the payload breaks any rule in Section 3 of the record,
	/// so packets from other apps on port 256 are ignored.
	static func decode(_ payload: Data, receivedAt: Date = .now) -> Assignment? {
		let bytes = [UInt8](payload)

		guard bytes.count >= headerSize,
			  bytes[0] == marker[0], bytes[1] == marker[1],
			  bytes[2] == version,
			  bytes[3] == typeAssignment
		else { return nil }

		let id = Int(UInt16(bytes[4]) | UInt16(bytes[5]) << 8)
		let cornerCount = Int(bytes[6])
		let nameLength = Int(bytes[7])

		guard cornerCounts.contains(cornerCount),
			  nameLength <= maxNameLength,
			  bytes.count == headerSize + cornerSize * cornerCount + nameLength
		else { return nil }

		var corners: [CLLocationCoordinate2D] = []
		var offset = headerSize
		for _ in 0..<cornerCount {
			let latitude = Double(int32(bytes, at: offset)) / 1e7
			let longitude = Double(int32(bytes, at: offset + 4)) / 1e7
			corners.append(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
			offset += cornerSize
		}

		let name = String(decoding: bytes[offset..<(offset + nameLength)], as: UTF8.self)
		return Assignment(id: id, name: name, corners: corners, receivedAt: receivedAt)
	}

	/// Signed 32-bit little-endian number starting at `offset`.
	private static func int32(_ bytes: [UInt8], at offset: Int) -> Int32 {
		let raw = UInt32(bytes[offset])
			| UInt32(bytes[offset + 1]) << 8
			| UInt32(bytes[offset + 2]) << 16
			| UInt32(bytes[offset + 3]) << 24
		return Int32(bitPattern: raw)
	}
}
