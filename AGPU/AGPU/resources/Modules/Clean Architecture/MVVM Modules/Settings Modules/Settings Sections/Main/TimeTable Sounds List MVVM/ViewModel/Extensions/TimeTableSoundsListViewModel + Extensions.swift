//
//  TimeTableSoundsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.04.2024.
//

import Foundation

// MARK: - ITimeTableSoundsListViewModel
extension TimeTableSoundsListViewModel: ITimeTableSoundsListViewModel {
    
    func soundItem(index: Int)-> TimeTableSoundModel {
        let item = TimeTableSounds.sounds[index]
        return item
    }
    
    func numberOfItems()-> Int {
        return TimeTableSounds.sounds.count
    }
    
    func selectSound(index: Int) {
        let item = soundItem(index: index)
        let savedSound = UserDefaults.standard.object(forKey: "timetable sound") as? String ?? "clock_sound"
        playSound(sound: item.sound)
        saveSound(sound: item.sound)
        dataChangedHandler?()
    }
    
    func saveSound(sound: String) {
        UserDefaults.standard.setValue(sound, forKey: "timetable sound")
    }
    
    func playSound(sound: String) {
        if sound != "" {
            audioPlayerClass.playSound(sound: sound, isPlaying: false)
        } else {
            stopSound()
        }
    }
    
    func stopSound() {
        audioPlayerClass.stopSound()
    }
    
    func isSoundSelected(index: Int)-> Bool {
        let item = soundItem(index: index)
        let savedSound = UserDefaults.standard.object(forKey: "timetable sound") as? String ?? "clock_sound"
        if item.sound == savedSound {
            return true
        }
        return false
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
