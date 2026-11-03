# swift-rotation

Use this package to describe a rotation in N dimensions without evaluating it: an ordered list of rotations, each in a plane spanned by two coordinate axes. It records the steps, can compose and invert them, and stores them exactly. It never multiplies them out. Start from `Rotation<N, Scalar>` and build its steps as `Rotation<N, Scalar>.Plane`. If you need the rotation as a matrix of numbers, use swift-symmetry instead, which stores a rotation as its matrix.

## Laws

- A `Rotation<N, Scalar>.Plane` exists only when both axes lie in `0..<N`, the two axes differ, and the angle is finite. Decoding enforces the same rules and fails with a `DecodingError` when they don't hold.
- Planes apply in order. `followed(by:)` appends the other rotation's planes after this one's. `identity` is the empty list, so it is a neutral element on both sides.
- `inverse` reverses the order of the planes and negates each angle, so `inverse.inverse` is the original.
- Equality and hashing compare the plane lists exactly, with no normalisation. A full turn is not equal to `identity`. A zero-angle plane is not dropped. Two lists that produce the same geometric rotation are equal only if they list the same planes in the same order.
- The one normalisation is that an angle of `-0` is stored as `+0`. As a result, the inverse of a zero-angle plane equals the plane itself.
