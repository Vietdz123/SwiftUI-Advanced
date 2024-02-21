import UIKit

let operationA = BlockOperation {
    for index in 0 ... 100 {
        print("DEBUG: operationA excuted \(index)")
    }
}


let operationB = BlockOperation {
    if operationA.isCancelled {
        print("DEBUG: operationA isCancelled")
        return
    }
    
    print("DEBUG: operationB excuted")
}

let operationQueue = OperationQueue()
operationQueue.addOperations([operationA, operationB], waitUntilFinished: false)

operationQueue.waitUntilAllOperationsAreFinished()
print("Done!")



