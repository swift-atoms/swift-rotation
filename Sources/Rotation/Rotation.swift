@_exported public import Axis
@_exported public import Angle

/// An ordered parameterization by proper rotations in coordinate planes.
/// Coordinate axes must form an orthonormal basis in the interpreting domain.
public struct Rotation<let N: Int, Scalar: BinaryFloatingPoint> {
    public let planes: [Plane]
    public init(planes: [Plane]) { self.planes = planes }
    public static var identity: Self { Self(planes: []) }

    /// Apply this rotation first, followed by the argument.
    public func followed(by other: Self) -> Self { Self(planes: planes + other.planes) }
    public var inverse: Self { Self(planes: planes.reversed().map(\.inverse)) }

    public enum Error: Swift.Error, Equatable, Sendable {
        case invalidAxis
        case coincidentAxes
        case nonfiniteAngle
    }

    public struct Plane {
        public let first: Axis<N>
        public let second: Axis<N>
        public let angle: Radian<Scalar>

        /// Positive angle maps the first basis vector toward the second.
        public init(first: Axis<N>, second: Axis<N>, angle: Radian<Scalar>) throws(Error) {
            guard first.underlying >= 0, first.underlying < N,
                  second.underlying >= 0, second.underlying < N else { throw .invalidAxis }
            guard first != second else { throw .coincidentAxes }
            guard angle.underlying.isFinite else { throw .nonfiniteAngle }
            self.first = first
            self.second = second
            self.angle = Radian(_unchecked: angle.underlying == 0 ? 0 : angle.underlying)
        }

        public var inverse: Self {
            Self(validatedFirst: first, second: second, angle: -angle.underlying)
        }
    }
}

extension Rotation.Plane: Equatable {}
extension Rotation.Plane: Hashable where Scalar: Hashable {}
extension Rotation.Plane: Sendable where Scalar: Sendable {}
extension Rotation: Equatable {}
extension Rotation: Hashable where Scalar: Hashable {}
extension Rotation: Sendable where Scalar: Sendable {}

#if !hasFeature(Embedded)
extension Rotation.Plane {
    private enum CodingKeys: String, CodingKey { case first, second, angle }
}
extension Rotation.Plane: Encodable where Scalar: Encodable {
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(first.underlying, forKey: .first)
        try c.encode(second.underlying, forKey: .second)
        try c.encode(angle.underlying, forKey: .angle)
    }
}
extension Rotation.Plane: Decodable where Scalar: Decodable {
    public init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let first = try c.decode(Int.self, forKey: .first)
        let second = try c.decode(Int.self, forKey: .second)
        let angle = try c.decode(Scalar.self, forKey: .angle)
        do { try self.init(first: Axis(first), second: Axis(second), angle: Radian(_unchecked: angle)) }
        catch {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath,
                debugDescription: "A rotation plane requires distinct valid axes and a finite angle"))
        }
    }
}
extension Rotation: Encodable where Scalar: Encodable {}
extension Rotation: Decodable where Scalar: Decodable {}
#endif

extension Rotation {
    public init(_ plane: Plane) { self.init(planes: [plane]) }
}

extension Rotation.Plane {
    private init(validatedFirst: Axis<N>, second: Axis<N>, angle: Scalar) {
        self.first = validatedFirst
        self.second = second
        self.angle = Radian(_unchecked: angle == 0 ? 0 : angle)
    }
}
