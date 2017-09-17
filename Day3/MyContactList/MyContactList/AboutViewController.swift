//
//  AboutViewController.swift
//  MyContactList
//
//  Created by Amnuay M on 8/29/17.
//  Copyright © 2017 Amnuay M. All rights reserved.
//

import UIKit
import GoogleMobileAds


class AboutViewController: UIViewController {
    
//    @UIApplicationMain
//    class AppDelegate: UIResponder, UIApplicationDelegate {
//
//        var window: UIWindow?
//        let MyAdmobAppID = "ca-app-pub-7050236446859797~6766047856"
//
//        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//            // Initialize the Google Mobile Ads SDK.
//            // Sample AdMob app ID: ca-app-pub-3940256099942544~1458002511
//            GADMobileAds.configure(withApplicationID: "\(MyAdmobAppID)")
//            return true
//        }
//    }

    
//    var bannerView: GADBannerView!
    let MyAdmobUnitID = "ca-app-pub-7050236446859797/4150604755"
    
    @IBOutlet weak var GoogleAdMobBanner: GADBannerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        GoogleAdMobBanner = GADBannerView(adSize: kGADAdSizeFullBanner)
//        self.view.addSubview(GoogleAdMobBanner)
         GoogleAdMobBanner.adUnitID = "\(MyAdmobUnitID)"
        GoogleAdMobBanner.rootViewController = self
       
        let request: GADRequest = GADRequest()
        request.testDevices = [kGADSimulatorID]
        GoogleAdMobBanner.load(request)
//        GoogleAdMobBanner.delegate = (self as! GADBannerViewDelegate)
    }
    
    /// Tells the delegate an ad request loaded an ad.
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        print("adViewDidReceiveAd")
//    }
//
//    /// Tells the delegate an ad request failed.
//    func adView(_ bannerView: GADBannerView,
//                didFailToReceiveAdWithError error: GADRequestError) {
//        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
//    }
//
//    /// Tells the delegate that a full screen view will be presented in response
//    /// to the user clicking on an ad.
//    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
//        print("adViewWillPresentScreen")
//    }
//
//    /// Tells the delegate that the full screen view will be dismissed.
//    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
//        print("adViewWillDismissScreen")
//    }
//
//    /// Tells the delegate that the full screen view has been dismissed.
//    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
//        print("adViewDidDismissScreen")
//    }
//
//    /// Tells the delegate that a user click will open another app (such as
//    /// the App Store), backgrounding the current app.
//    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
//        print("adViewWillLeaveApplication")
//    }
    
    
    
    
    
    @IBAction func EmailButton() {
        if let url = NSURL(string: "https://www.google.com"){
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
//            UIApplication.shared.openURL(url as URL)
//            UIApplication.sharedApplication().openURL(url)
        }
    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
