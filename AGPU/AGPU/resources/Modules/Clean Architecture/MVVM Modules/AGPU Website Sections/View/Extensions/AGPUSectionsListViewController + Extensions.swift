//
//  AGPUSectionsListViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 22.06.2023.
//

import UIKit

// MARK: - UITableViewDataSource
extension AGPUSectionsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AGPUSections.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AGPUSections.sections[section].subsections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AGPUSubSectionTableViewCell.identifier, for: indexPath) as? AGPUSubSectionTableViewCell else {return UITableViewCell()}
        cell.configure(subsection: AGPUSections.sections[indexPath.section].subsections[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AGPUSectionsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = InteractiveView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        header.backgroundColor = .systemBackground
        header.tapAction = {
            self.sectionSelected(index: section)
        }
        let imageView = SpringImageView(image: UIImage(named: AGPUSections.sections[section].icon))
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        header.addSubview(imageView)
        imageView.frame = CGRect(x: 20, y: 0, width: 75, height: 75)
        
        let label = UILabel(frame: CGRect(x: 30 + imageView.frame.size.width, y: 0,
                                          width: header.frame.size.width - 15 - imageView.frame.size.width,
                                          height: header.frame.size.height-10))
        label.numberOfLines = 0
        header.addSubview(label)
        label.text = AGPUSections.sections[section].name
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .black)
        return header
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let section = AGPUSections.sections[indexPath.section]
            let subsection = AGPUSections.sections[indexPath.section].subsections[indexPath.row]
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                self.shareInfo(image: UIImage(named: section.icon)!, title: subsection.name, text: subsection.url)
            }
            
            return UIMenu(title: subsection.name, image: UIImage(named: section.icon), children: [
                shareAction
            ])
        })
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subsection = AGPUSections.sections[indexPath.section].subsections[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? AGPUSubSectionTableViewCell {
            cell.didTapCell(indexPath: indexPath)
        }
        HapticsManager.shared.hapticFeedback() 
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.goToWeb(url: subsection.url, image: subsection.icon, title: "АГПУ сайт", isSheet: false)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension AGPUSectionsListViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("прокрутка завершилась")
        HapticsManager.shared.hapticFeedback()
        scrollView.isUserInteractionEnabled = true
    }
}

extension AGPUSectionsListViewController {
    
    func sectionSelected(index: Int) {
        let section = AGPUSections.sections[index]
        self.goToWeb(url: section.url, image: section.icon, title: section.name, isSheet: false)
    }
}

