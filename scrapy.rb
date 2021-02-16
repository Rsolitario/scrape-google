require 'HTTParty'
require 'nokogiri'
require 'pry'
require 'CSV'

class Google
attr_writer :url
attr_reader :url, :datos

  def initialize(url)
    @url = url
  end

  @datos = []

  def conect()
      pagina = HTTParty.get(@url)
      pagina_nokogiri = Nokogiri::HTML(pagina)
  end

  def link ()
    conect().css('a').map {|link| link['href']}
  end

  def search_css (rules)
    conect().css(rules).map() {|d| d.text}
  end

  def search (rules)
    conect().search(rules).map() {|d| d.text}
  end

#end Google
end

link_tema_interes = []
array_texto = []
objetos_anidados = []
i = 0
#busqueda a realizar
busqueda = 'erp'

var = "https://www.google.com/search?q="
busqueda_google = Google.new(var + busqueda)
link_google = busqueda_google.link
expresion = "q=https?:\/\/[\w\-]+(\.[\w\-]+)+[/#?]?.*$"
link_google.each do |d|
  contenido = d.match(expresion)
  link_tema_interes.push(contenido)
end

link_tema_interes.each do |d|
  objeto_temas = Google.new ("https://www.google.com/url?" + d.to_s)
  objetos_anidados << objeto_temas
  parrafos = objetos_anidados[i].search_css('p')
  array_texto.push(parrafos.join())
  i += 1
end

File.open(busqueda + '.txt', 'w') do |d|
  array_texto.each do |r|
    d.write(r)
  end
end

=begin
CSV.open('datos.csv', 'w') do |d|
  d << array_texto
end
=end
#Pry.start(binding)
