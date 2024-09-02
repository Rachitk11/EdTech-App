module BxBlockNavmenu
  class NavigationMenuController < ApplicationController
    def create
      puts " - params = #{params}"
      navigation_attributes = jsonapi_deserialize(params)
      puts " - navigation_attributes = #{navigation_attributes}"
      service = BxBlockNavmenu::Create.new(navigation_attributes)
      result = service.execute
      result.collect do |menu|
        NavigationMenuSerializer.new(menu).serializable_hash
      end
      render json: result, status: :ok
    end

    def index
      navigation_menus = NavigationMenu.all
      result = navigation_menus.collect do |menu|
        NavigationMenuSerializer.new(menu).serializable_hash
      end
      render json: result, status: :ok
    end
  end
end
