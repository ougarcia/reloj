DROP TABLE IF EXISTS todos;
CREATE TABLE todos (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL
);

INSERT INTO
  todos (title)
VALUES
  ('Laundry'),
  ('Buy Groceries'),
  ('Water Plants'),
  ('Run Dishwasher'),
  ('Walk the Dog'),
  ('Clean Room');
