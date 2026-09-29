import Rotation
import Testing

@Suite
struct `Rotation boundaries` {
    @Test
    func `the axis one past the last dimension is rejected and the last one is accepted`() throws {
        #expect(throws: Rotation<2, Double>.Error.invalidAxis) {
            try Rotation<2, Double>.Plane(first: .primary, second: Axis(_unchecked: (), 2), angle: .zero)
        }
        let plane = try Rotation<3, Double>.Plane(first: .primary, second: Axis(_unchecked: (), 2), angle: .zero)
        #expect(plane.second.underlying == 2)
    }

    @Test
    func `a negative zero angle is stored as zero and its inverse equals the plane`() throws {
        let plane = try Rotation<2, Double>.Plane(first: .primary, second: .secondary, angle: Radian(_unchecked: -0.0))
        #expect(plane.angle.underlying.sign == .plus)
        #expect(plane.inverse == plane)
        #expect(Set([plane, plane.inverse]).count == 1)
    }

    @Test
    func `an infinite angle is rejected in either direction`() {
        for angle in [Double.infinity, -.infinity] {
            #expect(throws: Rotation<2, Double>.Error.nonfiniteAngle) {
                try Rotation<2, Double>.Plane(first: .primary, second: .secondary, angle: Radian(_unchecked: angle))
            }
        }
    }
}
