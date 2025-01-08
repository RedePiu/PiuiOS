//
//  NotificationRN.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 29/08/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation

class NotificationRN: BaseRN {
    
    init() {
        super.init(delegate: nil)
    }
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }

    func insertNotification(notification: PushResponse) {
        notification.id = DBManager.shared.incrementID(PushResponse.self, primaryKeyName: "id")
        NotificationsDAO().insert(with: notification)
    }
    
    func deleteNotification(notification: PushResponse) {
        NotificationsDAO().delete(with: notification)
    }
    
    func getNotifications() -> [PushResponse] {
        return NotificationsDAO().getAll(userId: UserRN.getLoggedUserId())
    }
    
    static func needAppOpened(pushResponse: PushResponse) -> Bool {
        return pushResponse.cod == ActionFinder.PushActions.INITIALIZATION ||
        pushResponse.cod == ActionFinder.PushActions.RESTART_APP ||
        pushResponse.cod == ActionFinder.PushActions.CALL_USER_INFO;
    }
    
    static func doAppOpenedAction(pushResponse: PushResponse) {
        switch pushResponse.cod {
            case ActionFinder.PushActions.INITIALIZATION:
            ApplicationRN.setNeedInitialization(need: true)
                break
            case ActionFinder.PushActions.RESTART_APP:
            ApplicationRN.setNeedInitialization(need: true)
                break
            default:
                Log.print("")
        }
    }
//       /**
//        * Called whenever a new push notification that needs app opened is received
//        * @param pushResponse The received push response
//        */
//       public void doAppOpenedAction(PushResponse pushResponse) {
//           if (pushResponse == null) {
//               return;
//           }
//
//           switch (pushResponse.getCod()) {
//               case ActionFinder.PushActions.INITIALIZATION:
//                   ApplicationRN.setAppNeedDoInitialization(mContext, true);
//                   startReinitializeActivity();
//                   break;
//
//               case ActionFinder.PushActions.RESTART_APP:
//                   ApplicationRN.setAppNeedDoInitialization(mContext, true);
//                   Util.restartApp(mContext);
//                   break;
//
//               case ActionFinder.PushActions.CALL_USER_INFO:
//                   UserRN userRN = new UserRN(mContext, this);
//                   userRN.getUserInfo();
//                   break;
//
//               case ActionFinder.PushActions.OPEN_QIWIZINHOS:
//                   startMyQiwizinhoActivity();
//                   break;
//               case ActionFinder.PushActions.OPEN_TRANSACTION:
//                   startOrderDetailAtctivity(pushResponse);
//                   break;
//           }
//       }
}
