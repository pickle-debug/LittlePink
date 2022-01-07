//
//  WaterfallVC-LoadData.swift
//  LittlePink
//
//  Created by mac on 2021/12/29.
//

import CoreData

extension WaterfallVC{
    func getDraftNotes(){
        let request = DraftNote.fetchRequest() as NSFetchRequest<DraftNote>

        //分页(上拉加载)
        //request.fetchOffset = 0 //偏移量,跳过前面0个数据往后取
        //request.fetchLimit = 20//取后续20个数据
        
        //筛选
        //request.predicate = NSPredicate(format: "title = %@", "iOS")
        //排序
        let sortDescriptors1 = NSSortDescriptor(key: "updatedAt", ascending: false )//时间逆序排序
        request.sortDescriptors = [sortDescriptors1]
        
//        request.returnsObjectsAsFaults
        
        let draftNotes = try! context.fetch(request)
        self.draftNotes = draftNotes
    }
}
