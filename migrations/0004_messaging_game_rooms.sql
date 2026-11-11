-- RH-WEBSITE messaging and game rooms
CREATE TABLE IF NOT EXISTS direct_messages (
 id TEXT PRIMARY KEY,
 from_user_id TEXT NOT NULL,
 to_user_id TEXT NOT NULL,
 body TEXT NOT NULL,
 created_at TEXT NOT NULL,
 read_at TEXT,
 FOREIGN KEY(from_user_id) REFERENCES users(id) ON DELETE CASCADE,
 FOREIGN KEY(to_user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_direct_messages_pair ON direct_messages(from_user_id,to_user_id,created_at);
CREATE INDEX IF NOT EXISTS idx_direct_messages_inbox ON direct_messages(to_user_id,read_at,created_at);

CREATE TABLE IF NOT EXISTS game_rooms (
 id TEXT PRIMARY KEY,
 owner_id TEXT NOT NULL,
 name TEXT NOT NULL,
 description TEXT NOT NULL DEFAULT '',
 game TEXT NOT NULL DEFAULT '',
 created_at TEXT NOT NULL,
 FOREIGN KEY(owner_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_game_rooms_created ON game_rooms(created_at DESC);

CREATE TABLE IF NOT EXISTS game_room_members (
 room_id TEXT NOT NULL,
 user_id TEXT NOT NULL,
 joined_at TEXT NOT NULL,
 PRIMARY KEY(room_id,user_id),
 FOREIGN KEY(room_id) REFERENCES game_rooms(id) ON DELETE CASCADE,
 FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_game_room_members_user ON game_room_members(user_id,joined_at);
