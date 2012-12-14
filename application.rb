require "rubygems"
require "sinatra"
# require 'open-uri'
# require 'nokogiri'
require 'crack'
require 'crack/json' # for just json
require 'crack/xml' # for just xml
require 'haml'
require 'will_paginate'
require 'will_paginate/array'
require "will_paginate-bootstrap"

%w(rubygems wordnik).each {|lib| require lib}
Wordnik.configure do |config|
	config.api_key = 'dda1b2f2f32181605358a07cb56366a5c7c1b76738d123ebf'
end

class Word
	attr_accessor :word
	def initialize
		@word = self.new
	end

	def self.find_related_words(word, page)
		@word = word
		curl_command = "curl http://spell.ockham.org/?word=#{@word}"
		result = %x[#{curl_command}]
		res = Crack::XML.parse(result)
		spellings = res["spell"]["spellings"]["spelling"].paginate(:per_page => 5, :page => page)
		return spellings
	end

end

get "/" do
	haml :index
end

get "/find_word" do
	page = params[:page].blank? ? 1 : params[:page]
	@words = Word.find_related_words(params[:word], page)
	haml :words
end

get "/definition/:word" do
	@definitions = Wordnik.word.get_definitions(params[:word])
	haml :word_definition
end