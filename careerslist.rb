require 'net/http'
require 'nokogiri'
require 'stuff-classifier'

module Stackoverflow
	class Careers
		def initialize(attributes = {})
			careers = "http://careers.stackoverflow.com"
			
			attrs = {}
			attrs.merge!({:keywords => "", :location => "", :range => 20, :units => "Miles"})
			attrs.merge! attributes

			attrs = attrs.map do |k,v| 
				{k => v.to_s.split(', ').join('+')}
			end.reduce({}, :merge)

			type = {type: "any"}
			type.merge!({'allowsremote' => true}) if attrs[:remote] === 'true'
			type.merge!({'offersrelocation' => true}) if attrs[:relocation] === 'true'
			type = type.to_a.map{|kv| kv.join("=")}.join("&")

			puts attrs
			puts type

			uri = URI([careers, "jobs?searchTerm=#{attrs[:keywords]}&#{type}&location=#{attrs[:location]}&range=#{attrs[:range]}&distanceUnits=#{attrs[:units]}"].join('/'))

			puts uri.inspect

			c = CareersList::Crawler.new(uri)
			companies = c.doc.css('.-item.-company-group')

			jobs = companies.map do |c|
				uri = URI([careers, c.css('.-item.-job h3 a').first['href']].join(''))
				cv = CareersList::Crawler.new(uri)
				cv = cv.doc.css('.jobdetail .description, .jobdetail h2').map {|vd| 
					vd.text.gsub(/\r\n/, '').strip
				}.join(' ')
				
				puts c.css('.-company span').inspect				

				[c.css('.-company h2')].map{|d| d.text.strip } + c.css('.-company span').map{|c| c.text } + [cv] + [uri]
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
			# When you has other than human's user-agent in 
			# headers careers.stackoverflow.com page doesn't 
			# let you to find needed dom elements
			
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
		attr_reader :parent, :values, :link

		def initialize(values, parent)
			@parent = parent
			@link = values.delete(values.last)

			@values = values
		end

		def fit
			train(:fit)
		end

		def unfit
			train(:unfit)
		end

		def classify
			@parent.cls.classify(@values.join(' '))
		end

		def inspect
			@link
		end

		private

		def train(by)
			@parent.cls.train(by, @values.join(' '))
		end
	end
end