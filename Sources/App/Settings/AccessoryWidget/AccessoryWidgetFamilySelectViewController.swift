import Eureka
import Foundation
import Shared

class AccessoryWidgetFamilySelectViewController: HAFormViewController, RowControllerType {
    let currentFamilies: Set<ComplicationGroupMember>

    init(currentFamilies: Set<ComplicationGroupMember>) {
        self.currentFamilies = currentFamilies
        super.init()
    }

    var onDismissCallback: ((UIViewController) -> Void)?

    @objc private func cancel(_ sender: UIBarButtonItem) {
        onDismissCallback?(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = L10n.Watch.Configurator.New.title

        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:))),
        ]

        setupForm()
    }

    private func setupForm() {
        form.append(contentsOf: AccessoryWidgetGroup.allCases.sorted().map { group in
            let section = Section(header: group.name, footer: group.description)
            section.append(contentsOf: group.members.sorted().map { family in
                ButtonRow {
                    $0.title = family.shortName
                    $0.cellStyle = .subtitle

                    $0.cellUpdate { cell, row in
                        cell.detailTextLabel?.textColor = row.isDisabled ? .tertiaryLabel : .secondaryLabel
                        cell.textLabel?.textColor = row.isDisabled ? .secondaryLabel : .label
                        cell.detailTextLabel?.numberOfLines = 0
                        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
                        cell.detailTextLabel?.text = family.description

                        if row.isDisabled {
                            cell.accessibilityTraits.insert(.notEnabled)
                        } else {
                            cell.accessibilityTraits.remove(.notEnabled)
                        }
                    }

                    $0.presentationMode = .show(controllerProvider: .callback { [] in
                        let complication = AccessoryWidget()
                        complication.Family = family

                        return AccessoryWidgetEditViewController(config: complication)
                    }, onDismiss: { [weak self] vc in
                        guard let self, let vc = vc as? AccessoryWidgetEditViewController else { return }

                        if vc.config.realm == nil {
                            // not saved
                            navigationController?.popViewController(animated: true)
                        } else {
                            // saved
                            onDismissCallback?(self)
                        }
                    })
                }
            })
            return section
        })
    }
}
