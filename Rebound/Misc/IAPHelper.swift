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

import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()

open class IAPHelper : NSObject  {
  
  static let IAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"
  
  public init(productIds: Set<ProductIdentifier>) {
    super.init()
  }
}

// MARK: - StoreKit API

extension IAPHelper {
  
  public func requestProducts(_ completionHandler: ProductsRequestCompletionHandler) {
    completionHandler(false, [])
  }

  public func buyProduct(_ product: SKProduct) {
  }

  public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
    return false
  }
  
  public class func canMakePayments() -> Bool {
    return true
  }
  
  public func restorePurchases() {
  }
}