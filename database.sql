CREATE TABLE IF NOT EXISTS nexus_whitelist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    steam_id VARCHAR(255) NOT NULL,
    discord_id VARCHAR(255) NOT NULL,
    player_name VARCHAR(255) NOT NULL,
    UNIQUE KEY unique_whitelist_entry (steam_id, discord_id)
);
