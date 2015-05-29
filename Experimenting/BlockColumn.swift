//
//  BlockColumn.swift
//  Experimenting
//
//  Created by Thannia Blanchet on 5/28/15.
//  Copyright (c) 2015 Thannia Blanchet. All rights reserved.
//

import Foundation
import SpriteKit

class BlockColumn {
    var blocks = [Block]()
    var xPosition: CGFloat?
    
    init(blocks: [Block]){
        self.blocks = blocks;
        self.xPosition = blocks[0].sprite?.position.x;
    }
    
    func updatePosition(){
        self.xPosition = blocks[0].sprite?.position.x;
    }
}