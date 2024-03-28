BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "results" (
	"student_id"	INTEGER NOT NULL UNIQUE,
	"Maths"	INTEGER,
	"English"	INTEGER,
	"Economics"	INTEGER,
	"Biology"	INTEGER,
	"Total"	INTEGER,
	"Grade"	TEXT,
	PRIMARY KEY("student_id")
);
CREATE TABLE IF NOT EXISTS "Test" (
	"a"	INT,
	"b"	INT,
	"c"	 GENERATED ALWAYS AS ("a" + "b") VIRTUAL
);
CREATE TABLE IF NOT EXISTS "card" (
	"serial"	INTEGER NOT NULL UNIQUE,
	"pin"	INTEGER NOT NULL UNIQUE,
	"print_date"	datetime NOT NULL DEFAULT (CURRENT_TIMESTAMP),
	"expiry"	TEXT,
	PRIMARY KEY("serial")
);
CREATE TABLE IF NOT EXISTS "TbCard" (
	"serial"	INTEGER NOT NULL UNIQUE,
	"pin"	INTEGER NOT NULL UNIQUE,
	"print_date"	datetime NOT NULL DEFAULT (CURRENT_TIMESTAMP),
	"expiry"	TEXT NOT NULL DEFAULT (datetime('now', '+3 months')),
	"used"	INTEGER DEFAULT (0),
	PRIMARY KEY("serial")
);
CREATE TABLE IF NOT EXISTS "django_migrations" (
	"id"	integer NOT NULL,
	"app"	varchar(255) NOT NULL,
	"name"	varchar(255) NOT NULL,
	"applied"	datetime NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_group_permissions" (
	"id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "auth_user_groups" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "auth_user_user_permissions" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "django_admin_log" (
	"id"	integer NOT NULL,
	"object_id"	text,
	"object_repr"	varchar(200) NOT NULL,
	"action_flag"	smallint unsigned NOT NULL CHECK("action_flag" >= 0),
	"change_message"	text NOT NULL,
	"content_type_id"	integer,
	"user_id"	integer NOT NULL,
	"action_time"	datetime NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "django_content_type" (
	"id"	integer NOT NULL,
	"app_label"	varchar(100) NOT NULL,
	"model"	varchar(100) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_permission" (
	"id"	integer NOT NULL,
	"content_type_id"	integer NOT NULL,
	"codename"	varchar(100) NOT NULL,
	"name"	varchar(255) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "auth_group" (
	"id"	integer NOT NULL,
	"name"	varchar(150) NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_user" (
	"id"	integer NOT NULL,
	"password"	varchar(128) NOT NULL,
	"last_login"	datetime,
	"is_superuser"	bool NOT NULL,
	"username"	varchar(150) NOT NULL UNIQUE,
	"last_name"	varchar(150) NOT NULL,
	"email"	varchar(254) NOT NULL,
	"is_staff"	bool NOT NULL,
	"is_active"	bool NOT NULL,
	"date_joined"	datetime NOT NULL,
	"first_name"	varchar(150) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "django_session" (
	"session_key"	varchar(40) NOT NULL,
	"session_data"	text NOT NULL,
	"expire_date"	datetime NOT NULL,
	PRIMARY KEY("session_key")
);
CREATE TABLE IF NOT EXISTS "businessapp_tbcustomers" (
	"customer_id"	integer NOT NULL,
	"cust_first_name"	varchar(30) NOT NULL,
	"cust_last_name"	varchar(30) NOT NULL,
	"phone"	integer NOT NULL,
	"email"	varchar(254) NOT NULL,
	"gender"	varchar(10) NOT NULL,
	"age"	integer unsigned NOT NULL CHECK("age" >= 0),
	PRIMARY KEY("customer_id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "businessapp_tbproducts" (
	"product_id"	integer NOT NULL,
	"product_name"	varchar(30) NOT NULL,
	"product_description"	varchar(300) NOT NULL,
	"price"	integer NOT NULL,
	"image"	varchar(100) NOT NULL,
	"date_added"	datetime NOT NULL,
	"updated"	datetime NOT NULL,
	PRIMARY KEY("product_id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "gradetable" (
	"student_id"	INTEGER NOT NULL UNIQUE,
	"student_name"	TEXT,
	"Maths"	INTEGER,
	"English"	INTEGER,
	"Economics"	INTEGER,
	"Biology"	INTEGER,
	"Total"	 GENERATED ALWAYS AS ("Maths" + "English" + "Economics" + "Biology") VIRTUAL,
	"Avscore"	 GENERATED ALWAYS AS ("Total" / 4) VIRTUAL,
	"Grade"	 GENERATED ALWAYS AS (CASE WHEN "Avscore" >= 75 THEN 'A1' WHEN"Avscore" >= 70 THEN 'B2' WHEN"Avscore" >= 65 THEN 'B3' WHEN"Avscore" >= 60 THEN 'C4' WHEN"Avscore" >= 55 THEN 'C5' WHEN"Avscore" >= 50 THEN 'C6' WHEN"Avscore" >= 45 THEN 'D7' WHEN"Avscore" >= 40 THEN 'E8' ELSE 'F9' END) VIRTUAL,
	PRIMARY KEY("student_id")
);
CREATE TABLE IF NOT EXISTS "TbResults" (
	"student_id"	INTEGER NOT NULL UNIQUE,
	"student_name"	TEXT,
	"Maths"	INTEGER,
	"English"	INTEGER,
	"Economics"	INTEGER,
	"Biology"	INTEGER,
	"Total"	 GENERATED ALWAYS AS ("Maths" + "English" + "Economics" + "Biology") VIRTUAL,
	"Avscore"	 GENERATED ALWAYS AS ("Total" / 4) VIRTUAL,
	"Grade"	 GENERATED ALWAYS AS (CASE WHEN "Avscore" >= 75 THEN 'A1' WHEN"Avscore" >= 70 THEN 'B2' WHEN"Avscore" >= 65 THEN 'B3' WHEN"Avscore" >= 60 THEN 'C4' WHEN"Avscore" >= 55 THEN 'C5' WHEN"Avscore" >= 50 THEN 'C6' WHEN"Avscore" >= 45 THEN 'D7' WHEN"Avscore" >= 40 THEN 'E8' ELSE 'F9' END) VIRTUAL,
	PRIMARY KEY("student_id")
);
CREATE TABLE IF NOT EXISTS "stripee_price" (
	"id"	integer NOT NULL,
	"stripe_price_id"	varchar(100) NOT NULL,
	"price"	integer NOT NULL,
	"product_id"	bigint NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("product_id") REFERENCES "stripee_product"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "stripee_product" (
	"id"	integer NOT NULL,
	"name"	varchar(100) NOT NULL,
	"stripe_product_id"	varchar(100) NOT NULL,
	"file"	varchar(100),
	"url"	varchar(200) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "TbTransact" (
	"id"	INTEGER NOT NULL,
	"student_id"	INTEGER,
	"pin"	INTEGER,
	"card_use"	INTEGER,
	"use_date"	datetime NOT NULL DEFAULT (CURRENT_TIMESTAMP),
	FOREIGN KEY("student_id") REFERENCES "TbResults"("student_id") ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY("pin") REFERENCES "TbCard"("pin") ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS "TbUsed" (
	"id"	INTEGER NOT NULL,
	"student_id"	INTEGER,
	"pin"	INTEGER,
	"last_date"	TEXT NOT NULL DEFAULT (CURRENT_TIMESTAMP),
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("pin") REFERENCES "TbCard"("pin") ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY("student_id") REFERENCES "TbResults"("student_id") ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_group_permissions_group_id_permission_id_0cd325b0_uniq" ON "auth_group_permissions" (
	"group_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_group_id_b120cbf9" ON "auth_group_permissions" (
	"group_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_permission_id_84c5c92e" ON "auth_group_permissions" (
	"permission_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_groups_user_id_group_id_94350c0c_uniq" ON "auth_user_groups" (
	"user_id",
	"group_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_groups_user_id_6a12ed8b" ON "auth_user_groups" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_groups_group_id_97559544" ON "auth_user_groups" (
	"group_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq" ON "auth_user_user_permissions" (
	"user_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_a95ead1b" ON "auth_user_user_permissions" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_permission_id_1fbb5f2c" ON "auth_user_user_permissions" (
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_content_type_id_c4bce8eb" ON "django_admin_log" (
	"content_type_id"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_user_id_c564eba6" ON "django_admin_log" (
	"user_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" (
	"app_label",
	"model"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_permission_content_type_id_codename_01ab375a_uniq" ON "auth_permission" (
	"content_type_id",
	"codename"
);
CREATE INDEX IF NOT EXISTS "auth_permission_content_type_id_2f476e4b" ON "auth_permission" (
	"content_type_id"
);
CREATE INDEX IF NOT EXISTS "django_session_expire_date_a5c62663" ON "django_session" (
	"expire_date"
);
CREATE INDEX IF NOT EXISTS "stripee_price_product_id_453e8c24" ON "stripee_price" (
	"product_id"
);
CREATE TRIGGER trigg_del_card
AFTER UPDATE on TbTransact
WHEN card_use = 5
BEGIN
UPDATE TbCard
SET used = 1
WHERE pin = 
(
SELECT pin FROM TbTransact
WHERE card_use = 5
);
END;
COMMIT;
