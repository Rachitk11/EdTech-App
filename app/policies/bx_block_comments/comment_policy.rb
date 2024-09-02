# frozen_string_literal: true

module BxBlockComments
  class CommentPolicy < ::BxBlockComments::ApplicationPolicy
    def index?
      true
    end

    def show?
      true
    end

    def create?
      true
    end

    def destroy?
      true
    end

    def update?
      true
    end
  end
end
