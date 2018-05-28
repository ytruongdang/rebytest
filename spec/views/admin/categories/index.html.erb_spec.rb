require "rails_helper"

RSpec.describe "admin/categories/index.html.erb", type: :view do
  let(:category) {FactoryGirl.create :category}

  before do
    assign :categories, category
    allow(view).to receive(:categories_tree_for).and_return true
    @supports = Supports::CategorySupport.new category: Category.new
  end

  context "should index category" do
    before do
      render
    end
    it {expect(rendered).to include category.name}
  end

  context "should render new category path" do
    before do
      render
    end
    it {expect(rendered).to include new_admin_category_path}
  end

  context "should render edit category path" do
    before do
      render "admin/categories/category.html.erb", category: category
    end
    it {expect(rendered).to include edit_admin_category_path category}
  end

  context "should render delete category path" do
    before do
      render "admin/categories/category.html.erb", category: category
    end
    it {expect(rendered).to include admin_category_path category}
  end
end
