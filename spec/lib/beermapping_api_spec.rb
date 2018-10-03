require 'rails_helper'

describe "BeermappingApi" do
  describe "in case of cache miss" do
    before :each do
      Rails.cache.clear
    end

    it "when HTTP GET returns one entry, it is parsed and returned" do
      answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>21525</id><name>Lapin panimo</name><status>Brewery</status><reviewlink>https://beermapping.com/location/21525</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=21525&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=21525&amp;d=1&amp;type=norm</blogmap><street>Teollisuustie 14 B</street><city>Rovaniemi</city><state>Lappi</state><zip>96320</zip><country>Finland</country><phone>+358 45 133 4410</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*rovaniemi/).to_return(body: answer, headers: { 'Content-Type' => 'text/xml' })

      places = BeermappingApi.places_in("rovaniemi")

      expect(places.size).to eq(1)

      place = places.first

      expect(place.name).to eq("Lapin panimo")
      expect(place.street).to eq("Teollisuustie 14 B")
    end

    it "when HTTP GET returns no places, an empty array is returned" do
      answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*asdf/).to_return(body: answer, headers: { 'Content-Type' => 'text/xml' })

      places = BeermappingApi.places_in("asdf")

      expect(places.size).to eq(0)
    end

    it "when HTTP GET returns many entries, all are parsed and returned" do
      answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>6556</id><name>Alehouse, The (Coeur d'Alene)</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/6556</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=6556&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=6556&amp;d=1&amp;type=norm</blogmap><street>226 W. Sixth Street</street><city>Moscow</city><state>ID</state><zip>83843</zip><country>United States</country><phone>(208) 882-2739</phone><overall>70.0001</overall><imagecount>0</imagecount></location><location><id>17702</id><name>Moscow Brewing Company</name><status>Brewery</status><reviewlink>https://beermapping.com/location/17702</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=17702&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=17702&amp;d=1&amp;type=norm</blogmap><street>630 N. Almon</street><city>Moscow</city><state>ID</state><zip>83843</zip><country>United States</country><phone>(208) 874-7340</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*moscow/).to_return(body: answer, headers: { 'Content-Type' => 'text/xml' })

      places = BeermappingApi.places_in("Moscow")

      expect(places.size).to eq(2)

      place1 = places[0]
      place2 = places[1]

      expect(place1.name).to eq("Alehouse, The (Coeur d'Alene)")
      expect(place2.name).to eq("Moscow Brewing Company")
    end
  end

  describe "in case of cache hit" do
    before :each do
      Rails.cache.clear
    end

    it "when one entry is in cache, it's returned" do
      answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>21525</id><name>Lapin panimo</name><status>Brewery</status><reviewlink>https://beermapping.com/location/21525</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=21525&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=21525&amp;d=1&amp;type=norm</blogmap><street>Teollisuustie 14 B</street><city>Rovaniemi</city><state>Lappi</state><zip>96320</zip><country>Finland</country><phone>+358 45 133 4410</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*rovaniemi/).to_return(body: answer, headers: { 'Content-Type' => 'text/xml' })

      BeermappingApi.places_in("rovaniemi")

      places = BeermappingApi.places_in("rovaniemi")

      expect(places.size).to eq(1)

      place = places.first

      expect(place.name).to eq("Lapin panimo")
      expect(place.street).to eq("Teollisuustie 14 B")
    end
  end      
end
