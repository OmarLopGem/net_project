-- ============================================================
--  Tournament DB — SQL Server
--  Tables: users, matches, tickets, jerseys, orders, order_items
-- ============================================================

-- ------------------------------------------------------------
--  Drop (safe, reverse dependency order)
-- ------------------------------------------------------------
IF OBJECT_ID('order_items', 'U') IS NOT NULL DROP TABLE order_items;
IF OBJECT_ID('orders',      'U') IS NOT NULL DROP TABLE orders;
IF OBJECT_ID('tickets',     'U') IS NOT NULL DROP TABLE tickets;
IF OBJECT_ID('jerseys',     'U') IS NOT NULL DROP TABLE jerseys;
IF OBJECT_ID('matches',     'U') IS NOT NULL DROP TABLE matches;
IF OBJECT_ID('users',       'U') IS NOT NULL DROP TABLE users;

-- ------------------------------------------------------------
--  users
-- ------------------------------------------------------------
CREATE TABLE users (
    id            INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    full_name     VARCHAR(120)  NOT NULL,
    email         VARCHAR(200)  NOT NULL UNIQUE,
    password_hash VARCHAR(255)  NOT NULL,
    created_at    DATETIME2     NOT NULL DEFAULT GETUTCDATE()
);

-- ------------------------------------------------------------
--  matches
-- ------------------------------------------------------------
CREATE TABLE matches (
    id         INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    home_team  VARCHAR(100)  NOT NULL,
    away_team  VARCHAR(100)  NOT NULL,
    venue      VARCHAR(150)  NOT NULL,
    match_date DATETIME2     NOT NULL,
    created_at DATETIME2     NOT NULL DEFAULT GETUTCDATE()
);

-- ------------------------------------------------------------
--  tickets  (catalogue — one row per category per match)
-- ------------------------------------------------------------
CREATE TABLE tickets (
    id         INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    match_id   INT           NOT NULL REFERENCES matches(id),
    category   VARCHAR(60)   NOT NULL,   -- e.g. 'General', 'VIP', 'Platea'
    price      DECIMAL(10,2) NOT NULL,
    stock      INT           NOT NULL CHECK (stock >= 0),
    created_at DATETIME2     NOT NULL DEFAULT GETUTCDATE()
);

-- ------------------------------------------------------------
--  jerseys  (fixed inventory)
-- ------------------------------------------------------------
CREATE TABLE jerseys (
    id         INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    team_name  VARCHAR(100)  NOT NULL,
    size       VARCHAR(10)   NOT NULL,   -- XS / S / M / L / XL / XXL
    price      DECIMAL(10,2) NOT NULL,
    stock      INT           NOT NULL CHECK (stock >= 0),
    created_at DATETIME2     NOT NULL DEFAULT GETUTCDATE()
);

-- ------------------------------------------------------------
--  orders
-- ------------------------------------------------------------
CREATE TABLE orders (
    id         INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    user_id    INT           NOT NULL REFERENCES users(id),
    status     VARCHAR(20)   NOT NULL DEFAULT 'pending'
                             CHECK (status IN ('pending', 'confirmed', 'cancelled')),
    total      DECIMAL(10,2) NOT NULL DEFAULT 0,
    created_at DATETIME2     NOT NULL DEFAULT GETUTCDATE(),
    updated_at DATETIME2     NOT NULL DEFAULT GETUTCDATE()
);

-- ------------------------------------------------------------
--  order_items  (polymorphic: ticket OR jersey, never both)
-- ------------------------------------------------------------
CREATE TABLE order_items (
    id         INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    order_id   INT           NOT NULL REFERENCES orders(id),
    ticket_id  INT           NULL     REFERENCES tickets(id),
    jersey_id  INT           NULL     REFERENCES jerseys(id),
    quantity   INT           NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
    redeemed   BIT           NOT NULL DEFAULT 0,
    redeemed_at DATETIME2    NULL,

    -- Exactly one FK must be set
    CONSTRAINT chk_item_type CHECK (
        (ticket_id IS NOT NULL AND jersey_id IS NULL)
     OR (ticket_id IS NULL     AND jersey_id IS NOT NULL)
    ),
    -- redeemed_at only valid when redeemed = 1
    CONSTRAINT chk_redeemed_at CHECK (
        redeemed = 0 AND redeemed_at IS NULL
     OR redeemed = 1 AND redeemed_at IS NOT NULL
    ),
    -- redeemed only makes sense for tickets
    CONSTRAINT chk_redeemed_tickets_only CHECK (
        redeemed = 0
     OR (redeemed = 1 AND ticket_id IS NOT NULL)
    )
);

-- ============================================================
--  Seed data
-- ============================================================

