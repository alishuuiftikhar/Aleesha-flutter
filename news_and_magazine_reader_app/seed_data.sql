-- SEED DATA FOR NOVA NEWS
-- Run this in Supabase SQL Editor to populate all categories with 7 articles each.

-- 1. Ensure Authors exist
INSERT INTO authors (name, bio, avatar_url) VALUES
('Elena Richardson', 'Global Affairs Analyst with 15 years experience at The Hague.', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330'),
('Marcus Thorne', 'Tech visionary and former software architect at Silicon Valley giants.', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e'),
('Sarah Jenkins', 'Science communicator focusing on astrophysics and climate change.', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80'),
('David Chen', 'Financial strategist and host of the "Market Pulse" podcast.', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e'),
('Julian Rossi', 'Sports journalist specializing in European football and Olympic sports.', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d')
ON CONFLICT DO NOTHING;

-- 2. Populate Articles for each category
DO $$
DECLARE
    world_id UUID; tech_id UUID; science_id UUID; biz_id UUID; sports_id UUID;
    ent_id UUID; life_id UUID; edu_id UUID; travel_id UUID;
    elena UUID; marcus UUID; sarah UUID; david UUID; julian UUID;
BEGIN
    -- Get category IDs
    SELECT id INTO world_id FROM categories WHERE name = 'World';
    SELECT id INTO tech_id FROM categories WHERE name = 'Technology';
    SELECT id INTO science_id FROM categories WHERE name = 'Science';
    SELECT id INTO biz_id FROM categories WHERE name = 'Business';
    SELECT id INTO sports_id FROM categories WHERE name = 'Sports';
    SELECT id INTO ent_id FROM categories WHERE name = 'Entertainment';
    SELECT id INTO life_id FROM categories WHERE name = 'Lifestyle';
    SELECT id INTO edu_id FROM categories WHERE name = 'Education';
    SELECT id INTO travel_id FROM categories WHERE name = 'Travel';

    -- Get author IDs
    SELECT id INTO elena FROM authors WHERE name = 'Elena Richardson';
    SELECT id INTO marcus FROM authors WHERE name = 'Marcus Thorne';
    SELECT id INTO sarah FROM authors WHERE name = 'Sarah Jenkins';
    SELECT id INTO david FROM authors WHERE name = 'David Chen';
    SELECT id INTO julian FROM authors WHERE name = 'Julian Rossi';

    -- WORLD NEWS (7)
    INSERT INTO articles (title, content, image_url, author_id, category_id, reading_time) VALUES
    ('The Changing Geopolitics of the Arctic', 'As ice melts, new trade routes and territorial disputes are emerging...', 'https://images.unsplash.com/photo-1451187580459-43490279c0fa', elena, world_id, 8),
    ('Global Summit Reaches Historic Climate Accord', 'Leaders from 190 nations have finally agreed on a binding treaty...', 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b', elena, world_id, 6),
    ('Democracy in the Digital Age', 'How social media algorithms are reshaping political landscapes globally...', 'https://images.unsplash.com/photo-1529107386315-e1a2ed48a620', elena, world_id, 12),
    ('The Rise of Megacities in Southeast Asia', 'Urban planning challenges in rapidly expanding metropolitan areas...', 'https://images.unsplash.com/photo-1449156006008-819797247355', elena, world_id, 9),
    ('Renewable Energy Adoption Across Africa', 'Solar and wind projects are transforming rural electrification...', 'https://images.unsplash.com/photo-1509391366360-fe5bb60c855a', elena, world_id, 7),
    ('Preserving Cultural Heritage in Conflict Zones', 'Archaeologists are using 3D scanning to protect ancient sites...', 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23', elena, world_id, 10),
    ('The Future of Global Trade Alliances', 'New economic blocs are challenging traditional trade paradigms...', 'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e', elena, world_id, 8);

    -- TECHNOLOGY (7)
    INSERT INTO articles (title, content, image_url, author_id, category_id, reading_time) VALUES
    ('AI Ethics: The Next Frontier', 'As AI models grow more powerful, the need for governance increases...', 'https://images.unsplash.com/photo-1677442136019-21780ecad995', marcus, tech_id, 10),
    ('Quantum Computing Simplified', 'Understanding the technology that will revolutionize cryptography...', 'https://images.unsplash.com/photo-1635070041078-e363dbe005cb', marcus, tech_id, 15),
    ('The Metaverse: Hype vs Reality', 'Is the digital world really the future of social interaction?', 'https://images.unsplash.com/photo-1622979135225-d2ba269cf1ac', marcus, tech_id, 8),
    ('Edge Computing and the IoT Revolution', 'Why processing data closer to the source is the next big shift...', 'https://images.unsplash.com/photo-1518770660439-4636190af475', marcus, tech_id, 7),
    ('Cybersecurity in the Age of Ransomware', 'How organizations are defending against sophisticated attacks...', 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b', marcus, tech_id, 11),
    ('The Future of Semiconductors', 'New materials that could keep Moore Law alive for decades...', 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23', marcus, tech_id, 9),
    ('Sustainable Tech: Green Coding', 'Reducing the carbon footprint of our digital infrastructure...', 'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e', marcus, tech_id, 6);

    -- SPORTS (7)
    INSERT INTO articles (title, content, image_url, author_id, category_id, reading_time) VALUES
    ('The Evolution of Modern Tactics', 'How high-pressing changed the face of professional football...', 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2', julian, sports_id, 12),
    ('Olympic Underdogs: Stories of Resilience', 'Athletes who overcame immense odds to reach the podium...', 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211', julian, sports_id, 9),
    ('Data Analytics in Professional Basketball', 'How teams are using spatial data to optimize shot selection...', 'https://images.unsplash.com/photo-1546519638-68e109498ffc', julian, sports_id, 8),
    ('The Rise of Women’s Professional Sports', 'Increased investment and viewership are creating a new era...', 'https://images.unsplash.com/photo-1541534741688-6078c64b5ca5', julian, sports_id, 7),
    ('Extreme Sports and the Psychology of Risk', 'What drives athletes to push the boundaries of human limits...', 'https://images.unsplash.com/photo-1522163182402-834f881ad852', julian, sports_id, 10),
    ('The Global Impact of E-Sports', 'From niche hobby to stadiums: the professional gaming boom...', 'https://images.unsplash.com/photo-1542751371-adc38448a05e', julian, sports_id, 6),
    ('Tennis: The Changing of the Guard', 'New young stars are challenging the dominance of the legends...', 'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0', julian, sports_id, 8);

    -- TRAVEL (7)
    INSERT INTO articles (title, content, image_url, author_id, category_id, reading_time) VALUES
    ('Hidden Gems of the Mediterranean', 'Escape the crowds in these lesser-known coastal villages...', 'https://images.unsplash.com/photo-1533105079780-92b9be482077', elena, travel_id, 7),
    ('Sustainable Travel: A Guide for 2024', 'How to explore the world while minimizing your footprint...', 'https://images.unsplash.com/photo-1501785888041-af3ef285b470', elena, travel_id, 9),
    ('Tokyo: A Fusion of Tradition and Future', 'Navigating the vibrant streets of the Japanese capital...', 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf', elena, travel_id, 10),
    ('The Art of Slow Travel', 'Why spending more time in fewer places leads to better journeys...', 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1', elena, travel_id, 8),
    ('Exploring the Icelandic Highlands', 'A guide to the rugged beauty of Icelands volcanic interior...', 'https://images.unsplash.com/photo-1476610182048-b716b8518aae', elena, travel_id, 12),
    ('Gastronomy Tours through Northern Italy', 'A culinary journey through the heart of Piedmont and Lombardy...', 'https://images.unsplash.com/photo-1514933651103-005eec06c04b', elena, travel_id, 6),
    ('Digital Nomad Life in Bali', 'What you need to know about working remotely from paradise...', 'https://images.unsplash.com/photo-1537996194471-e657df975ab4', elena, travel_id, 7);

    -- BUSINESS (7)
    INSERT INTO articles (title, content, image_url, author_id, category_id, reading_time) VALUES
    ('The New Era of Corporate Sustainability', 'Why ESG metrics are becoming central to investment decisions...', 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab', david, biz_id, 9),
    ('Venture Capital Trends in 2024', 'Where the smart money is heading in the next tech cycle...', 'https://images.unsplash.com/photo-1553729459-efe14ef6055d', david, biz_id, 11),
    ('The Reshaping of Global Supply Chains', 'How near-shoring is changing the logistics of manufacturing...', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d', david, biz_id, 8),
    ('Remote Work and the Future of Real Estate', 'The impact of flexible work on commercial office space...', 'https://images.unsplash.com/photo-1497366216548-37526070297c', david, biz_id, 7),
    ('Inflation and Its Impact on Small Businesses', 'Strategies for maintaining margins in a rising cost environment...', 'https://images.unsplash.com/photo-1554224155-6726b3ff858f', david, biz_id, 10),
    ('The Gig Economy: Rights and Regulations', 'The evolving legal landscape for independent contractors...', 'https://images.unsplash.com/photo-1454165833767-02a6ed8a58e8', david, biz_id, 6),
    ('Startup Culture in Emerging Markets', 'The vibrant entrepreneurial scenes in Lagos and Mumbai...', 'https://images.unsplash.com/photo-1519389950473-47ba0277781c', david, biz_id, 8);

    -- SCIENCE (7)
    INSERT INTO articles (title, content, image_url, author_id, category_id, reading_time) VALUES
    ('Mars Colonization: Challenges and Hope', 'What it will take to establish a permanent human presence...', 'https://images.unsplash.com/photo-1614728894747-a83421e2b9c9', sarah, science_id, 14),
    ('Gene Editing and the Future of Medicine', 'How CRISPR technology is curing previously untreatable diseases...', 'https://images.unsplash.com/photo-1532187863486-abf9d39d99c5', sarah, science_id, 10),
    ('The Mystery of Dark Matter', 'New experiments that could finally unveil the universes secret...', 'https://images.unsplash.com/photo-1462331940025-496dfbfc7564', sarah, science_id, 12),
    ('Climate Resilience: Building for the Future', 'Innovative engineering to protect cities from rising sea levels...', 'https://images.unsplash.com/photo-1500382017468-9049fee74a62', sarah, science_id, 9),
    ('The Human Brain Map', 'The quest to map every connection in the human connectome...', 'https://images.unsplash.com/photo-1559757175-5700dde675bc', sarah, science_id, 11),
    ('Biodiversity Loss and Ecosystem Stability', 'Why protecting small species matters for the whole planet...', 'https://images.unsplash.com/photo-1500829243541-74b677fecc30', sarah, science_id, 8),
    ('Nuclear Fusion: The Clean Energy Holy Grail', 'Recent breakthroughs that bring us closer to limitless power...', 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23', sarah, science_id, 13);

    -- LIFESTYLE (7)
    INSERT INTO articles (title, content, image_url, author_id, category_id, reading_time) VALUES
    ('Mindfulness in a Busy World', 'Simple techniques to find calm in the chaos of modern life...', 'https://images.unsplash.com/photo-1506126613408-eca07ce68773', sarah, life_id, 6),
    ('The Rise of Minimalist Living', 'How decluttering your space can declutter your mind...', 'https://images.unsplash.com/photo-1494438639946-1ebd1d20bf85', sarah, life_id, 8),
    ('Plant-Based Eating for Beginners', 'A guide to transitioning to a more sustainable diet...', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd', sarah, life_id, 7),
    ('The Importance of Quality Sleep', 'Why your nightly rest is the foundation of your health...', 'https://images.unsplash.com/photo-1511295742364-9031f0da78c2', sarah, life_id, 5),
    ('Work-Life Balance in the Digital Age', 'Setting boundaries when your office is in your pocket...', 'https://images.unsplash.com/photo-1506784919140-c338424e91c5', sarah, life_id, 9),
    ('The Revival of Analog Hobbies', 'Why vinyl, film, and board games are making a huge comeback...', 'https://images.unsplash.com/photo-1519671482749-fd09be7ccebf', sarah, life_id, 7),
    ('Interior Design for Small Spaces', 'Smart tips to make your apartment feel twice the size...', 'https://images.unsplash.com/photo-1524758631624-e2822e304c36', sarah, life_id, 6);

    -- ENTERTAINMENT (7)
    INSERT INTO articles (title, content, image_url, author_id, category_id, reading_time) VALUES
    ('The Golden Age of Television', 'How streaming services redefined long-form storytelling...', 'https://images.unsplash.com/photo-1522869635100-9f4c5e86aa37', julian, ent_id, 9),
    ('Independent Cinema: A New Wave', 'Small films that are making a big impact at international festivals...', 'https://images.unsplash.com/photo-1485846234645-a62644f84728', julian, ent_id, 8),
    ('The Evolution of Music Festivals', 'From Woodstock to the digital stage: how we celebrate music...', 'https://images.unsplash.com/photo-1459749411177-042180ce673c', julian, ent_id, 10),
    ('Virtual Reality in Gaming and Film', 'The immersive future of the entertainment industry...', 'https://images.unsplash.com/photo-1622979135225-d2ba269cf1ac', julian, ent_id, 7),
    ('Contemporary Art: A Global Perspective', 'The artists who are challenging modern social paradigms...', 'https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b', julian, ent_id, 11),
    ('The Return of Live Theater', 'Broadway and beyond: the magic of the stage is back...', 'https://images.unsplash.com/photo-1503095396549-8077592f2b23', julian, ent_id, 6),
    ('Literature in the Age of Social Media', 'How BookTok and online communities are reviving reading...', 'https://images.unsplash.com/photo-1495446815901-a7297e633e8d', julian, ent_id, 8);

    -- EDUCATION (7)
    INSERT INTO articles (title, content, image_url, author_id, category_id, reading_time) VALUES
    ('Adaptive Learning: Personalized Education', 'How AI is helping students learn at their own pace...', 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b', marcus, edu_id, 10),
    ('The Future of Higher Education', 'Is a traditional degree still the best path to success?', 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1', marcus, edu_id, 12),
    ('Lifelong Learning: Skill-Up for the Future', 'Why continuous education is essential in a changing economy...', 'https://images.unsplash.com/photo-1454165833767-02a6ed8a58e8', marcus, edu_id, 8),
    ('STEM Education for the Next Generation', 'Preparing young minds for a tech-driven world...', 'https://images.unsplash.com/photo-1509062522246-3755977927d7', marcus, edu_id, 9),
    ('The Power of Early Childhood Education', 'How pre-school programs set the stage for long-term success...', 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b', marcus, edu_id, 7),
    ('Global Access to Quality Education', 'Breaking down barriers to learning in underserved communities...', 'https://images.unsplash.com/photo-1524178232363-1fb2b075b655', marcus, edu_id, 11),
    ('Critical Thinking in a World of Misinformation', 'Teaching students how to verify facts and analyze sources...', 'https://images.unsplash.com/photo-1491841573634-28140fc7ced7', marcus, edu_id, 8);

END $$;

-- 3. Add some magazines
INSERT INTO magazines (title, description, cover_url, issue_date) VALUES
('Nova Global - Winter 2024', 'A deep dive into the global economy and future trends.', 'https://images.unsplash.com/photo-1544947950-fa07a98d237f', '2024-01-01'),
('Tech Horizons - March Issue', 'Exploring the frontiers of AI and quantum computing.', 'https://images.unsplash.com/photo-1531297484001-80022131f5a1', '2024-03-01'),
('The Science Quarterly', 'From deep space to deep oceans: the wonders of discovery.', 'https://images.unsplash.com/photo-1507413245164-6160d8298b31', '2024-02-01'),
('Modern Living', 'Sustainable architecture and minimalist design for the 21st century.', 'https://images.unsplash.com/photo-1524758631624-e2822e304c36', '2024-04-01'),
('Sport & Strategy', 'In-depth analysis of the worlds greatest athletes and teams.', 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2', '2024-05-01')
ON CONFLICT DO NOTHING;
