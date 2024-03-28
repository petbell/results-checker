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
CREATE TABLE IF NOT EXISTS "TbTransact" (
	"id"	INTEGER NOT NULL,
	"student_id"	INTEGER,
	"pin"	INTEGER,
	"card_use"	INTEGER,
	"use_date"	datetime NOT NULL DEFAULT (CURRENT_TIMESTAMP),
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "TbUsed" (
	"id"	INTEGER NOT NULL,
	"student_id"	INTEGER,
	"pin"	INTEGER,
	"last_date"	TEXT NOT NULL DEFAULT (CURRENT_TIMESTAMP),
	PRIMARY KEY("id" AUTOINCREMENT)
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
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "auth_user_user_permissions" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED
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
INSERT INTO "results" ("student_id","Maths","English","Economics","Biology","Total","Grade") VALUES (124,59,50,96,84,289,''),
 (125,48,96,86,64,294,''),
 (126,54,76,46,86,262,''),
 (127,46,68,75,64,253,NULL),
 (128,37,48,68,69,222,NULL);
INSERT INTO "Test" ("a","b","c") VALUES (1,2,3),
 (45,57,102);
INSERT INTO "card" ("serial","pin","print_date","expiry") VALUES (1,345,'2023-12-23 23:26:00','5'),
 (2,333,'2023-12-23 23:27:04','2'),
 (3,444,'2023-12-25 23:46:47','4'),
 (4,555,'2023-12-25 23:46:55','6');
INSERT INTO "TbCard" ("serial","pin","print_date","expiry","used") VALUES (1,111,'2023-12-24 18:08:11','2024-03-24 18:08:11',0),
 (2,222,'2023-12-24 18:08:20','2024-03-24 18:08:20',0),
 (3,333,'2023-12-24 18:08:24','2024-03-24 18:08:24',0),
 (4,444,'2023-12-24 18:08:35','2024-03-24 18:08:35',0),
 (5,555,'2023-12-24 18:08:40','2024-03-24 18:08:40',0),
 (6,666,'2023-12-24 18:14:40','2024-03-24 18:14:40',0),
 (7,777,'2023-12-24 18:08:48','2024-03-24 18:08:48',1),
 (8,888,'2023-12-24 19:07:32','2024-03-24 19:07:32',0),
 (9,999,'2023-12-25 23:38:11','2024-03-25 23:38:11',1),
 (10,1000,'2023-12-25 23:38:18','2024-03-25 23:38:18',1),
 (11,182212123149,'2024-01-22 12:33:04','2024-04-22 12:33:04',0),
 (12,415481937082,'2024-01-22 12:33:05','2024-04-22 12:33:05',0);
INSERT INTO "TbTransact" ("id","student_id","pin","card_use","use_date") VALUES (1,123,222,1,'2023-12-25 22:42:58'),
 (2,5,333,2,'2023-12-25 22:43:13'),
 (8,127,666,1,'2024-01-01 19:52:15'),
 (9,125,888,1,'2024-01-16 13:32:30'),
 (10,126,666,1,'2024-01-19 12:54:41'),
 (11,124,666,1,'2024-01-19 13:17:03'),
 (12,128,444,1,'2024-01-19 13:58:23'),
 (13,121,555,2,'2024-01-19 15:01:16'),
 (14,125,182212123149,2,'2024-03-24 20:51:13');
INSERT INTO "TbUsed" ("id","student_id","pin","last_date") VALUES (1,123,222,'2023-12-25 23:30:02'),
 (2,5,333,'2023-12-25 23:30:02'),
 (3,126,555,'2023-12-25 23:30:02'),
 (4,5,333,'2023-12-25 23:30:37'),
 (5,130,101,'2023-12-25 23:37:20'),
 (6,129,1000,'2023-12-25 23:38:42'),
 (7,126,999,'2024-01-01 19:19:57'),
 (8,126,555,'2024-01-01 19:25:44');
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (1,'contenttypes','0001_initial','2023-12-26 01:08:55.354273'),
 (2,'auth','0001_initial','2023-12-26 01:08:55.611347'),
 (3,'admin','0001_initial','2023-12-26 01:08:55.873766'),
 (4,'admin','0002_logentry_remove_auto_add','2023-12-26 01:08:56.103757'),
 (5,'admin','0003_logentry_add_action_flag_choices','2023-12-26 01:08:56.344689'),
 (6,'contenttypes','0002_remove_content_type_name','2023-12-26 01:08:56.618642'),
 (7,'auth','0002_alter_permission_name_max_length','2023-12-26 01:08:56.929619'),
 (8,'auth','0003_alter_user_email_max_length','2023-12-26 01:08:57.167521'),
 (9,'auth','0004_alter_user_username_opts','2023-12-26 01:08:57.451506'),
 (10,'auth','0005_alter_user_last_login_null','2023-12-26 01:08:57.710440'),
 (11,'auth','0006_require_contenttypes_0002','2023-12-26 01:08:57.878400'),
 (12,'auth','0007_alter_validators_add_error_messages','2023-12-26 01:08:58.074277'),
 (13,'auth','0008_alter_user_username_max_length','2023-12-26 01:08:58.285850'),
 (14,'auth','0009_alter_user_last_name_max_length','2023-12-26 01:08:58.568745'),
 (15,'auth','0010_alter_group_name_max_length','2023-12-26 01:08:58.788780'),
 (16,'auth','0011_update_proxy_permissions','2023-12-26 01:08:59.069715'),
 (17,'auth','0012_alter_user_first_name_max_length','2023-12-26 01:08:59.298654'),
 (18,'results','0001_initial','2023-12-26 01:08:59.669529'),
 (19,'sessions','0001_initial','2023-12-26 01:08:59.934582'),
 (20,'results','0002_remove_tbtransact_pin_remove_tbtransact_student_id_and_more','2023-12-27 20:03:32.903460'),
 (21,'results','0003_initial','2023-12-27 20:03:33.179713'),
 (22,'results','0004_delete_tbcard_delete_tbresults','2023-12-27 20:03:33.330108'),
 (23,'businessapp','0001_initial','2024-01-08 16:26:29.619690'),
 (24,'stripee','0001_initial','2024-02-07 14:22:39.124451'),
 (25,'stripee','0002_product_file_product_url','2024-02-08 18:41:43.900378');
INSERT INTO "django_admin_log" ("id","object_id","object_repr","action_flag","change_message","content_type_id","user_id","action_time") VALUES (1,'1','TbCustomers object (1)',1,'[{"added": {}}]',10,1,'2024-01-08 16:53:25.875431'),
 (2,'2','TbCustomers object (2)',1,'[{"added": {}}]',10,1,'2024-01-08 16:56:24.970885'),
 (3,'1','perfume',1,'[{"added": {}}]',11,1,'2024-01-09 10:38:12.615221'),
 (4,'2','Alifun',1,'[{"added": {}}]',11,1,'2024-01-09 10:38:55.236189'),
 (5,'1','perfume',2,'[{"changed": {"fields": ["Price"]}}]',11,1,'2024-01-09 10:41:46.369628'),
 (6,'3','Abubakar Faith Abubakar',1,'[{"added": {}}]',10,1,'2024-01-09 13:46:31.705173'),
 (7,'3','Rottweiler',1,'[{"added": {}}]',11,1,'2024-01-09 13:48:34.081083'),
 (8,'4','Mango',1,'[{"added": {}}]',11,1,'2024-01-09 13:49:55.570461'),
 (9,'5','Party food',1,'[{"added": {}}]',11,1,'2024-01-09 13:51:05.067221'),
 (10,'4','Mango',2,'[]',11,1,'2024-01-09 13:51:26.435052'),
 (11,'1','Test Product',1,'[{"added": {}}]',12,1,'2024-02-07 14:28:33.103687'),
 (12,'1','Price object (1)',1,'[{"added": {}}]',13,1,'2024-02-07 22:48:31.082888'),
 (13,'2','Price object (2)',1,'[{"added": {}}]',13,1,'2024-02-07 22:49:31.743843'),
 (14,'1','Test Product',2,'[{"changed": {"fields": ["Stripe product id"]}}]',12,1,'2024-02-07 22:50:55.809520'),
 (15,'1','Test Product',2,'[]',12,1,'2024-02-07 23:09:54.460421'),
 (16,'1','Test Product',2,'[{"changed": {"fields": ["Url"]}}]',12,1,'2024-02-08 18:58:15.977082');
INSERT INTO "django_content_type" ("id","app_label","model") VALUES (1,'results','tbcards'),
 (2,'results','tbresults'),
 (3,'results','tbtransact'),
 (4,'admin','logentry'),
 (5,'auth','permission'),
 (6,'auth','group'),
 (7,'auth','user'),
 (8,'contenttypes','contenttype'),
 (9,'sessions','session'),
 (10,'businessapp','tbcustomers'),
 (11,'businessapp','tbproducts'),
 (12,'stripee','product'),
 (13,'stripee','price');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (1,1,'add_tbcards','Can add tb cards'),
 (2,1,'change_tbcards','Can change tb cards'),
 (3,1,'delete_tbcards','Can delete tb cards'),
 (4,1,'view_tbcards','Can view tb cards'),
 (5,2,'add_tbresults','Can add tb results'),
 (6,2,'change_tbresults','Can change tb results'),
 (7,2,'delete_tbresults','Can delete tb results'),
 (8,2,'view_tbresults','Can view tb results'),
 (9,3,'add_tbtransact','Can add tb transact'),
 (10,3,'change_tbtransact','Can change tb transact'),
 (11,3,'delete_tbtransact','Can delete tb transact'),
 (12,3,'view_tbtransact','Can view tb transact'),
 (13,4,'add_logentry','Can add log entry'),
 (14,4,'change_logentry','Can change log entry'),
 (15,4,'delete_logentry','Can delete log entry'),
 (16,4,'view_logentry','Can view log entry'),
 (17,5,'add_permission','Can add permission'),
 (18,5,'change_permission','Can change permission'),
 (19,5,'delete_permission','Can delete permission'),
 (20,5,'view_permission','Can view permission'),
 (21,6,'add_group','Can add group'),
 (22,6,'change_group','Can change group'),
 (23,6,'delete_group','Can delete group'),
 (24,6,'view_group','Can view group'),
 (25,7,'add_user','Can add user'),
 (26,7,'change_user','Can change user'),
 (27,7,'delete_user','Can delete user'),
 (28,7,'view_user','Can view user'),
 (29,8,'add_contenttype','Can add content type'),
 (30,8,'change_contenttype','Can change content type'),
 (31,8,'delete_contenttype','Can delete content type'),
 (32,8,'view_contenttype','Can view content type'),
 (33,9,'add_session','Can add session'),
 (34,9,'change_session','Can change session'),
 (35,9,'delete_session','Can delete session'),
 (36,9,'view_session','Can view session'),
 (37,10,'add_tbcustomers','Can add tb customers'),
 (38,10,'change_tbcustomers','Can change tb customers'),
 (39,10,'delete_tbcustomers','Can delete tb customers'),
 (40,10,'view_tbcustomers','Can view tb customers'),
 (41,11,'add_tbproducts','Can add tb products'),
 (42,11,'change_tbproducts','Can change tb products'),
 (43,11,'delete_tbproducts','Can delete tb products'),
 (44,11,'view_tbproducts','Can view tb products'),
 (45,12,'add_product','Can add product'),
 (46,12,'change_product','Can change product'),
 (47,12,'delete_product','Can delete product'),
 (48,12,'view_product','Can view product'),
 (49,13,'add_price','Can add price'),
 (50,13,'change_price','Can change price'),
 (51,13,'delete_price','Can delete price'),
 (52,13,'view_price','Can view price');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (1,'pbkdf2_sha256$720000$cDcHYzUwnHw6CLmldBw0Z0$+F4ImOSYT/iZkuiGJRE0fDKY74GBoeq031kfslBtuAY=','2024-03-24 20:40:06.240467',1,'petbell','','petbell@live.com',1,1,'2023-12-26 01:12:56.685337',''),
 (2,'pbkdf2_sha256$720000$tUk1DsCMAkc3LapyzwyOk1$N2fuflxVD0pJW4FDP8hE3FCh/h555UP1oIBLq6qOABY=',NULL,1,'toshiba','','',1,1,'2023-12-27 20:05:21.720175',''),
 (3,'pbkdf2_sha256$720000$NgYaXhRZWAlEHVJGo3xAnp$k24R72nsxbmPFJiqeys9d+/f8LwW+AMJelJctOIBMwU=',NULL,0,'aje1','Dibia','djfhd@loidjd.com',0,1,'2024-01-05 00:03:43.604961','Babalawo'),
 (4,'pbkdf2_sha256$720000$9NEmRuZe1tH7argm37q26k$/Fn3teg1nWaYPuvys/bF8qsVb0Pmd03tspAF/yHq3+U=',NULL,0,'xav','Bello','dkdkssjdjdjd',0,1,'2024-01-07 23:31:14.783445','Xavier'),
 (5,'pbkdf2_sha256$720000$C9QlwZ4ZyxNWspBAyPfGR8$XU8Qwy9T7mOuYCI5Mn6ErOrdNoEx371Q/sP4QBO76+A=','2024-01-07 23:58:00.793074',0,'faith','Abu','faith@fati.com',0,1,'2024-01-07 23:35:30.392227','Fati'),
 (6,'pbkdf2_sha256$720000$Usur22zAebHYJgryW9HahE$vM2LyC0iOVkBwPQQ2UdAW6LjWaUjm+HchzC0auEFveI=',NULL,0,'pablo','Olusegun','pablo@gmail.com',0,1,'2024-03-23 23:36:43.500073','Peter');
INSERT INTO "django_session" ("session_key","session_data","expire_date") VALUES ('cetw0qhmzeetz932413mjbhgh16yuq7y','.eJxVjMsOwiAQRf-FtSE8KoJL9_2GZoYZpGogKe3K-O_SpAvd3nPOfYsJtjVPW-NlmklchRan3w0hPrnsgB5Q7lXGWtZlRrkr8qBNjpX4dTvcv4MMLfcaAicaAB24dMaA8ULBgwL21idi0B2DNUobiwP4hOjYqK4xWh2CE58vL0Y5fA:1rHw0Z:X8JUiBTqWX7WqHGYkrQWu3mlgwJ8g5TA5unuc8TR530','2024-01-09 01:13:23.201396'),
 ('8p9utb4v3almyaf9h86b9v1s22sh0ls5','.eJxVjMsOwiAQRf-FtSE8KoJL9_2GZoYZpGogKe3K-O_SpAvd3nPOfYsJtjVPW-NlmklchRan3w0hPrnsgB5Q7lXGWtZlRrkr8qBNjpX4dTvcv4MMLfcaAicaAB24dMaA8ULBgwL21idi0B2DNUobiwP4hOjYqK4xWh2CE58vL0Y5fA:1rMsdP:KfyOADB2ovLdfVw1ILSoaqgc27Bcfj_YBN3F0juZX9M','2024-01-22 16:37:55.372836'),
 ('os96g5o8ulu39xjfji9k30x6qrm3ydvh','.eJxVjMsOwiAQRf-FtSE8KoJL9_2GZoYZpGogKe3K-O_SpAvd3nPOfYsJtjVPW-NlmklchRan3w0hPrnsgB5Q7lXGWtZlRrkr8qBNjpX4dTvcv4MMLfcaAicaAB24dMaA8ULBgwL21idi0B2DNUobiwP4hOjYqK4xWh2CE58vL0Y5fA:1rN9Rz:BNP0mpbAmLr77cdwuBiP_hQcxCg7QlqJ8ESM5QWIqM0','2024-01-23 10:35:15.965520'),
 ('ilggyyzjl8zvb69un2x19fdc0982hk3r','.eJxVjMsOwiAQRf-FtSE8KoJL9_2GZoYZpGogKe3K-O_SpAvd3nPOfYsJtjVPW-NlmklchRan3w0hPrnsgB5Q7lXGWtZlRrkr8qBNjpX4dTvcv4MMLfcaAicaAB24dMaA8ULBgwL21idi0B2DNUobiwP4hOjYqK4xWh2CE58vL0Y5fA:1rQnzb:lPyJE2OEi3467RRfgzQA6bhEi9oJsREeshFDBxwPCXQ','2024-02-02 12:29:03.056159'),
 ('anr1uqiycemt7hf0j8z06wpezdm6nj0y','.eJxVjMsOwiAQRf-FtSE8KoJL9_2GZoYZpGogKe3K-O_SpAvd3nPOfYsJtjVPW-NlmklchRan3w0hPrnsgB5Q7lXGWtZlRrkr8qBNjpX4dTvcv4MMLfcaAicaAB24dMaA8ULBgwL21idi0B2DNUobiwP4hOjYqK4xWh2CE58vL0Y5fA:1rXgPf:EdWhheuj7tBu-IUIE9AhQ_q5AvPtOZqrj_k8fRwUhnQ','2024-02-21 11:48:23.090283'),
 ('ctw0ictsa88iwlhjmcjo15kfyyl0ub2o','.eJxVjMsOwiAQRf-FtSE8KoJL9_2GZoYZpGogKe3K-O_SpAvd3nPOfYsJtjVPW-NlmklchRan3w0hPrnsgB5Q7lXGWtZlRrkr8qBNjpX4dTvcv4MMLfcaAicaAB24dMaA8ULBgwL21idi0B2DNUobiwP4hOjYqK4xWh2CE58vL0Y5fA:1rXgDb:SX_yn8oyVu0K7C4cWrB1obBqVc9uQxZ7s69jTIko15o','2024-02-21 11:35:55.789206'),
 ('jd5wo5v8odrtpx99gt1tfhodk8g0ynmw','.eJxVjMsOwiAQRf-FtSE8KoJL9_2GZoYZpGogKe3K-O_SpAvd3nPOfYsJtjVPW-NlmklchRan3w0hPrnsgB5Q7lXGWtZlRrkr8qBNjpX4dTvcv4MMLfcaAicaAB24dMaA8ULBgwL21idi0B2DNUobiwP4hOjYqK4xWh2CE58vL0Y5fA:1ro9mL:R5Obtud4bFJ9SUfHWZI0Ns_9ST3V-XPU5a4Zg33S_2o','2024-04-06 22:23:53.932547'),
 ('5dxjo8261inyyvzn3uws9lt9ltqzwglv','.eJxVjMsOwiAQRf-FtSE8KoJL9_2GZoYZpGogKe3K-O_SpAvd3nPOfYsJtjVPW-NlmklchRan3w0hPrnsgB5Q7lXGWtZlRrkr8qBNjpX4dTvcv4MMLfcaAicaAB24dMaA8ULBgwL21idi0B2DNUobiwP4hOjYqK4xWh2CE58vL0Y5fA:1ro9mN:R6Vo1fV0Zzsrl66Qn9m1B362KwrNu0npLzq_SgKw51g','2024-04-06 22:23:55.149795'),
 ('02dwregpa6etccjxr8gii0p69m36ce0l','.eJxVjMsOwiAQRf-FtSE8KoJL9_2GZoYZpGogKe3K-O_SpAvd3nPOfYsJtjVPW-NlmklchRan3w0hPrnsgB5Q7lXGWtZlRrkr8qBNjpX4dTvcv4MMLfcaAicaAB24dMaA8ULBgwL21idi0B2DNUobiwP4hOjYqK4xWh2CE58vL0Y5fA:1roUdS:PR-yTNQ3Pr4kxTMeNee6SyHzpOB-kT5dw-0-KC52XHY','2024-04-07 20:40:06.504453');
INSERT INTO "businessapp_tbcustomers" ("customer_id","cust_first_name","cust_last_name","phone","email","gender","age") VALUES (1,'Xavier','Bello',8066644210,'xav@xav.com','M',3),
 (2,'Peter','Bello',8056357660,'petbell@live.com','M',39),
 (3,'Faith Abubakar','Abubakar',70130207897,'legendnikky@gmail.com','F',24);
INSERT INTO "businessapp_tbproducts" ("product_id","product_name","product_description","price","image","date_added","updated") VALUES (1,'perfume','anything smelling nice',500,'images/businessapp/20210430_084655_NB6Mp0o.jpg','2024-01-09 10:38:12.615221','2024-01-09 10:41:46.369628'),
 (2,'Alifun','A pair of binoculars',484,'images/businessapp/20210323_101641.jpg','2024-01-09 10:38:55.236189','2024-01-09 10:38:55.236189'),
 (3,'Rottweiler','A good and protective breed',150000,'images/businessapp/20210620_165946.jpg','2024-01-09 13:48:34.073120','2024-01-09 13:48:34.073120'),
 (4,'Mango','Sweet, juicy, ripe',4567,'images/businessapp/20220427_143301.jpg','2024-01-09 13:49:55.570461','2024-01-09 13:51:26.391030'),
 (5,'Party food','food for occassions',2300943,'images/businessapp/20211231_223459.jpg','2024-01-09 13:51:05.067221','2024-01-09 13:51:05.067221');
INSERT INTO "gradetable" ("student_id","student_name","Maths","English","Economics","Biology","Total","Avscore","Grade") VALUES (1,'Peter',34,58,75,58,225,56,'C5'),
 (2,'Adu',87,6,49,65,207,51,'C6'),
 (3,'Abel',65,57,43,83,248,62,'C4'),
 (4,'Pat',64,38,95,38,235,58,'C5'),
 (5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'F9');
INSERT INTO "TbResults" ("student_id","student_name","Maths","English","Economics","Biology","Total","Avscore","Grade") VALUES (120,'Peter',85,44,74,54,257,64,'C4'),
 (121,'Xavier',98,76,86,84,344,86,'A1'),
 (122,'Bola',75,65,46,84,270,67,'B3'),
 (123,'sUNNUYY',67,28,81,74,250,62,'C4'),
 (124,'Loco',87,53,73,23,236,59,'C5'),
 (125,'Beolo',39,93,74,63,269,67,'B3');
INSERT INTO "stripee_price" ("id","stripe_price_id","price","product_id") VALUES (1,'price_1OhJjACEL3dCjPQVdxsoNCxl',2000,1),
 (2,'price_1OhJjACEL3dCjPQVoNKbgruQ',1000,1);
INSERT INTO "stripee_product" ("id","name","stripe_product_id","file","url") VALUES (1,'Test Product','prod_PWMSDnKZJ88JKy','','http://www.petbell.com/stripe/edeywork');
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
BEGIN
UPDATE TbCard
SET used = 1
WHERE pin = 
(
SELECT pin FROM TbTransact
WHERE card_use = 5
);
INSERT INTO TbUsed
(student_id, pin)
SELECT student_id, pin 
FROM TbTransact
WHERE card_use= 5;

DELETE FROM TbTransact
WHERE card_use = 5;
END;
COMMIT;
