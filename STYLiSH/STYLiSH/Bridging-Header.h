//
//  Bridging-Header.h
//  STYLiSH
//
//  Created by 小妍寶 on 2024/8/5.
//

import Foundation

#import <TPDirect/TPDirect.h>


func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    TPDSetup.setWithAppId(APP_ID, withAppKey: "APP_KEY", with: TPDServerType.ServerType)
}
