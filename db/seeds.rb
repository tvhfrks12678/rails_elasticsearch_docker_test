ActiveRecord::Base.transaction do
  Article.delete_all
  5.times do |index|
    Article.create!(
        title: "タイトル_#{index}",
        body: "記事本文_#{index}"
    )
  end

  Article.create(
    title: "犬の気持ち",
    body: "吾輩は犬である。名前はまだない。",
  )
  
  Article.create(
    title: "ねこのすべて",
    body: "猫はとても気まぐれです。気まぐれロマンティック。構って欲しい時にしか寄ってきません。ぴえん。",
  )
  
  Article.create(
    title: "私VTuberになる",
    body: "どうも初めましてVTuberの酢飯マグロです。VTuberを始めて1年経って分かった5つの大事な事を紹介します。",
  )

end

