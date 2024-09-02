class Ability
    include CanCan::Ability
    SCHOOL_ADMIN = "School Admin"
    PUBLISHER = "Publisher"
    def initialize(user)
      user ||= AdminUser.new
      if user.super_admin?
        can :manage, :all
      else
        
        can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
        # can :read, ActiveAdmin::Page, name: "Analytics", namespace_name: "admin"
        if user.school_allow == true
          can :read, BxBlockCategories::School, id: user.school_id
        end
        if user.class_allow == true
          can :manage, BxBlockCategories::SchoolClass
          can :manage, BxBlockCategories::ClassDivision
        end
        if user.subject_allow == true
          can :manage, BxBlockCatalogue::SubjectManagement
        end
        if user.assignment_allow == true
          can :manage, BxBlockCatalogue::Assignment
        end
        if user.video_allow == true
          can :manage, BxBlockCatalogue::VideosLecture
        end

        if user.account_allow == true       
          can :manage, AccountBlock::Account
          cannot :manage, AccountBlock::Account, role: { name: [PUBLISHER, SCHOOL_ADMIN] }
        end
     end
    end
  end
  
