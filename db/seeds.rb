ActiveRecord::Base.transaction do
  Article.delete_all
  5.times do |index|
    Article.create!(
        title: "タイトル_#{index}",
        body: "記事本文_#{index}"
    )
  end
end

