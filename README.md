Library that parses first page of result of careers.stackoverflow.com and let you classify whether
job fits for you or not.

```
require './careerslist'

s = Stackoverflow::Careers.new({keywords: "Ruby"})

2.1.2 :009 > s.jobs.list[1]
 => ["Plexisoft Inc.", "Boston, MAWork Remotely", "Job Description\r\n                    \r\n                Plexisoft Inc., a new player in the Business Management Software market, is extending the development team again!\r\nOur globally distributed team consists of 4 highly qualified developers and a variable number of temporary candidates for a development role. Our main goal includes moving to a horizontal team management model where each developer has enough skills, experience, and personal interests to work in an architect-level role. The project is currently scheduled to be in production phase within 3 months.\r\nThat's why we expect to receive CVs from candidates who have some the following skills:\r\nExperience in development of LAMP(PHP/Yii)-based complex business applications.\r\nExperience in automated QA of complex web-based software.\r\nExperience in load/stress testing and fine-tuning complex PHP-based software for large traffic.\r\nExperience in web security.\r\nExperience in integrating custom software with APIs of all currently popular 3rd party products in such fields as ecommerce, accounting, marketing etc.", "Our system currently consists of CRM, E-commerce, HelpDesk, and Analytics Modules, using the following tools and technologies:  PHP 5.3, Yii 1.1.7, MySQL, MongoDB, ORM (ActiveRecord and YiiMongoDbSuite), jQuery, jQueryUI, ExtJs charts module, WHMCS with our customizations, SVN, Ajax, HTML, CSS, Bootstrap, Apache, CentOS.", "Please, send your CV to hr@plexisoft.com\r\nWe respond to all candidates. If you have not received a response during 1-3 days, you may also try to contact us through internal messaging system on this job board.\r\nNote: No outsourcing companies please, we are only looking for direct hire individuals.", "Job Description", "Skills & Requirements", "About Plexisoft Inc."]
 2.1.2 :010 > s.jobs.list[1].like
  => 1
 2.1.2 :011 > s.jobs.list[2].like
  => 2
 2.1.2 :012 > s.jobs.list[3].like
  => 3
 2.1.2 :013 > s.jobs.list[8].classify
  => :like
 2.1.2 :014 > s.jobs.list[8].dislike
  => 1
 2.1.2 :015 > s.jobs.list[11].dislike
  => 2
 2.1.2 :016 > s.jobs.list[12].dislike
  => 3
 2.1.2 :017 > s.jobs.list.map {|j| j.classify }
  => [:dislike, :like, :like, :like, :dislike, :dislike, :dislike, :dislike, :dislike, :dislike, :like, :dislike, :dislike, :dislike, :dislike, :dislike, :dislike, :dislike, :dislike, :dislike]

```