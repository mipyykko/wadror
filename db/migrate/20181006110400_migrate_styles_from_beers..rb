class MigrateStylesFromBeers < ActiveRecord::Migration[5.2]
  def change
    uniq_styles = Beer.all.map { |beer| beer.style }.to_set.to_a
    uniq_styles.each { |style| Style.create name: style}
  end
end
