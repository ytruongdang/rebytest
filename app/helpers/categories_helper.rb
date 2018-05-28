module CategoriesHelper
  def categories_tree_for categories
    categories.map do |category, nested_categories|
      html = ""
      if category.present?
        html << content_tag(:tr, render(category),
          class: category.root? ? "" : "panel-collapse collapse
          category-#{category.parent_id}") <<
          categories_tree_for(nested_categories)
      end
    end.join.html_safe
  end
end
