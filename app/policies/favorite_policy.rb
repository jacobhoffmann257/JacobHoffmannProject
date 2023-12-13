class FavoritePolicy < ApplicationPolicy
  attr_reader :user, :favortie
    def initialize(user,favorite)
      @user = user
      @favorite = favorite
    end
    def show?
      false
    end
    def edit?
      @user.id == @favorite.user_id
    end
    def update?
      #only the user can update
      @user.id == @favorite.user_id
    end
    def destroy?
      #only the user can delete
      @user.id == @favorite.user_id
    end
    def create?
      #only the user can create
      @user != nil
    end
  end
  