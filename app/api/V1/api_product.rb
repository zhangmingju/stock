module V1
  class ApiProduct < Grape::API

    version 'v1', using: :path

    resources 'products' do

      # http://localhost:3000/api/v1/products/:unique_id
      params do
        requires :unique_id, type: String
      end
      get ":unique_id", jbuilder: 'v1/products/show' do
        @product = Product.find_by(unique_id:params[:unique_id])
      end

      #http://localhost:3000/api/v1/products/search
      params do 
        requires :key_word,type:String
      end
      post 'search',jbuilder:'v1/products/index' do
        AppLog.info("key_word :#{params[:key_word]}")
        @products = Product.where("name like ?","%#{params[:key_word]}%")
        if @products.blank?
          @category = Category.where("name like ?","%#{params[:key_word]}%").first
          AppLog.info("category:  #{@category.inspect}")
          if @category.present?
            @products = @category.products
            AppLog.info("products:   #{@porducts.to_json}")
          else
            sub_ids = SubCategory.where("name like ?","%#{params[:key_word]}%").pluck(:id)
            AppLog.info("sub_ids:  #{sub_ids}")
            if sub_ids.present?
              @products = Product.where(sub_category_id:sub_ids)
            else
              detail_ids = DetailCategory.where("name like ?","%#{params[:key_word]}%").pluck(:id)
              AppLog.info("detail_ids:  #{detail_ids}")
              @products = Product.where(detail_category_id:detail_ids)
            end
          end
        end
      end
    end
  end
end
