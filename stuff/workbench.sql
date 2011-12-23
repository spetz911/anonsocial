CREATE TABLE ab_users (
  user_id INT PRIMARY KEY,
  user_name character varying(64) NOT NULL,
  user_tripcode character (10) NOT NULL,
  user_regdate timestamp NOT NULL default now(),
  user_email character varying(128) NOT NULL,
  user_password character (32) NOT NULL,
  user_deleted bit(1) NOT NULL default '0'
);

CREATE TABLE ab_wall (
  wallmsg_id INT PRIMARY KEY,
  to_id integer NOT NULL,
  from_id integer NOT NULL,
  FOREIGN KEY (from_id) REFERENCES ab_users,
  message text NOT NULL,
  message_time timestamp NOT NULL default now(),
  show_name bit(1) NOT NULL default '0',
  show_tripcode bit(1) NOT NULL default '0'
);

CREATE TABLE ab_privmsgs (
  privmsg_id INT PRIMARY KEY,
  to_id integer NOT NULL,
  FOREIGN KEY (to_id) REFERENCES ab_users,
  from_id integer NOT NULL,
  FOREIGN KEY (from_id) REFERENCES ab_users,
  message text NOT NULL,
  message_time timestamp NOT NULL default now(),
  show_name bit(1) NOT NULL default '0',
  show_tripcode bit(1) NOT NULL default '0'
);

CREATE TABLE ab_boards (
  board_id INT PRIMARY KEY,
  board_dir character varying (8) NOT NULL,
  board_name character varying(35) NOT NULL
);

CREATE TABLE ab_board_staff (
--  /* There is NOT primary key, just another way to link it with user's page */
  staff_id INT NOT NULL UNIQUE,
  board_id INT NOT NULL,
  FOREIGN KEY (board_id) REFERENCES ab_boards,
  user_id integer NOT NULL,
  FOREIGN KEY (user_id) REFERENCES ab_users,
--  /* And there is real primary key */
  PRIMARY KEY (board_id, user_id),
  staff_role ENUM ('owner', 'admin', 'mod') NOT NULL
);

CREATE TABLE ab_posts (
  post_id INT PRIMARY KEY,
  board_id integer NOT NULL,
  FOREIGN KEY (board_id) REFERENCES ab_boards,
  user_id integer NOT NULL,
  FOREIGN KEY (user_id) REFERENCES ab_users,
  parent_id integer NOT NULL default 0,
  subject character varying(255),
  message text NOT NULL,
  message_time timestamp NOT NULL default now(),
  show_name bit(1) NOT NULL default '0',
  show_tripcode bit(1) NOT NULL default '0'
);

CREATE INDEX ab_posts_display_idx ON ab_posts (board_id, parent_id);

