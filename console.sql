-- TODO ADD CREATED AT TO SOME TABLES

-- ALL ADMIN TABLES

CREATE TABLE roles
(
    roles_id         SERIAL PRIMARY KEY,
    roles_name       varchar(40) DEFAULT NULL UNIQUE,
    roles_active     boolean     DEFAULT '0',
    roles_sysadmin   boolean     DEFAULT '0',
    roles_created_at timestamp   DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE
    users
(
    users_id       SERIAL PRIMARY KEY,
    users_email    VARCHAR(100) unique not null,
    users_secret   varchar(255) DEFAULT NULL,
    users_active   boolean      DEFAULT true,
    users_roles_id int          DEFAULT NULL,
    users_password VARCHAR(255) DEFAULT NULL,
    users_image    varchar(512) DEFAULT NULL,
    CONSTRAINT fk_users_roles_id FOREIGN KEY (users_roles_id) REFERENCES roles (roles_id)
);

CREATE TABLE packages
(
    packages_id                      SERIAL PRIMARY KEY,
    packages_isActive                BOOLEAN   DEFAULT FALSE,
    packages_name                    varchar(200),
    packages_device_count            int       DEFAULT 0,
    packages_concurrent_device_count int       DEFAULT 0,
    packages_download_limit          int       DEFAULT 0,
    packages_expiration_duration     integer   DEFAULT 0,
    packages_trailer_enabled         boolean   default true,
    packages_created_at              timestamp default current_timestamp,
    packages_user_id                 int       default NULL,
    CONSTRAINT fk_users_packages_id FOREIGN KEY (packages_user_id) REFERENCES users (users_id)
);

CREATE TABLE packages_devices
(
    packages_devices_type_id     int NOT NULL,
    packages_devices_packages_id int NOT NULL,
    PRIMARY KEY (packages_devices_packages_id, packages_devices_type_id),
    CONSTRAINT fk_packages_devices_packages_id FOREIGN KEY (packages_devices_packages_id) REFERENCES packages (packages_id),
    CONSTRAINT fk_packages_devices_type_id FOREIGN KEY (packages_devices_type_id) REFERENCES devices_type (devices_type_id)
);

-- STORAGE_TABLES

CREATE TABLE storages
(
    storages_id          SERIAL PRIMARY KEY,
    storages_name        varchar(100) DEFAULT NULL,
    storages_isAvailable boolean      DEFAULT false,
    storages_path        text         DEFAULT NULL,
    storages_size        varchar(200) DEFAULT 0,
    storage_user_id      int          DEFAULT NULL,
    storage_created_at   timestamp    DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_storages_id FOREIGN KEY (storage_user_id) REFERENCES users (users_id)
);

-- CUSTOMERS TABLES;

CREATE TABLE customers
(
    customers_id               SERIAL PRIMARY KEY,
    customers_login            varchar(50)  DEFAULT NULL unique,
    customers_password         varchar(255) DEFAULT NULL,
    customers_created          timestamp    DEFAULT CURRENT_TIMESTAMP,
    customers_users_id         int          DEFAULT NULL,
    customers_token            varchar(100) DEFAULT NULL unique,
    customers_password_changed BOOLEAN      DEFAULT FALSE,
    customers_locked           BOOLEAN      DEFAULT FALSE,
    customers_last_seen        timestamp    DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE subscriptions
(
    subscriptions_id           SERIAL PRIMARY KEY NOT NULL,
    subscriptions_customers_id int       DEFAULT NULL,
    subscriptions_packages_id  int       DEFAULT NULL,
    subscriptions_from         timestamp DEFAULT NULL,
    subscriptions_to           timestamp DEFAULT NULL,
    subscriptions_limit        int       DEFAULT 0,
    subscriptions_count        int       DEFAULT 0,
    CONSTRAINT fk_subscriptions_customers_id FOREIGN KEY (subscriptions_customers_id) REFERENCES customers (customers_id),
    CONSTRAINT fk_subscriptions_packages_id FOREIGN KEY (subscriptions_packages_id) REFERENCES packages (packages_id)
);

CREATE TABLE categories_customers
(
    categories_customers_customers_id  int NOT NULL,
    categories_customers_categories_id int NOT NULL,
    PRIMARY KEY (categories_customers_customers_id, categories_customers_categories_id),
    CONSTRAINT fk_categories_customers_customers_id FOREIGN KEY (categories_customers_customers_id) REFERENCES customers (customers_id),
    CONSTRAINT fk_categories_customers_categories_id FOREIGN KEY (categories_customers_categories_id) REFERENCES categories (categories_id)
);

CREATE TABLE my_list
(
    my_list_id           SERIAL PRIMARY KEY,
    my_list_added        timestamp DEFAULT NULL,
    my_list_vods_id      int       DEFAULT NULL,
    my_list_customers_id int       DEFAULT NULL,
    my_list_reminder     smallint  DEFAULT NULL,
    PRIMARY KEY (my_list_id),
    UNIQUE (my_list_vods_id, my_list_customers_id),
    CONSTRAINT fk_my_list_customers_id FOREIGN KEY (my_list_customers_id) REFERENCES customers (customers_id),
    CONSTRAINT fk_my_list_vods_id FOREIGN KEY (my_list_vods_id) REFERENCES vods (vods_id)
);

CREATE TABLE customer_devices
(
    devices_id             SERIAL PRIMARY KEY,
    devices_customers_id   int          DEFAULT NULL,
    devices_type           varchar(35)  DEFAULT NULL,
    devices_identification varchar(170) DEFAULT NULL,
    devices_hash           varchar(150) DEFAULT NULL,
    devices_used           timestamp    DEFAULT NULL,
    devices_added          timestamp    DEFAULT NULL,
    devices_ip             inet         DEFAULT NULL,
    devices_google_token   varchar(180) DEFAULT NULL,
    devices_sdk            varchar(180) default NULL,
    UNIQUE (devices_customers_id, devices_hash),
    CONSTRAINT fk_devices_customers_id FOREIGN KEY (devices_customers_id) REFERENCES customers (customers_id)
);

CREATE TABLE continue_download_vods
(
    continue_download_vods_updated          timestamp DEFAULT NULL,
    continue_download_vods_vods_id          int NOT NULL,
    continue_download_vods_customers_id     int NOT NULL,
    continue_download_vods_second           int       DEFAULT NULL,
    continue_download_vods_finished         boolean   DEFAULT false,
    continue_download_vods_customer_devices int       DEFAULT null,
    PRIMARY KEY (continue_download_vods_vods_id, continue_download_vods_customers_id),
    CONSTRAINT fk_continue_download_vods_profiles_id FOREIGN KEY (continue_download_vods_customers_id) REFERENCES customers (customers_id),
    CONSTRAINT fk_continue_download_vods_vods_id FOREIGN KEY (continue_download_vods_vods_id) REFERENCES vods (vods_id),
    CONSTRAINT fk_continue_download_vods_customer_device FOREIGN KEY (continue_download_vods_customer_devices) REFERENCES customer_devices (devices_id)
);

-- VENDORS TABLES

CREATE TABLE vendors
(
    vendors_id          SERIAL PRIMARY KEY,
    vendors_name        varchar(40)        DEFAULT NULL,
    vendors_phone       varchar(45)        DEFAULT NULL,
    vendors_email       varchar(50) UNIQUE DEFAULT NULL,
    vendors_image       varchar(50)        DEFAULT NULL,
    vendors_link        varchar(255)       default null,
    vendors_description text               default null,
    vendors_social      varchar(100)       default null
);

-- CONTENT RELATED TABLES

CREATE TABLE categories
(
    categories_id           SERIAL PRIMARY KEY,
    categories_name         varchar(120) DEFAULT NULL UNIQUE,
    categories_description  text         default null,
    categories_image        varchar(240) DEFAULT NULL,
    categories_image_width  int          DEFAULT NULL,
    categories_image_height int          DEFAULT NULL,
    categories_active       boolean      DEFAULT false,
    categories_regex        varchar(256) DEFAULT NULL
);

CREATE TABLE categories_genres
(
    categories_genres_genres_id     int NOT NULL,
    categories_genres_categories_id int NOT NULL,
    PRIMARY KEY (categories_genres_categories_id, categories_genres_genres_id),
    CONSTRAINT fk_categories_genres_categories_id FOREIGN KEY (categories_genres_categories_id) REFERENCES categories (categories_id),
    CONSTRAINT fk_categories_genres_genres_id FOREIGN KEY (categories_genres_genres_id) REFERENCES genres (genres_id)
);

CREATE TABLE genres
(
    genres_id          SERIAL PRIMARY KEY,
    genres_name        varchar(120) DEFAULT NULL UNIQUE,
    genres_description varchar(250) DEFAULT NULL,
    genres_order       int          DEFAULT '0',
    genres_active      boolean      DEFAULT false,
    genres_autoCreated boolean      DEFAULT '0'
);

CREATE TABLE log
(
    log_id                SERIAL PRIMARY KEY,
    log_type              varchar(50)  DEFAULT NULL,
    log_action            varchar(50)  default null,
    log_time              timestamp    DEFAULT NULL,
    log_users_id          int          DEFAULT NULL,
    log_customers_id      int          DEFAULT NULL,
    log_int_parameter1    int          DEFAULT NULL,
    log_int_parameter2    int          DEFAULT NULL,
    log_text_parameter1   TEXT,
    log_string_parameter1 varchar(128) DEFAULT NULL,
    log_string_parameter2 varchar(128) DEFAULT NULL,
    PRIMARY KEY (log_id),
    CONSTRAINT fk_log_customers_id FOREIGN KEY (log_customers_id) REFERENCES customers (customers_id),
    CONSTRAINT fk_log_users_id FOREIGN KEY (log_users_id) REFERENCES users (users_id)
);

CREATE TABLE devices_type
(
    devices_type_id    SERIAL PRIMARY KEY,
    devices_type_name  varchar(40),
    devices_type_model varchar(40)
);

CREATE TABLE vods
(
    vods_id                   SERIAL PRIMARY KEY,
    vods_path                 text         DEFAULT NULL,
    vods_quality_options      text[]       DEFAULT NULL,
    vods_name                 varchar(200) DEFAULT NULL,
    vods_subname              varchar(100) DEFAULT NULL,
    vods_image                varchar(200) DEFAULT NULL,
    vods_image_width          int          DEFAULT NULL,
    vods_image_height         int          DEFAULT NULL,
    vods_active               boolean      DEFAULT false,
    vods_short_video_path     text         DEFAULT NULL,
    vods_description          text,
    vods_actors               text[]       DEFAULT NULL,
    vods_directors            text[]       DEFAULT NULL,
    vods_released             date         DEFAULT NULL,
    vods_status               boolean      DEFAULT NULL,
    vods_rating               int          DEFAULT '0',
    vods_next_vods_id         int          DEFAULT NULL,
    vods_duration             int          DEFAULT NULL,
    vods_series               boolean      DEFAULT false,
    vods_season               boolean      DEFAULT false,
    vods_episode              boolean      DEFAULT NULL,
    vods_imdb_id              varchar(45)  DEFAULT NULL,
    vods_imdb_rating          float        DEFAULT NULL,
    vods_origin               varchar(85)  DEFAULT NULL,
    vods_categories_id        int          DEFAULT NULL,
    vods_thumbnails           boolean      DEFAULT false,
    vod_is_package_restricted boolean      default false,
    PRIMARY KEY (vods_id),
    CONSTRAINT fk_vods_categories_id FOREIGN KEY (vods_categories_id) REFERENCES categories (categories_id),
    CONSTRAINT fk_vods_next_vods_id FOREIGN KEY (vods_next_vods_id) REFERENCES vods (vods_id)
);

CREATE TABLE vods_genres
(
    vods_genres_genres_id int NOT NULL,
    vods_genres_vods_id   int NOT NULL,
    PRIMARY KEY (vods_genres_vods_id, vods_genres_genres_id),
    CONSTRAINT fk_vods_genres_id FOREIGN KEY (vods_genres_genres_id) REFERENCES genres (genres_id),
    CONSTRAINT fk_vods_genres_vods_id FOREIGN KEY (vods_genres_vods_id) REFERENCES vods (vods_id)
);

CREATE TABLE vods_packages
(
    vods_packages_id          SERIAL PRIMARY KEY,
    vods_packages_vods_id     int DEFAULT NULL,
    vods_packages_packages_id int DEFAULT NULL,
    PRIMARY KEY (vods_packages_id),
    UNIQUE (vods_packages_vods_id, vods_packages_packages_id),
    CONSTRAINT fk_vods_packages_packages_id FOREIGN KEY (vods_packages_packages_id) REFERENCES packages (packages_id),
    CONSTRAINT fk_vods_packages_vods_id FOREIGN KEY (vods_packages_vods_id) REFERENCES vods (vods_id)
);

CREATE TABLE vods_downloads
(
    vods_downloads_vods_id      INT NOT NULL,
    vods_downloads_customers_id INT NOT NULL,
    PRIMARY KEY (vods_downloads_customers_id, vods_downloads_customers_id),
    CONSTRAINT fk_vods_downloads_vods_id FOREIGN KEY (vods_downloads_vods_id) REFERENCES vods (vods_id),
    CONSTRAINT fk_vods_downloads_customers_id FOREIGN KEY (vods_downloads_customers_id) REFERENCES customers (customers_id)
);

-- MISCELLANEOUS

CREATE TABLE apps
(
    apps_id      SERIAL PRIMARY KEY,
    apps_name    varchar(50)  DEFAULT NULL,
    apps_package varchar(100) DEFAULT NULL,
    apps_active  boolean      DEFAULT false
);

-- ADVERTISING

CREATE TABLE advert_homepage
(
    advert_homepage_id          SERIAL PRIMARY KEY,
    advert_homepage_name        varchar(50)  DEFAULT NULL,
    advert_homepage_type        varchar(30)  DEFAULT NULL,
    advert_homepage_width       int          DEFAULT NULL,
    advert_homepage_height      int          DEFAULT NULL,
    advert_homepage_order       int          DEFAULT 0,
    advert_homepage_path        varchar(150) DEFAULT NULL,
    advert_homepage_active      boolean      DEFAULT false,
    advert_homepage_action_type varchar(100) DEFAULT NULL,
    advert_homepage_action      varchar(100) DEFAULT NULL,
    advert_homepage_show_vod    boolean      DEFAULT false,
    PRIMARY KEY (advert_homepage_id)
);

CREATE TABLE campaigns
(
    campaigns_id           SERIAL PRIMARY KEY,
    campaigns_name         varchar(100) DEFAULT NULL,
    campaigns_active       boolean      DEFAULT false,
    campaigns_from         timestamp    DEFAULT NULL,
    campaigns_to           timestamp    DEFAULT NULL,
    campaigns_all_packages boolean      DEFAULT false
);

CREATE TABLE campaigns_packages
(
    campaigns_packages_campaigns_id int NOT NULL,
    campaigns_packages_packages_id  int NOT NULL,
    CONSTRAINT fk_campaigns_packages_campaigns_id FOREIGN KEY (campaigns_packages_campaigns_id) REFERENCES campaigns (campaigns_id),
    CONSTRAINT fk_campaigns_packages_packages_id FOREIGN KEY (campaigns_packages_packages_id) REFERENCES packages (packages_id)
);

CREATE TABLE short_video
(
    short_video_id       SERIAL PRIMARY KEY,
    short_video_time     INT           DEFAULT NULL,
    short_video_users_id int           DEFAULT NULL,
    short_video_path     varchar(250)  DEFAULT NULL,
    short_video_filename varchar(250)  DEFAULT NULL,
    short_video_tags     varchar(1024) DEFAULT NULL,
    CONSTRAINT fk_short_video_users_id FOREIGN KEY (short_video_users_id) REFERENCES users (users_id)
);

CREATE TABLE onboarding
(
    onboarding_id                     SERIAL PRIMARY KEY,
    onboarding_vendors_id             int          DEFAULT NULL,
    onboarding_order                  int          DEFAULT NULL,
    onboarding_image_phone_portrait   varchar(256) DEFAULT NULL,
    onboarding_image_phone_landscape  varchar(256) DEFAULT NULL,
    onboarding_image_tablet_portrait  varchar(256) DEFAULT NULL,
    onboarding_image_tablet_landscape varchar(256) DEFAULT NULL,
    onboarding_image_tv               varchar(256) DEFAULT NULL,
    onboarding_title                  varchar(256) DEFAULT NULL,
    onboarding_text                   varchar(256) DEFAULT NULL,
    PRIMARY KEY (onboarding_id),
    CONSTRAINT onboarding_vendors_id FOREIGN KEY (onboarding_vendors_id) REFERENCES vendors (vendors_id)
);
