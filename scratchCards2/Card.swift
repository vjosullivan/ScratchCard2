/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import SpriteKit

enum CardType {
    case wolf
    case bear
    case dragon
}

class Card : SKSpriteNode {

    // MARK: - Local constants and variables.

    var shadow: SKSpriteNode?

    private let cardType: CardType

    private let frontTexture: SKTexture
    private let backTexture: SKTexture

    // MARK: - Initialisers.

    required init?(coder aDecoder: NSCoder) {
        fatalError("Card class does not support NSCoding.")
    }

    init(cardType: CardType) {
        self.cardType = cardType

        switch cardType {
        case .wolf:
            frontTexture = SKTexture(imageNamed: "card_creature_wolf")
        case .bear:
            frontTexture = SKTexture(imageNamed: "card_creature_bear")
        case .dragon:
            frontTexture = SKTexture(imageNamed: "card_creature_dragon")
        }

        backTexture = SKTexture(imageNamed: "card_back")

        super.init(texture: frontTexture, color: .clear, size: frontTexture.size())
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let liftTime   = 0.15 // Seconds.
        let wobbleTime = 0.7 // Seconds.

        for touch in touches {
            let location = touch.location(in: self.parent!)
            //if let card = atPoint(location) as? Card {
            zPosition = CardLevel.moving.rawValue
            removeAction(forKey: "drop")
            run(SKAction.scale(to: 1.15, duration: liftTime), withKey: "pickup")

            let wobbleLeft  = SKAction.rotate(toAngle:  0.02, duration: wobbleTime)
            let wobbleRight = SKAction.rotate(toAngle: -0.02, duration: wobbleTime)
            let wobble      = SKAction.sequence([wobbleLeft, wobbleRight])

            let shadowTexture = SKTexture(imageNamed: "card_shadow")
            shadow = MAKE.makeShadow(from: shadowTexture, rgb: .black, alpha: 0.5)
            if let shadow = shadow {
                shadow.position = CGPoint(x: 10 , y: -10)
                addChild(shadow)
            }
            run(SKAction.move(to: location, duration: 0.1))
            //card.run(SKAction.repeatForever(wiggle), withKey: "wiggle")
            run(SKAction.repeatForever(wobble), withKey: "wobble")
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let dropTime = 0.15 // Seconds.

        for _ in touches {
            if let shadow = shadow {
                shadow.run(SKAction.move(to: CGPoint(x: 0 , y: 0), duration: dropTime)) {
                    self.removeChildren(in: [shadow])
                }
            }
            zPosition = CardLevel.board.rawValue
            removeAction(forKey: "pickup")
            run(SKAction.scale(to: 1.0, duration: dropTime), withKey: "drop")
            run(SKAction.rotate(toAngle: 0.0, duration: 0.15))
            removeAction(forKey: "wobble")

        }
    }
}
