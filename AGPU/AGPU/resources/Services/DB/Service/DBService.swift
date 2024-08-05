//
//  DBService.swift
//  AGPU
//
//  Created by Марк Киричко on 18.07.2024.
//

import Fluent
import Vapor
import FluentPostgresDriver
import Alamofire

final class DBService {
    
    let app = Application()
    
    var response: DBResponse
    var id: Int = 0
    
    init(response: DBResponse) {
        self.response = response
    }
    
    func setUpDataBase() {
        app.databases.use(
            .postgres(
                configuration: .init(
                    hostname: "202.181.148.79",
                    port: 3333,
                    username: "guest",
                    password: "lapshin",
                    database: "agpu_db",
                    tls: .disable
                )
            ),
            as: .psql
        )
    }
    
    func getData() {
        
        setUpDataBase()
        
        switch response {
            
        case .departments:
            app.routes.get("DepartmentItem") { req async throws -> [DepartmentItem] in
                let result = try await DepartmentItem.query(on: req.db).all()
                return result
            }
            
            startServer()
            
        case .teachers:
            app.routes.get("teachers") { req async throws -> [Teacher] in
                if let sql = req.db as? SQLDatabase {
                    let number = String(self.id)
                    let result = try await sql.raw("SELECT * FROM teachers t JOIN lnk_teacher_DepartmentItem ltd ON t.id = ltd.teacher_id WHERE ltd.DepartmentItem_id = \(unsafeRaw: number)").all(decodingFluent: Teacher.self)
                    return result
                }
                return []
            }
            
            startServer()
            
        }
    }
    
    func startServer() {
        do {
            try app.run()
            print("started")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func stopServer() {
        print("stopped")
        app.shutdown()
    }
    
    func getDepartmentItems(completion: @escaping([DepartmentItem])->Void) {
        AF.request("http://localhost:8080/DepartmentItem")
            .responseData { response in
                print(response.response?.statusCode)
                switch response.result {
                case .success(let data):
                    do {
                        let result = try JSONDecoder().decode([DepartmentItem].self, from: data)
                        self.stopServer()
                        completion(result)
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
          }
    }
    
    func getTeachers(completion: @escaping([Teacher])->Void) {
        AF.request("http://localhost:8080/teachers")
            .responseData { response in
                print(response.response?.statusCode)
                switch response.result {
                case .success(let data):
                    do {
                        let result = try JSONDecoder().decode([Teacher].self, from: data)
                        self.stopServer()
                        completion(result)
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
              }
         }
    }
}
