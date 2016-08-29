//
//  StoreupHelpers.swift
//  iPose
//
//  Created by 王振宇 on 16/8/29.
//  Copyright © 2016年 王振宇. All rights reserved.
//

private let DB = NSUserDefaults.standardUserDefaults()
private let DBSaveImageKey = "DBSaveImageKey"

class StoreupHelpers: NSObject {
    private static let shareInstance = StoreupHelpers()
}

//MARK: Private
extension StoreupHelpers {
    private func addItem(item: PoseModelType) {
        let itemDic = ["preview": item.preview, "poseImage": item.poseImage]
        guard let dataDic = DB.dictionaryForKey(DBSaveImageKey) else {
            let tempDic = [item.preview: itemDic]
            DB.setObject(tempDic, forKey: DBSaveImageKey)
            return
        }
        let tempDic: NSMutableDictionary = NSMutableDictionary(dictionary: dataDic)
        tempDic.setObject(itemDic, forKey: item.preview)
        DB.setObject(tempDic.copy(), forKey: DBSaveImageKey)
    }
}

//MARK: Public
extension StoreupHelpers {
    class func addItem(item: PoseModelType) {
        shareInstance.addItem(item)
    }
    class func saveModelArray() -> [PoseModelType] {
        guard let dataDic = DB.dictionaryForKey(DBSaveImageKey) else { return [] }
        var result: [PoseModelType] = []
        for key in dataDic.keys {
            guard let tempDic = dataDic[key] else { continue }
            result.append(SaveModel(preview: tempDic["preview"] as! String, poseImage: tempDic["poseImage"] as! String))
        }
        return result
    }
}
