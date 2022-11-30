CREATE TABLE foobars (
  id SERIAL PRIMARY KEY,
  baz VARCHAR(255),
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL
);

INSERT INTO foobars (baz, created_at, updated_at) VALUES ("aaa", NOW(), NOW());
INSERT INTO foobars (baz, created_at, updated_at) VALUES ("bbb", NOW(), NOW());
INSERT INTO foobars (baz, created_at, updated_at) VALUES ("ccc", NOW(), NOW());
