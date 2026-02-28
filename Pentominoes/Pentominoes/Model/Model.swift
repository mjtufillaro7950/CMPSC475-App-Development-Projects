//
//  Pentominoes
//  Starter code for model
//  CMPSC475
//
import Foundation


//Mark:- Shapes models
struct Point {
    let x : Int
    let y : Int
}

struct Size {
    let width : Int
    let height : Int
}

typealias Outline = [Point]
typealias Outlines = [Outline]

struct PentominoOutline {
    let name : String
    let size : Size
    let outline : Outline
}

struct PuzzleOutline {
    let name : String
    let size : Size
    let outlines : Outlines
}


// a Piece is the model data that the view uses to display a pentomino
struct Piece  {
    var position : Position = Position()
    var outline : PentominoOutline
    
}

//Mark:- Pieces Model
// identifies placement of a single pentomino on a board, including x/y coordinate and its rotations.
//Order of rotations matters - X, Y, then Z.  Uses unit coordinates on a 14 x 14 board
struct Position  {
    var x : Int = 0
    var y : Int = 0
    var orientation: Orientation = .up
}


// This Orientation type is identical to UIImage.Orientation.  We define it to avoid needing UIKit in the model.  See documentation for this type to see what each value means in terms of rotations and flips.
enum Orientation : String {
    case up, left, down, right
    case upMirrored, leftMirrored, downMirrored, rightMirrored
}

