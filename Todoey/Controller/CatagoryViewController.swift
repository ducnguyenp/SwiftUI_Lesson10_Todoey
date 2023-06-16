import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CatagoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categories: Results<Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        tableView.separatorStyle = .none
    }
    
    @IBAction func addCatagoryAction(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { action in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            
            self.saveCategory(category: newCategory)
        }
        
        alert.addAction(action)
        alert.addTextField() { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
            
        }
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategory(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Save failed", error)
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            } catch {
                print("Delete failed", error)
            }
        }
    }
}

extension CatagoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let categoryName = categories?[indexPath.row].name ?? "No category add yet"
        cell.textLabel?.text = categoryName
        let color = UIColor(hexString: categories?[indexPath.row].color ?? "1D9BF6")
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color!, returnFlat: true)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationCV = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationCV.selectedCategory = categories[indexPath.row]
        }
    }
    
}

