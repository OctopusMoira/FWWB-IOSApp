//
//  TransChatDataSource.swift
//  FWWB
//
//  Created by ZQ on 2019/3/10.
//  Copyright © 2019年 ZQ. All rights reserved.
//

import Foundation

/*
  数据提供协议
*/
protocol TransChatDataSource
{
    /*返回对话记录中的全部行数*/
    func rowsForChatTable( _ tableView:TransTableView) -> Int
    /*返回某一行的内容*/
    func chatTableView(_ tableView:TransTableView, dataForRow:Int)-> TransMessageItem
}
