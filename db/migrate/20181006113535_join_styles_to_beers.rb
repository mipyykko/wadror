class JoinStylesToBeers < ActiveRecord::Migration[5.2]
  def change
    beers = Beer.all
    styles = Style.all.group_by(&:name)

    beers.each do |beer|
      puts styles[beer.name]
      if beer.old_style && styles[beer.old_style]
        beer.style_id = styles[beer.old_style][0].id
        beer.save
      end
    end
  end
end
