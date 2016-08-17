/*
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

import Foundation

public struct FlapProducts {
  
  // TODO:  Change this to the BundleID chosen when registering this app's App ID in the Apple Member Center.
  private static let Prefix = "com.amazingapps.flapforharambe."
  
  public static let RemoveAds = Prefix + "removeads"
  
  private static let productIdentifiers: Set<ProductIdentifier> = [FlapProducts.RemoveAds]
  
  // TODO: This is the code that would be used if you added iPhoneRage, NightlyRage, and UpdogRage to the list of purchasable
  //       products in iTunesConnect.
/*
  public static let GirlfriendOfDrummerRage = Prefix + "GirlfriendOfDrummerRage"
  public static let iPhoneRage              = Prefix + "iPhoneRage"
  public static let NightlyRage             = Prefix + "NightlyRage"
  public static let UpdogRage               = Prefix + "UpdogRage"
  
  private static let productIdentifiers: Set<ProductIdentifier> = [RageProducts.GirlfriendOfDrummerRage,
                                                                   RageProducts.iPhoneRage,
                                                                   RageProducts.NightlyRage,
                                                                   RageProducts.UpdogRage]
*/
  public static let store = IAPHelper(productIds: FlapProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(productIdentifier: String) -> String? {
  return productIdentifier.componentsSeparatedByString(".").last
}
