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
    var columnList = [BlockColumn]();
    var columnCount = 13;
    
    func addBlockSprite(block: Block) {
        var blockSprite: SKSpriteNode;
        // if block type cambiar sprite blah blah
        blockSprite = SKSpriteNode(imageNamed: "block1");
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
    
    
    func pointForColumn(var column: Int, row: Int) -> CGPoint {
        if(column > 14) {
            column = 14;
        }
        
        return CGPoint(
            x: CGFloat(column)*50 + 25,
            y: CGFloat(row)*50 + 50);
    }
    
    func createColumn(x: Int) -> BlockColumn {
        var newColumn: BlockColumn;
        var blocks = [Block]();
        for (var row = 0; row < NumRows; row++) { //just one column
            blocks.append(Block(column: x, row: row, blockType: BlockType.random()));
            addBlockSprite(blocks[row]);
        }
        newColumn = BlockColumn(blocks: blocks);
        return newColumn;
    }
    
    func setUpWorld() {
        for(var x = 0; x < NumColumns; x++){ // whole world
            columnList.append(createColumn(x));
        }
        
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        mainChar.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        background.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));

        mainChar.xScale = 0.2;
        mainChar.yScale = 0.2;
        
        self.addChild(background);
        self.addChild(mainChar);
        
        setUpWorld();

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self);
            let moveRight = SKAction.moveByX(50, y:0, duration:0.1);
            let moveLeft = SKAction.moveByX(-50, y:0, duration:0.1);
            
            
            for column in columnList {
                for block in column.blocks {
                    if(touchLocation.x < CGRectGetMidX(self.frame)) {
                        block.sprite?.runAction(moveRight);
                        columnList[0].updatePosition();
                        columnList[columnList.count - 1].updatePosition();
                    } else {
                        block.sprite?.runAction(moveLeft);
                        columnList[0].updatePosition();
                        columnList[columnList.count - 1].updatePosition();
                    }
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
        
        println("ARRAY:");
        for column in columnList {
            println(column.blocks[0].description);
            column.updatePosition();
        }
        
        println("ARRAY TOTAL: \(columnList.count)");
        println("first");
        println(columnList[0].xPosition);
        println(columnList[0].blocks[0].sprite?.position.x);
        println(columnList[0].blocks[0].description);
        println("last");
        println(columnList[columnList.count - 1].xPosition);
        println(columnList[columnList.count - 1].blocks[0].sprite?.position.x);
        println(columnList[columnList.count - 1].blocks[0].description);
        
        columnList[0].updatePosition();
        columnList[columnList.count - 1].updatePosition();
        
        if(columnList[0].xPosition < frame.minX) {
            println("DELETED!");
            columnList.removeAtIndex(0);
        }
        
        if(columnList[columnList.count - 1].xPosition < frame.maxX) {
            // siento que esto va a tronar
            println("IT CROSSED");
            columnCount = columnCount + 1;
            columnList.insert(createColumn(columnCount), atIndex: columnList.count);
        }
        
      
    }
}
