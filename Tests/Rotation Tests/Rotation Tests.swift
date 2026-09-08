import Rotation
import Testing
import Foundation

@Suite struct `Proper rotation contracts` {
    @Test func `Composition preserves plane order and inverse reverses it`() throws {
        let xy = try Rotation<3, Double>.Plane(first: .primary, second: .secondary, angle: .pi.half)
        let yz = try Rotation<3, Double>.Plane(first: .secondary, second: .tertiary, angle: .pi.quarter)
        let combined = Rotation(xy).followed(by: Rotation(yz))
        #expect(combined.planes == [xy, yz])
        #expect(combined.inverse.planes == [yz.inverse, xy.inverse])
        #expect(combined.inverse.inverse == combined)
        #expect(combined.followed(by: .identity) == combined)
        #expect(Rotation<3, Double>.identity.followed(by: combined) == combined)
    }

    @Test func `Invalid axes and nonfinite angles are rejected`() {
        #expect(throws: Rotation<2, Double>.Error.coincidentAxes) {
            try Rotation<2, Double>.Plane(first: .primary, second: .primary, angle: .zero)
        }
        #expect(throws: Rotation<2, Double>.Error.invalidAxis) {
            try Rotation<2, Double>.Plane(first: Axis(_unchecked: (), -1), second: .secondary, angle: .zero)
        }
        #expect(throws: Rotation<2, Double>.Error.nonfiniteAngle) {
            try Rotation<2, Double>.Plane(first: .primary, second: .secondary, angle: Radian(_unchecked: .infinity))
        }
    }

    @Test func `Identity supports zero and one dimensions`() {
        #expect(Rotation<0, Double>.identity.planes.isEmpty)
        #expect(Rotation<1, Double>.identity.planes.isEmpty)
    }

    @Test func `Full turns retain their parameterization rather than collapsing equality`() throws {
        let rotation = Rotation(try Rotation<2, Double>.Plane(first: .primary, second: .secondary, angle: .pi.two))
        #expect(rotation != .identity)
        #expect(rotation.inverse.inverse == rotation)
        #expect(Set([rotation, rotation]).count == 1)
    }

    @Test func `Coding validates each plane`() throws {
        let rotation = Rotation(try Rotation<2, Double>.Plane(first: .primary, second: .secondary, angle: .pi.quarter))
        #expect(try JSONDecoder().decode(Rotation<2, Double>.self, from: JSONEncoder().encode(rotation)) == rotation)
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(Rotation<2, Double>.self, from: Data(#"{"planes":[{"first":0,"second":0,"angle":1}]}"#.utf8))
        }
    }

}
