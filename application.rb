require "rubygems"
require "sinatra"
# require 'open-uri'
# require 'nokogiri'
require 'crack'
require 'crack/json' # for just json
require 'crack/xml' # for just xml

%w(rubygems wordnik).each {|lib| require lib}
Wordnik.configure do |config|
	config.api_key = "YOUR WORDNIK API KEY HERE"
end

get "/" do
	@number_options = [1,5,10,20,30]
	erb :index
end

post "/find_word" do
	@number_options = [1,5,10,20,30]
	@word = params[:word]
	curl_command = "curl http://spell.ockham.org/?word=#{@word}"
	result = %x[#{curl_command}]
	@res = Crack::XML.parse(result)
	limit = params[:limit].blank? ? 5 : params[:limit].to_i
	@spellings = @res["spell"]["spellings"]["spelling"].first(limit)

	# doc = Nokogiri::HTML(open("http://spell.ockham.org/?word=#{@word}"))
	# @spellings = doc.xpath("//spelling").first(5)
	erb :words
end


get "/definition/:word" do
	@original_word = params[:original_word]
	@word = params[:word]
	@definitions = Wordnik.word.get_definitions(@word)
	@definitions
	erb :word_definition
end