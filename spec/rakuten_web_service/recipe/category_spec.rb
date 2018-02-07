require 'spec_helper'

describe RakutenWebService::Recipe::Category do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/Recipe/CategoryList/20170426' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:expected_query) do
    {
      affiliateId: affiliate_id,
      applicationId: application_id,
      formatVersion: '2',
      categoryType: category_type
    }
  end

  before do
    RakutenWebService.configure do |c|
      c.affiliate_id = affiliate_id
      c.application_id = application_id
    end
  end

  describe '.large_categories' do
    let(:category_type) { 'large' }

    before do
      response = JSON.parse(fixture('recipe/category.json'))

      @expected_request = stub_request(:get, endpoint).
        with(query: expected_query).to_return(body: response.to_json)
    end

    after do
      RWS::Recipe.instance_variable_set(:@categories, nil)
    end

    subject { RakutenWebService::Recipe.large_categories }

    it 'should return' do
      expect(subject).to be_a(Array)
    end
    it 'should call the endpoint once' do
      subject.first

      expect(@expected_request).to have_been_made.once
    end
    it 'should be Category resources' do
      expect(subject).to be_all { |c| c.is_a?(RakutenWebService::Recipe::Category) }
    end

    context 'When called twice or more' do
      specify 'should call the endpoint only once' do
        2.times { RakutenWebService::Recipe.large_categories }

        expect(@expected_request).to have_been_made.once
      end
    end
  end

  describe '.medium_categories' do
    it 'should call categories' do
      expect(RWS::Recipe).to receive(:categories).with('medium')

      RakutenWebService::Recipe.medium_categories
    end
  end

  describe '.small_categories' do
    it 'should call categories' do
      expect(RWS::Recipe).to receive(:categories).with('small')

      RakutenWebService::Recipe.small_categories

    end
  end

  describe "#parent_category" do
    let(:category) do
      RWS::Recipe::Category.new \
        categoryId: 2007,
        categoryName: 'もち麦',
        categoryType: 'small',
        parentCategoryId: '706'
    end
    let(:category_type) { 'medium' }

    before do
      response = JSON.parse(fixture('recipe/category.json'))

      @expected_request = stub_request(:get, endpoint).
        with(query: expected_query).to_return(body: response.to_json)
    end

    after do
      RakutenWebService::Recipe.instance_variable_set(:@categories, nil)
    end

    subject { category.parent_category }

    it "should be a Category" do
      expect(subject).to be_a(RWS::Recipe::Category)
    end
    it "should call the endpoint once to get medium categories" do
      subject
      expect(@expected_request).to have_been_made.once
    end
  end

  describe '#absolute_category_id' do
    let(:category) do
      RWS::Recipe::Category.new \
        categoryId: 706,
        categoryName: 'もち麦',
        categoryType: 'medium',
        parentCategoryId: '13'
    end
    let(:category_type) { 'large' }

    before do
      response = JSON.parse(fixture('recipe/category.json'))

      @expected_request = stub_request(:get, endpoint).
        with(query: expected_query).to_return(body: response.to_json)
    end

    after do
      RakutenWebService::Recipe.instance_variable_set(:@categories, nil)
    end

    subject { category.absolute_category_id }

    it "should be concatinations with parent category ids" do
      expect(subject).to be_eql("13-706")
    end

    context 'for small category' do
      let(:category) do
        RWS::Recipe::Category.new \
          categoryId: 2007,
          categoryName: 'もち麦',
          categoryType: 'small',
          parentCategoryId: '706'
      end

      before do
        response = JSON.parse(fixture('recipe/category.json'))

        stub_request(:get, endpoint).
          with(query: expected_query.merge(categoryType: 'medium')).
          to_return(body: response.to_json)
      end

      it 'should concatinations with parent category ids' do
        expect(subject).to be_eql("13-706-2007")
      end
    end
  end

  describe '#ranking' do
    let(:category) do
      RWS::Recipe::Category.new \
        categoryId: 706,
        categoryName: 'もち麦',
        categoryType: 'medium',
        parentCategoryId: '13'
    end
    let(:category_type) { 'large' }

    before do
      response = JSON.parse(fixture('recipe/category.json'))

      @expected_request = stub_request(:get, endpoint).
        with(query: expected_query).to_return(body: response.to_json)
    end

    after do
      RakutenWebService::Recipe.instance_variable_set(:@categories, nil)
    end

    it 'should call ranking method with category codes' do
      expect(RakutenWebService::Recipe).to receive(:ranking).with('13-706')

      category.ranking
    end
  end
end
