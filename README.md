#### Don't know if this job right for you? Ask Mr.CareersList

Joke application that parses first page of result of careers.stackoverflow.com and let you classify whether
job fits for you or not.

```
require './careerslist'

s = Stackoverflow::Careers.new({keywords: "Ruby, Rails, JavaScript"})
```
```
2.1.2 :003 > s.jobs.list[0].values
=> ["University of California, Berkeley", "Santa Monica, CA", "Ruby on Rails Programmer (0652U)University of California, BerkeleyAre you ready for the challenge of becoming someone who makes a difference in children’s lives? At the University of California, Berkeley Graduate School of Education, we welcome visionaries and dreamers - individuals who don’t wait for change, but make it happen! At the Berkeley Evaluation and Assessment Research (BEAR) Center, you will be part of a team that contributes to improving the education of students across California and globally. We are looking for a skilled Ruby on Rails programmer who wants to make a real and positive difference in the lives of educators and students.  At the BEAR Center, we respect work-life balance and offer a flexible schedule. In addition to a career filled with purpose and opportunity, UC Berkeley offers a comprehensive benefits package including generous vacation time, many healthcare options and pension.  For a full description of the Ruby on Rails Developer responsibilities, check out: http://apptrkr.com/553538 and enter job ID #18997.EOEjeid-50248c6b53d7eb49ac3bfcfe83535c95"]
2.1.2 :004 > s.jobs.list[0].fit
=> 1
2.1.2 :005 > s.jobs.list[1].fit
=> 2
2.1.2 :006 > s.jobs.list[3].unfit
=> 1
2.1.2 :007 > s.jobs.list[4].unfit
=> 2
2.1.2 :009 > s.jobs.list[5].fit
=> 3
2.1.2 :010 > s.jobs.list.each_with_index.map {|j, i| [i, j.classify] }
=> [[0, :fit], [1, :fit], [2, :unfit], [3, :unfit], [4, :unfit], [5, :fit], [6, :unfit], [7, :fit], [8, :unfit], [9, :unfit], [10, :fit], [11, :unfit], [12, :unfit], [13, :unfit], [14, :unfit], [15, :fit], [16, :unfit], [17, :unfit], [18, :unfit], [19, :unfit], [20, :unfit]]
2.1.2 :011 > s.jobs.list[15]
=> http://careers.stackoverflow.com/jobs/75905/ruby-full-stack-developer-for-funded-startup-skillable?a=pshz8MGnx8A&searchTerm=Ruby+JavaScript+Rails
2.1.2 :012 > s.jobs.list[15].classify
=> :fit
```