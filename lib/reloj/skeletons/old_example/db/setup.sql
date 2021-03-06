DROP TABLE IF EXISTS cats;
CREATE TABLE cats (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER

  -- FOREIGN KEY(owner_id) REFERENCES humans(id)
);

DROP TABLE IF EXISTS humans;
CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER

  -- FOREIGN KEY(house_id) REFERENCES houses(id)
);

DROP TABLE IF EXISTS houses;
CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (id, address)
VALUES
  (1, '26th and Guerrero'), (2, 'Dolores and Market');

INSERT INTO
  humans (id, fname, lname, house_id)
VALUES
  (1, 'Devon', 'Watts', 1),
  (2, 'Matt', 'Rubens', 1),
  (3, 'Ned', 'Ruggeri', 2),
  (4, 'Catless', 'Human', NULL);

INSERT INTO
  cats (name, owner_id)
VALUES
  ('Breakfast', 1),
  ('Earl', 2),
  ('Haskell', 3),
  ('Markov', 3),
  ('Stray Cat', NULL);
