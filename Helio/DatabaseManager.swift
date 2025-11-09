import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()

    private var db: OpaquePointer?
    private let dbPath: String

    init() {
        // Store database in Application Support directory
        let fileManager = FileManager.default
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let helioDir = appSupport.appendingPathComponent("Helio", isDirectory: true)

        // Create directory if it doesn't exist
        try? fileManager.createDirectory(at: helioDir, withIntermediateDirectories: true)

         dbPath = helioDir.appendingPathComponent("helio.db").path
        print("📁 Database path: \(dbPath)")

        openDatabase()
        createTables()
    }

    private func openDatabase() {
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            print("❌ Error opening database")
        } else {
            print("✅ Database opened successfully")
        }
    }

    private func createTables() {
        // Create recipients table
        let createRecipientsTable = """
        CREATE TABLE IF NOT EXISTS recipients (
            id TEXT PRIMARY KEY,
            email TEXT UNIQUE,
            name TEXT,
            recipient_type TEXT,
            formality_score REAL DEFAULT 0.5,
            preferred_tone TEXT,
            preferred_length TEXT,
            confidence_score REAL DEFAULT 0.0,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
        """

        // Create interactions table
        let createInteractionsTable = """
        CREATE TABLE IF NOT EXISTS interactions (
            id TEXT PRIMARY KEY,
            recipient_id TEXT,
            app_name TEXT,
            intent TEXT,
            generated_text TEXT,
            action TEXT,
            tone_detected TEXT,
            length_detected TEXT,
            timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (recipient_id) REFERENCES recipients(id)
        );
        """

        // Create app_preferences table
        let createAppPreferencesTable = """
        CREATE TABLE IF NOT EXISTS app_preferences (
            id TEXT PRIMARY KEY,
            app_name TEXT UNIQUE,
            detail_level TEXT,
            include_context BOOLEAN DEFAULT TRUE,
            include_examples BOOLEAN DEFAULT FALSE,
            preferred_format TEXT,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
        """

        // Create rejected_versions table
        let createRejectedVersionsTable = """
        CREATE TABLE IF NOT EXISTS rejected_versions (
            id TEXT PRIMARY KEY,
            session_id TEXT,
            recipient_id TEXT,
            intent TEXT,
            rejected_text TEXT,
            timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
        """

        executeSQL(createRecipientsTable)
        executeSQL(createInteractionsTable)
        executeSQL(createAppPreferencesTable)
        executeSQL(createRejectedVersionsTable)
    }

    private func executeSQL(_ sql: String) {
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("✅ SQL executed: \(sql.prefix(50))...")
            } else {
                print("❌ Failed to execute SQL")
            }
        } else {
            print("❌ Failed to prepare SQL: \(sql.prefix(50))...")
        }

        sqlite3_finalize(statement)
    }

    // MARK: - Interaction Logging

    func logInteraction(intent: String, generatedText: String, action: String, appName: String?) {
        let id = UUID().uuidString
        let app = appName ?? "unknown"

        let insertSQL = """
        INSERT INTO interactions (id, app_name, intent, generated_text, action, timestamp)
        VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP);
        """

        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, insertSQL, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (app as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (intent as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (generatedText as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (action as NSString).utf8String, -1, nil)

            if sqlite3_step(statement) == SQLITE_DONE {
                print("✅ Logged \(action) event to database")
            } else {
                print("❌ Failed to log interaction")
            }
        } else {
            print("❌ Failed to prepare insert statement")
        }

        sqlite3_finalize(statement)
    }

    // MARK: - Statistics

    func getAcceptRejectCounts() -> (accepts: Int, rejects: Int) {
        var accepts = 0
        var rejects = 0

        let countSQL = """
        SELECT action, COUNT(*) FROM interactions GROUP BY action;
        """

        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, countSQL, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let action = String(cString: sqlite3_column_text(statement, 0))
                let count = Int(sqlite3_column_int(statement, 1))

                if action == "accept" {
                    accepts = count
                } else if action == "reject" {
                    rejects = count
                }
            }
        }

        sqlite3_finalize(statement)
        return (accepts, rejects)
    }

    func clearAllData() {
        executeSQL("DELETE FROM interactions;")
        executeSQL("DELETE FROM recipients;")
        executeSQL("DELETE FROM app_preferences;")
        executeSQL("DELETE FROM rejected_versions;")
        print("🗑️ All data cleared from database")
    }

    deinit {
        sqlite3_close(db)
    }
}
