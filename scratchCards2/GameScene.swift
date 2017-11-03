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

enum CardLevel: CGFloat {
    case board    =  10.0
    case moving   = 100.0
    case enlarged = 200.0
}

class GameScene: SKScene {

    var shadow: SKSpriteNode?

    override func didMove(to view: SKView) {
        let bg = SKSpriteNode(imageNamed: "bg_blank")
        bg.anchorPoint = CGPoint.zero
        bg.position = CGPoint.zero
        addChild(bg)

        let wolf = Card(cardType: .wolf)
        let bear = Card(cardType: .bear)

        wolf.position = CGPoint(x: 100.0, y: 100.0)
        bear.position = CGPoint(x: 300.0, y: 100.0)
        bear.zPosition += 1

        addChild(wolf)
        addChild(bear)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let card = atPoint(location) as? Card {
                card.position = location
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let card = atPoint(location) as? Card {
                card.touchesBegan(touches, with: event)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let card = atPoint(location) as? Card {
                card.touchesEnded(touches, with: event)

            }
        }
    }
}

class MAKE {

    private static let view:SKView = SKView()

    static func makeShadow(from source: SKTexture, rgb: SKColor, alpha: CGFloat) -> SKSpriteNode {
        let shadowNode = SKSpriteNode(texture: source)
        shadowNode.colorBlendFactor = 0.5  // makes the following line more effective
        shadowNode.color = SKColor.gray // makes for a darker shadow. Off for "glow" shadow
        let textureSize = source.size()
        let doubleTextureSize = CGSize(width: textureSize.width * 1.5, height: textureSize.height * 1.5)
        let framer = SKSpriteNode(color: UIColor.clear, size: doubleTextureSize)
        framer.addChild(shadowNode)
        let filter = CIFilter(name: "CIGaussianBlur")
        let blurAmount = 10
        filter?.setValue(blurAmount, forKey: kCIInputRadiusKey)
        let effectsNode = SKEffectNode()
        effectsNode.filter = filter
        effectsNode.blendMode = .alpha
        effectsNode.addChild(framer)
        effectsNode.shouldRasterize = true
        let tex = view.texture(from: effectsNode)
        let shadow = SKSpriteNode(texture: tex)
        shadow.colorBlendFactor = 0.9
        shadow.color = rgb
        shadow.alpha = alpha
        shadow.zPosition = -1
        return shadow
    }
}
