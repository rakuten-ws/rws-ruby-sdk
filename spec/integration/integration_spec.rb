require 'spec_helper'

describe 'Call all APIs', type: 'integration' do
  describe RakutenWebService::Ichiba do
    it do
       expect { RWS::Ichiba::Item.search(keyword: 'Ruby').first }.not_to raise_error
    end
    it do
      expect { RWS::Ichiba::Genre.search(genre_id: 559887).first }.not_to raise_error
    end
    it do
      expect { RWS::Ichiba::Product.search(keyword: 'Ruby').first }.not_to raise_error
    end
    it do
      expect { RWS::Ichiba::RankingItem.search(age: 30, sex: 0).first }.not_to raise_error
    end
    it do
      expect { RWS::Ichiba::TagGroup.search(tagId: 1000317).first.tags }.not_to raise_error
    end
  end

  describe RakutenWebService::Books do
    it do
      expect { RWS::Books::Total.search(keyword: 'Ruby').first }.not_to raise_error
    end
    it do
      expect { RWS::Books::Book.search(title: 'Ruby').first }.not_to raise_error
    end
    it do
      expect { RWS::Books::CD.search(title: 'Ruby').first }.not_to raise_error
    end
    it do
      expect { RWS::Books::DVD.search(title: 'Ruby').first }.not_to raise_error
    end
    it do
      expect { RWS::Books::ForeignBook.search(title: 'Ruby').first }.not_to raise_error
    end
    it do
      expect { RWS::Books::Magazine.search(title: 'Ruby').first }.not_to raise_error
    end
    it do
      expect { RWS::Books::Game.search(title: 'Ruby').first }.not_to raise_error
    end
    it do
      expect { RWS::Books::Software.search(title: 'Ruby').first }.not_to raise_error
    end
    it do
      expect { RWS::Books::Genre.search(books_genre_id: '001005').first }.not_to raise_error
    end
  end

  describe RakutenWebService::Recipe do
    it do
      expect { RWS::Recipe.categories('large') }.not_to raise_error
    end
    it do
      expect { RWS::Recipe.categories('large').first.ranking.first }.not_to raise_error
    end
  end

  describe RakutenWebService::Kobo do
    it do
      expect { RWS::Kobo::Ebook.search(keyword: 'Ruby').first }.not_to raise_error
    end
    it do
      expect { RWS::Kobo::Genre.search(kobo_genre_id: 101).first }.not_to raise_error
    end
  end

  describe RakutenWebService::Gora do
    it do
      expect { RWS::Gora::Course.search(keyword: 'セグウェイ').first }.not_to raise_error
    end
    it do
      expect { RWS::Gora::CourseDetail.search(golf_course_id: 80004).first }.not_to raise_error
    end
    xit do
      expect { RWS::Gora::Plan.search(playDate: '2017-01-11', areaCode: 0).first }.not_to raise_error
    end
  end
end
