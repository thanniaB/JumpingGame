//
//  GameScene.swift
//  Experimenting
//
//  Created by Thannia Blanchet on 3/7/15.
//  Copyright (c) 2015 Thannia Blanchet. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let mainChar = SKSpriteNode(imageNamed:"Spaceship");
    let background = SKSpriteNode(imageNamed: "background");
    let block = SKSpriteNode(imageNamed: "block");
    var randomNum: UInt32 = 0;
    let NumColumns = 14;
    let NumRows = 4;
    var world = Array2D<Block>(columns: 14, rows: 4);
    var blocks = Set<Block>();
    
    func addBlockSprite(block: Block) {
        let blockSprite = SKSpriteNode(imageNamed: "block");
        blockSprite.position = pointForColumn(block.column, row:block.row);
        if(block.blockType != BlockType.Empty) {
            addChild(blockSprite);
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
                let block = Block(column: column, row: row, blockType: blockType, x: 0);
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
            
            for block in blocks {
                
                if(touchLocation.x < CGRectGetMidX(self.frame)) {
                    block.sprite?.runAction(moveRight);
                } else {
                    block.sprite?.runAction(moveLeft);
                }
            }
            
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let constantMovement = SKAction.moveByX(-1, y: 0, duration: 10);
        background.runAction(SKAction.repeatActionForever(constantMovement));
        let removeBlock = SKAction.removeFromParent();
        let frame = self.frame;
        var currentBlockSprite:SKSpriteNode;
        var newBlock: Block;
        
        for block in blocks {
            currentBlockSprite = block.sprite!;
            currentBlockSprite.runAction(constantMovement);
            if(block.column == NumColumns - 1 && currentBlockSprite.position.x < frame.maxX) {
                println("IT GOT IN");
                for block in blocks {
                    println("before: " + block.description);
                    block.column = block.column - 1;
                    println("after: " + block.description);
                }
                for row in 0..<NumRows {
                    newBlock = Block(column: NumColumns - 1, row: row, blockType: BlockType.random(), x: 0);
                    blocks.addElement(newBlock);
                    addBlockSprite(newBlock);
                    println("new block: " + newBlock.description);
                }
            }

            if(currentBlockSprite.position.x < frame.minX) {
                currentBlockSprite.runAction(removeBlock);
                blocks.removeElement(block);
            }
        }
      
    }
}
