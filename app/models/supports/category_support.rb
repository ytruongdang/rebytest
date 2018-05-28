class Supports::CategorySupport
  def initialize args
    @category = args[:category]
  end

  def category
    @category
  end

  def parent_categories
    @parent_categories = Category.all.map{|category| [category.name, category.id]}
  end
end
