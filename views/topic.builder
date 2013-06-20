xml.instruct! :xml, :version => '1.0', :encoding => 'utf-8'
xml.feed :xmlns => 'http://www.w3.org/2005/Atom', :'xmlns:georss' => 'http://www.georss.org/georss' do
  xml.title "GEORSS EXAMPLE"
  xml.subtitle "SUBTITLE"
  xml.link "http://" + request.env["HTTP_HOST"] + topic_path(@audience, @topic)
  xml.updated Time.now.xmlschema
  xml.id topic_path(@audience, @topic)
  @topic.places.each_with_index do |slug, index|
    place = repository.place_from_slug(slug)
    xml.entry do
      xml.title place.name
      xml.id topic_path(@audience, @topic) + '/' + index.to_s
      xml.updated Time.now.xmlschema
      xml.summary "test"
      xml.tag! :'georss:point', [place.lat, place.lng].join(' ')
    end
  end
end
