
import Foundation
import CoreData
import WatchKit

class ScheduleController: WKInterfaceController {
  @IBOutlet weak var scheduleTable: WKInterfaceTable!
  lazy var coreDataStack = CoreDataStack()
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)

    // Configure interface objects here.
  }

  override func willActivate() {
    super.willActivate()

    if let conferencePlist = NSBundle.mainBundle().URLForResource("RWDevCon2015", withExtension: "plist") {
      Config.loadDataFromPlist(conferencePlist, context: coreDataStack.context)
      coreDataStack.saveContext()
    }

    let fetch = NSFetchRequest(entityName: "Session")
    fetch.predicate = NSPredicate(format: "active = %@", argumentArray: [true])
    fetch.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true), NSSortDescriptor(key: "track.trackId", ascending: true)]

    if let results = coreDataStack.context.executeFetchRequest(fetch, error: nil) as? [Session] {
      scheduleTable.setNumberOfRows(results.count, withRowType: "ScheduleRow")

      for (index, session) in enumerate(results) {
        let row = scheduleTable.rowControllerAtIndex(index) as ScheduleRow
        row.rowLabel.setText(session.fullTitle)
      }
    }
  }

  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }

}
