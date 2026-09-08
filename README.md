# Rotation

An ordered sequence of coordinate-plane rotations, each constituted by distinct
Axis<N> values and a finite Radian angle. The interpreting basis must be orthonormal.
The value retains planes and turns; equality compares parameters, not canonical
transformations. Composition concatenates application order, inverse reverses and
negates planes, and an empty sequence is identity in every dimension.

```swift
import Rotation
let rotation = Rotation(try Rotation<2, Double>.Plane(
    first: .primary, second: .secondary, angle: .pi.half
))
let inverse = rotation.inverse
```

Core URL dependencies are Axis and Angle. Matrix projection, trigonometric
numerical evaluation, and Vector application belong to deferred representation
integrations. They are not part of this atom. Coding validates every decoded plane.
Former numerical integration tests are preserved in the consolidation plan's
DEFERRED-TRANSFORM-INTEGRATION-TESTS.md for later molecule migration.

Registered in atoms.xcworkspace. Native GUI-backed umbrella build and all selected
core Shear/Rotation tests passed on My Mac, 2026-09-08 21:23 (12 runtime cases total).
