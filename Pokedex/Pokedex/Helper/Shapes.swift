//
//  Shapes.swift
//  Pokedex
//
//  Created by Jonrel Baclayon on 7/1/24.
//

import SwiftUI

struct CurveShape: Shape {
    let smallRadius: CGFloat = 20
    let largeRadius: CGFloat = 100
    func path(in rect: CGRect) -> Path {
        
        // Define all the points we're going to use
        let upperLeft = CGPoint.zero
        let upperRight: CGPoint = CGPoint(x: rect.maxX, y: rect.minY)
        
        // We will start drawing in the top-middle of the shape.
        let midTop = CGPoint(x: rect.midX, y: rect.minY)
        
        // The "midRight" and "midLeft" points are the points where the large radius curves are centered.
        let midRight =  CGPoint(x: rect.maxX, y: rect.maxY - largeRadius * 5)
        let midLeft = CGPoint(x: rect.minX, y: rect.maxY - largeRadius * 5)

        //The bottom left is the lowest point on the shape.
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

        var path = Path()
        // Start haflway along the top so we don't "cut a corner".
        path.move(to: midTop)
        
        // Draw a small-radius curve around the top right corner, headed to the mid right
        path.addArc(tangent1End: upperRight, tangent2End: midRight, radius: smallRadius, transform: .identity)
        
        // Now draw a large radius curve around the mid right, headed to the mid-left
        path.addArc(tangent1End: midRight, tangent2End: midLeft, radius: largeRadius, transform: .identity)

        // Now draw an outside curve down to the bottom left corner
        path.addArc(tangent1End: midLeft, tangent2End: bottomLeft, radius: largeRadius, transform: .identity)
        
        // Now draw a final curve around the top left corner and back to the top midpoint.
        path.addArc(tangent1End: upperLeft, tangent2End: midTop, radius: smallRadius, transform: .identity)
        
        // Close the path (which draws the final line from the top left curved corner to the top midpoint.
        path.closeSubpath()
        return path
    }
}

struct WaterShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.midY),
                              control: CGPoint(x: rect.width * 0.20, y: rect.height * 0.35))
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY),
                              control: CGPoint(x: rect.width * 0.80, y: rect.height * 0.65))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
    }
}

struct PreviewStruct: View {
    var body: some View {
        CurveShape()
            .fill(Color.blue)
            .ignoresSafeArea(.all)
    }
}

#Preview {
    PreviewStruct()
}
