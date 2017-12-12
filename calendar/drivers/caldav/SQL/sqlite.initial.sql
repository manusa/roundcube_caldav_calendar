CREATE TABLE IF NOT EXISTS "caldav_calendars" (
	`calendar_id`	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	`user_id`	INTEGER NOT NULL DEFAULT '0',
	`name`	varchar(255) NOT NULL,
	`color`	varchar(8) NOT NULL,
	`showalarms`	INTEGER NOT NULL DEFAULT '1',
	`readonly`	INTEGER NOT NULL DEFAULT '1',
	`caldav_url`	varchar(255) NOT NULL,
	`caldav_tag`	varchar(255) DEFAULT NULL,
	`caldav_user`	varchar(255) DEFAULT NULL,
	`caldav_pass`	varchar(1024) DEFAULT NULL,
	`caldav_oauth_provider`	varchar(255) DEFAULT NULL,
	`caldav_last_change`	timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY(`user_id`) REFERENCES `users` ( `user_id` ) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX IF NOT EXISTS "caldav_user_name_idx" ON "caldav_calendars"(`user_id`, `name`);

CREATE TABLE IF NOT EXISTS "caldav_events" (
	`event_id`	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	`calendar_id`	integer NOT NULL DEFAULT '0',
	`recurrence_id`	integer NOT NULL DEFAULT '0',
	`uid`	varchar(255) NOT NULL DEFAULT '',
	`instance`	varchar(16) NOT NULL DEFAULT '',
	`isexception`	integer NOT NULL DEFAULT '0',
	`created`	datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
	`changed`	datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
	`sequence`	integer NOT NULL DEFAULT '0',
	`start`	datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
	`end`	datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
	`recurrence`	varchar(255) DEFAULT NULL,
	`title`	varchar(255) NOT NULL,
	`description`	text NOT NULL,
	`location`	varchar(255) NOT NULL DEFAULT '',
	`categories`	varchar(255) NOT NULL DEFAULT '',
	`url`	varchar(255) NOT NULL DEFAULT '',
	`all_day`	integer NOT NULL DEFAULT '0',
	`free_busy`	integer NOT NULL DEFAULT '0',
	`priority`	integer NOT NULL DEFAULT '0',
	`sensitivity`	integer NOT NULL DEFAULT '0',
	`status`	varchar(32) NOT NULL DEFAULT '',
	`alarms`	text DEFAULT NULL,
	`attendees`	text DEFAULT NULL,
	`notifyat`	datetime DEFAULT NULL,
	`caldav_url`	varchar(255) NOT NULL,
	`caldav_tag`	varchar(255) DEFAULT NULL,
	`caldav_last_change`	timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT `uk_caldav_event` UNIQUE (`calendar_id`,`recurrence_id`,`uid`,`caldav_tag`,`instance`),
	FOREIGN KEY(`calendar_id`) REFERENCES `caldav_calendars` ( `calendar_id` ) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX IF NOT EXISTS "caldav_uid_idx" ON "caldav_events"(`uid`);
CREATE INDEX IF NOT EXISTS "caldav_recurrence_idx" ON "caldav_events"(`recurrence_id`);
CREATE INDEX IF NOT EXISTS "caldav_calendar_notify_idx" ON "caldav_events"(`calendar_id`,`notifyat`);

CREATE TABLE IF NOT EXISTS "caldav_attachments" (
	`attachment_id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	`event_id` integer NOT NULL DEFAULT '0',
	`filename` varchar(255) NOT NULL DEFAULT '',
	`mimetype` varchar(255) NOT NULL DEFAULT '',
	`size` integer NOT NULL DEFAULT '0',
	`data` text NOT NULL,
	FOREIGN KEY(`event_id`) REFERENCES `caldav_events`(`event_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

REPLACE INTO `system` (`name`, `value`) VALUES ('calendar-caldav-version', '2016072000');