-- users
INSERT INTO users (full_name, email, password_hash) VALUES
    ('Alice Johnson',  'alice@example.com',  'hashed_pw_alice'),
    ('Bob Martinez',   'bob@example.com',    'hashed_pw_bob'),
    ('Carol Smith',    'carol@example.com',  'hashed_pw_carol'),
    ('David Lee',      'david@example.com',  'hashed_pw_david'),
    ('Eva Torres',     'eva@example.com',    'hashed_pw_eva');

-- matches
INSERT INTO matches (home_team, away_team, venue, match_date) VALUES
    ('Argentina',  'Germany',  'Estadio Monumental',   '2025-06-10 18:00:00'),
    ('Brazil',     'France',   'Maracana Stadium',     '2025-06-14 20:00:00'),
    ('Germany',    'Brazil',   'Olympiastadion',       '2025-06-18 19:00:00'),
    ('France',     'Argentina','Stade de France',      '2025-06-22 17:30:00'),
    ('Brazil',     'Argentina','Maracana Stadium',     '2025-06-28 20:00:00');

-- tickets  (General + VIP per match)
INSERT INTO tickets (match_id, category, price, stock) VALUES
    (1, 'General',  25.00, 500),
    (1, 'VIP',      80.00, 100),
    (2, 'General',  25.00, 500),
    (2, 'VIP',      80.00, 100),
    (2, 'Platea',   45.00, 200),
    (3, 'General',  25.00, 500),
    (3, 'VIP',      80.00, 100),
    (4, 'General',  25.00, 400),
    (4, 'VIP',      80.00,  80),
    (5, 'General',  25.00, 500),
    (5, 'VIP',      80.00, 100),
    (5, 'Platea',   45.00, 150);

-- jerseys  (4 national teams × 3 sizes)
INSERT INTO jerseys (team_name, size, price, stock) VALUES
    ('Argentina', 'S',  65.00, 30),
    ('Argentina', 'M',  65.00, 50),
    ('Argentina', 'L',  65.00, 40),
    ('Argentina', 'XL', 65.00, 20),
    ('Brazil',    'S',  65.00, 25),
    ('Brazil',    'M',  65.00, 45),
    ('Brazil',    'L',  65.00, 35),
    ('Brazil',    'XL', 65.00, 15),
    ('Germany',   'S',  65.00, 20),
    ('Germany',   'M',  65.00, 40),
    ('Germany',   'L',  65.00, 30),
    ('Germany',   'XL', 65.00, 10),
    ('France',    'S',  65.00, 20),
    ('France',    'M',  65.00, 35),
    ('France',    'L',  65.00, 25),
    ('France',    'XL', 65.00, 10);

-- orders
INSERT INTO orders (user_id, status, total) VALUES
    (1, 'confirmed',  210.00),   -- order 1: Alice  (2×25 + 1×80 + 2×25 already redeemed)
    (2, 'confirmed',   80.00),   -- order 2: Bob
    (3, 'pending',     90.00),   -- order 3: Carol  (25 + 65)
    (4, 'cancelled',   25.00),   -- order 4: David
    (5, 'confirmed',  225.00),   -- order 5: Eva    (2×80 + 65)
    (1, 'confirmed',  130.00),   -- order 6: Alice  (2×65)
    (2, 'pending',     65.00);   -- order 7: Bob

-- order_items
-- Order 1 (Alice, confirmed): 2× General ticket (match 1) + 1× VIP ticket (match 3)
INSERT INTO order_items (order_id, ticket_id, jersey_id, quantity, unit_price, redeemed, redeemed_at) VALUES
    (1, 1,  NULL, 2, 25.00, 1, '2025-06-10 18:45:00'),   -- 2 General tickets match 1, redeemed
    (1, 7,  NULL, 1, 80.00, 0, NULL),                     -- 1 VIP ticket match 3, not yet
-- Order 2 (Bob, confirmed): 1× VIP ticket (match 2)
    (2, 4,  NULL, 1, 80.00, 0, NULL),
-- Order 3 (Carol, pending): 1× General (match 2) + 1× jersey Argentina M
    (3, 3,  NULL, 1, 25.00, 0, NULL),
    (3, NULL, 2,  1, 65.00, 0, NULL),                     -- Argentina M
-- Order 4 (David, cancelled): 1× General (match 1) — cancelled
    (4, 1,  NULL, 1, 25.00, 0, NULL),
-- Order 5 (Eva, confirmed): 2× VIP (match 1) + 1× jersey Germany L
    (5, 2,  NULL, 2, 80.00, 0, NULL),
    (5, NULL, 11, 1, 65.00, 0, NULL),                     -- Germany L
-- Order 6 (Alice, confirmed): 2× jersey Brazil M
    (6, NULL, 6,  2, 65.00, 0, NULL),                     -- Brazil M
-- Order 7 (Bob, pending): 1× jersey France XL
    (7, NULL, 16, 1, 65.00, 0, NULL);                     -- France XL