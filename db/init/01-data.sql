\connect forum_example;

INSERT INTO public.user (username) VALUES
('Benjie'),
('Singingwolfboy'),
('Lexius');

/*Create some dummy posts*/
INSERT INTO public.post (title, body, author_id) VALUES
('First post example', 'Lorem ipsum dolor sit amet', (SELECT id from "user" limit 1 OFFSET 0)),
('Second post example', 'Consectetur adipiscing elit', (SELECT id from "user" limit 1 OFFSET 1)),
('Third post example', 'Aenean blandit felis sodales', (SELECT id from "user" limit 1 OFFSET 2));
