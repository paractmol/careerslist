require 'net/http'
require 'nokogiri'
require 'stuff-classifier'

module Stackoverflow
	class Careers
		def initialize(attrs = {})
			careers = "http://careers.stackoverflow.com"
			
			attrs.merge!({:keywords => "", :type => "", :location => ""})

			attrs = attrs.map do |k,v|
				{k => v.to_s.split(', ').join('+')}
			end.reduce({}, :merge)

			uri = URI([careers, "jobs?searchTerm=#{attrs[:keywords]}&type=#{attrs[:type]}&location=#{attrs[:location]}&range=20&distanceUnits=Miles"].join('/'))

			c = CareersList::Crawler.new(uri)
			companies = c.doc.css('.-item.-company-group')

			jobs = companies.map do |c|
				uri = URI([careers, c.css('.-item.-job h3 a').first['href']].join('/'))
				cv = CareersList::Crawler.new(uri)
				cv = cv.doc.css('.jobdetail .description, .jobdetail h2').map {|vd| vd.text.strip}

				[c.css('.-company h2'), c.css('.-company span')].map{|d| d.text.strip } + cv
			end

			@jobs = CareersList::Jobs.new(jobs)
		end

		def jobs
			@jobs
		end
	end
end


module CareersList
	class Crawler
		attr_reader :res, :doc

		def initialize(uri)
			req = Net::HTTP::Get.new(uri, {'User-Agent' => 'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'})
			@res = Net::HTTP.start(uri.hostname, uri.port) {|http|
			  http.request(req)
			}

			@doc = Nokogiri::HTML(res.body)
		end
	end

	class Jobs
		attr_reader :list, :cls

		def initialize(array)
			@list = []
			@cls = StuffClassifier::Bayes.new("Jobs recommendation")
		
			array.each do |job|
				@list << CareersList::Job.new(job, self)
			end
		end

		def inspect
			@list
		end
	end

	class Job
		attr_reader :parent, :values

		def initialize(values, parent)
			@parent = parent
			@values = values
		end

		def like
			train(:like)
		end

		def dislike
			train(:dislike)
		end

		def classify
			@parent.cls.classify(@values.join(' '))
		end

		def inspect
			@values
		end

		private

		def train(by)
			@parent.cls.train(by, @values.join(' '))
		end
	end
end