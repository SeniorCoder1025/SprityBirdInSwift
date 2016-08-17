//
//  GameViewController.swift
//  SprityBirdInSwift
//
//  Created by Frederick Siu on 6/6/14.
//  Copyright (c) 2014 Frederick Siu. All rights reserved.
//

import UIKit
import SpriteKit
import QuartzCore
import StoreKit

class GameViewController: UIViewController, SceneDelegate {

    
    @IBOutlet
    var gameView: SKView!
    @IBOutlet
    var getReadyView: UIView!
    @IBOutlet
    var gameOverView: UIView!
    @IBOutlet
    var medalImageView: UIImageView!
    @IBOutlet
    var currentScore: UILabel!
    @IBOutlet
    var bestScoreLabel: UILabel!
    
    @IBOutlet weak var removeAds: UIButton!
    
    var scene: Scene?
    var flash: UIView?
    
    var removeAdsProduct:SKProduct!
	
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
		scene = Scene(size: gameView.bounds.size)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
        // Create and configure the scene.
        self.scene = Scene(size: gameView.bounds.size)
        self.scene!.scaleMode = .AspectFill
        self.scene!.sceneDelegate = self
        
        // Present the scene
        self.gameOverView.alpha = 0
        self.gameOverView.transform = CGAffineTransformMakeScale(0.9, 0.9)
        self.gameView.presentScene(scene)
        if FlapProducts.store.isProductPurchased(FlapProducts.RemoveAds) {
            removeAds.hidden = true
        }else{
            Chartboost.cacheInterstitial(CBLocationHomeScreen)
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.handlePurchaseNotification(_:)),
                                                         name: IAPHelper.IAPHelperPurchaseNotification,
                                                         object: nil)
        if IAPHelper.canMakePayments() {
            FlapProducts.store.requestProducts({ (success, products) in
                for product in products! {
                    if product.productIdentifier == FlapProducts.RemoveAds {
                        self.removeAdsProduct = product
                    }
                }
            })
        }
    }
    
    func eventStart() {
        UIView.animateWithDuration(0.2, animations: {
        self.gameOverView.alpha = 0
        self.gameOverView.transform = CGAffineTransformMakeScale(0.8, 0.8)
        self.flash!.alpha = 0
        self.getReadyView.alpha = 1
            }, completion: {
                (Bool) -> Void in self.flash!.removeFromSuperview()
            });
    }
    
    func eventPlay() {
        UIView.animateWithDuration(0.5, animations: {
            self.getReadyView.alpha = 0
		});
    }
    
    func eventBirdDeath() {
        self.flash = UIView(frame: self.view.frame)
        self.flash!.backgroundColor = UIColor.whiteColor()
        self.flash!.alpha = 0.9
        
        // shakeFrame
        
        UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            // Display game over
            self.flash!.alpha = 0.4
            self.gameOverView.alpha = 1
            self.gameOverView.transform = CGAffineTransformMakeScale(1, 1)
            
            // Set medal
            if(self.scene!.score >= 30){
                self.medalImageView.image = UIImage(named: "medal_platinum")
            }else if (self.scene!.score >= 20){
                self.medalImageView.image = UIImage(named: "medal_gold")
            }else if (self.scene!.score >= 10){
                self.medalImageView.image = UIImage(named: "medal_silver")
            }else if (self.scene!.score >= 0){
                self.medalImageView.image = UIImage(named: "medal_bronze")
            }else{
                self.medalImageView.image = nil
            }
            
            // Set scores
            self.currentScore.text = NSString(format: "%li", self.scene!.score) as String
            self.bestScoreLabel.text = NSString(format: "%li", Score.bestScore()) as String
            },
            completion: {(Bool) -> Void in self.flash!.userInteractionEnabled = false})
        showAds()
    }
    
    func showAds() {
        if FlapProducts.store.isProductPurchased(FlapProducts.RemoveAds) {
            removeAds.hidden = true
        }else{
            if Chartboost.hasInterstitial(CBLocationHomeScreen) {
                Chartboost.showInterstitial(CBLocationHomeScreen)
            }else{
                Chartboost.cacheInterstitial(CBLocationHomeScreen)
            }
        }
    }
    
    func shakeFrame() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 4
        animation.autoreverses = true
        let fromPoint = CGPointMake(self.view.center.x - 4.0, self.view.center.y)
        let toPoint = CGPointMake(self.view.center.x + 4.0, self.view.center.y)
        
        let fromValue = NSValue(CGPoint: fromPoint)
        let toValue = NSValue(CGPoint: toPoint)
        animation.fromValue = fromValue
        animation.toValue = toValue
        self.view.layer.addAnimation(animation, forKey: "position")
    }
    
    // MARK: - UI Actions
    
    @IBAction func onRemoveAds(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Remove Ads", message: "Do you want to remove Ads?", preferredStyle:UIAlertControllerStyle.Alert)
        actionSheet.addAction(UIAlertAction(title: "Remove Ads", style: UIAlertActionStyle.Default, handler: { (action) in
            if IAPHelper.canMakePayments() && self.removeAdsProduct != nil {
                FlapProducts.store.buyProduct(self.removeAdsProduct)
            }else{
                let actionAlert = UIAlertController(title: "Remove Ads", message: "Cannot purchase now, please try again later.", preferredStyle:UIAlertControllerStyle.Alert)
                actionAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(actionAlert, animated: true, completion: nil)
            }
        }))
//        actionSheet.addAction(UIAlertAction(title: "Restore", style: UIAlertActionStyle.Default, handler: { (action) in
//            FlapProducts.store.restorePurchases()
//        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func handlePurchaseNotification(notification: NSNotification) {
        guard let productID = notification.object as? String else { return }
        guard removeAdsProduct.productIdentifier == productID else { return }
        removeAds.hidden = true
    }
}
