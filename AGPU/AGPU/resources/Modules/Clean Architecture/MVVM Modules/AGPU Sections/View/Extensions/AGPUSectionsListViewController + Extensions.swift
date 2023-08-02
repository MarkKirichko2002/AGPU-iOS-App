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

        imageView.contentMode = .scaleAspectFit
        header.addSubview(imageView)
        imageView.frame = CGRect(x: 20, y: 0, width: 75, height: 75)
        
        let label = UILabel(frame: CGRect(x: 30 + imageView.frame.size.width, y: 0,
                                          width: header.frame.size.width - 15 - imageView.frame.size.width,
                                          height: header.frame.size.height-10))
        label.numberOfLines = 0
        header.addSubview(label)
        label.text = AGPUSections.sections[section].name
        label.font = .systemFont(ofSize: 16, weight: .black)
        return header
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
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.GoToWeb(url: subsection.url, title: "ФГБОУ ВО «АГПУ»", isSheet: false)
        }
    }
}

extension AGPUSectionsListViewController {
    
    func sectionSelected(index: Int) {
        let section = AGPUSections.sections[index]
        self.GoToWeb(url: section.url, title: section.name, isSheet: false)
    }
}
