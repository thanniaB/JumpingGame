//
//  GameScene.swift
//  Experimenting
//
//  Created by Thannia Blanchet on 3/7/15.
//  Copyright (c) 2015 Thannia Blanchet. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let mainChar = SKSpriteNode(imageNamed:"hero");
    let background = SKSpriteNode(imageNamed: "background");
    var randomNum: UInt32 = 0;
    let NumColumns = 14;
    let NumRows = 4;
    var world = Array2D<Block>(columns: 14, rows: 4);
    var blocks = Set<Block>();
    var blockId: Int = 0;
    
    func addBlockSprite(block: Block) {
        var blockSprite: SKSpriteNode;
        if (block.isNew){
            blockSprite = SKSpriteNode(imageNamed: "block2");
            blockId = blockId + 1;
        } else {
            blockSprite = SKSpriteNode(imageNamed: "block1");
        }
        
        blockSprite.position = pointForColumn(block.column, row:block.row);
        
        if(block.blockType != BlockType.Empty) {
            addChild(blockSprite);
            
            let constantMovement = SKAction.moveByX(-10, y: 0, duration: 1)
            var currentBlockSprite:SKSpriteNode
            
            let checkPosition = SKAction.runBlock({ () -> Void in
                if(blockSprite.position.x < self.frame.minX){
                    blockSprite.removeAllActions()
                    blockSprite.removeFromParent()
                }
            })
            
            let movementSequence = SKAction.sequence([constantMovement, checkPosition])
            
            let constantlyCheckPosition = SKAction.repeatActionForever(movementSequence)
            blockSprite.runAction(constantlyCheckPosition)
        }
        block.sprite = blockSprite;
    }
    
    func addSpritesForBlocks(blockSet: Set<Block>) {
        for block in blockSet {
            addBlockSprite(block);
        }
        blocks = blockSet;
    }
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*50 + 25,
            y: CGFloat(row)*50 + 50);
    }
    
    func setUpWorld() -> Set<Block> {
        var set = Set<Block>();
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                var blockType = BlockType.random();
                let block = Block(column: column, row: row, blockType: blockType, isLast: false, isNew: false, id: blockId);
                world[column, row] = block;
                set.addElement(block);
            }
        }
        return set;
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        mainChar.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        background.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));

        mainChar.xScale = 0.2;
        mainChar.yScale = 0.2;
        
        self.addChild(background);
        self.addChild(mainChar);
        
        addSpritesForBlocks(setUpWorld()); //world on screen

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self);
            let moveRight = SKAction.moveByX(50, y:0, duration:0.1);
            let moveLeft = SKAction.moveByX(-50, y:0, duration:0.1);
            
            println("blocks");
            println(blocks.allElements().count);
            
            for block in blocks {
                
                if(touchLocation.x < CGRectGetMidX(self.frame)) {
//                    println("touch left");
//                    println(block.description);
//                    println(blocks.containsElement(block));
                    block.sprite?.runAction(moveRight);
                } else {
//                    println("touch right");
//                    println(block.description);
//                    println(blocks.containsElement(block));
                    block.sprite?.runAction(moveLeft);
                }
            }
            
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let constantMovement = SKAction.moveByX(-1, y: 0, duration: 100);
        background.runAction(SKAction.repeatActionForever(constantMovement));
        let removeBlock = SKAction.removeFromParent();
        let frame = self.frame;
        var currentBlockSprite:SKSpriteNode;
        var newBlock: Block;
        
        for block in blocks {
            currentBlockSprite = block.sprite!;
            if(block.column == NumColumns - 1) {
                block.isLast = true;
            }
            
            if(currentBlockSprite.position.x < self.frame.minX){
                blocks.removeElement(block);
            }
            
            if(block.isLast && currentBlockSprite.position.x < frame.maxX - 40) {
                block.isLast = false;
                
                for row in 0..<NumRows {
                    newBlock = Block(column: NumColumns - 1, row: row, blockType: BlockType.random(), isLast: true, isNew: true, id: blockId);
                    blocks.addElement(newBlock);
                    addBlockSprite(newBlock);
                    println(blocks.containsElement(newBlock));
                    println(blocks.count);
                    println(blocks.allElements());
                }
            }

        }
      
    }
}
