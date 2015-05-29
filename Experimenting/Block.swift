//
//  Block.swift
//  Experimenting
//
//  Created by Thannia Blanchet on 3/23/15.
//  Copyright (c) 2015 Thannia Blanchet. All rights reserved.
//

import Foundation
import SpriteKit

enum BlockType: Int {
    case Empty = 0, Regular, Sand
    
    static func random() -> BlockType {
        return BlockType(rawValue: Int(arc4random_uniform(3)))!
    }
}

class Block: Printable, Hashable {
    var column: Int
    var row: Int
    let blockType: BlockType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, blockType: BlockType) {
        self.column = column
        self.row = row
        self.blockType = blockType
    }
    
    var hashValue: Int {
        return row*10 + column
    }
    
    var description: String {
        return "column: \(column), row: \(row)"
    }
    
}

func ==(lhs: Block, rhs: Block) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}