import UIKit


//MARK: - 语法--代码执行块
//{ (参数) -> 返回值 in
//   代码块
//}

//MARK: -使用场景1--全局函数
//直接调用
let label: UILabel = {
    let label = UILabel()
    label.text = "xxx"
    return label
}()
//先定义再调用
let learn = { (lan: String) -> String in
    "学习\(lan)"
}
learn("iOS")
func learn1(_ lan: String) -> String{
    "学习\(lan)"
}
learn1("iOS")

let aa: Int?
let bb: (()->Void)? //不知道参数和返回值,可选型,Void等价于()

//MARK: -使用场景2--嵌套函数(重要)
func codingSwift(day: Int, appName: () ->String){
    print("学习Swift\(day)了,写了\(appName())App")
}
//传参时直接写闭包
codingSwift(day: 40, appName: { () -> String in
    "天气"
})
//传参时写已经写好了的闭包'名'
let appName = { () -> String in
    "Todos"
}
codingSwift(day: 60, appName: appName)
//传参时已经写好了函数名(需参数和返回值的个数和类型完全一样)
func appName1() -> String{
    "计算器"
}
codingSwift(day: 100, appName: appName1)

//MARK: -闭包简写1--尾随闭包 Trailing Closure
codingSwift(day: 130){ () -> String in
    "机器学习"
}


//overload 重载,允许给不同的函数定义同一个函数名
//MARK: -闭包简写2--根据上下文推断类型
func codingSwift(day: Int, appName: String, res:(Int,String) -> String){
    print("学习Swift\(day)天了,\(res(1,"Alamofire")),做成了\(appName)App")
}

codingSwift(day: 40,appName: "天气") { takeDay, use in
    "用了\(takeDay)天,使用了\(use)技术"
}
//MARK: -系统函数案例--sorted
let arr = [3,5,1,2,4]
let sortedArr = arr.sorted(by: >)
//MARK: - 闭包捕获
func makeIncrementer(forIncrement amount: Int) -> () -> Int { //制造一个递增器
    var runningTotal = 0
//    func incrementer() -> Int {
//        runningTotal += amount
//        return runningTotal
//    }
    let incrementer = { () -> Int in
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

let incrementByTen = makeIncrementer(forIncrement: 10)
incrementByTen()
incrementByTen()
incrementByTen()

let incrementBySeven = makeIncrementer(forIncrement: 7)
incrementBySeven()

incrementByTen()
//MARK: - 闭包是引用类型
let alsoIncrementByTen = incrementByTen
alsoIncrementByTen()//50

incrementByTen()//60

//MARK: - 逃逸闭包(@escaping)
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    //开启某个网络耗时任务(异步),在耗时任务执行完后需要调用闭包.此处为模拟
    completionHandlers.append(completionHandler)
}

func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}

class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

let instance = SomeClass()
instance.doSomething()
print(instance.x)
// Prints "200"

completionHandlers.first?()
print(instance.x)
// Prints "100"
