module Dashboard
  class Load
    @@loaded_from_gem = false
    def self.is_loaded_from_gem
      @@loaded_from_gem
    end

    def self.loaded
    end

    @@loaded_from_gem = Load.method('loaded').source_location.first.include?('bx_block_')
  end
end

# unless Dashboard::Load.is_loaded_from_gem
  # ActiveAdmin.register_page "Dashboard" do
  #   menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  #   content title: proc { I18n.t("active_admin.dashboard") } do
  #     columns do
  #       column do
  #         panel "Total Students" do
  #           ul do
  #             link_to AccountBlock::Account.joins(:role).where(roles: {name: "Student"}).size, admin_students_url()
  #           end
  #         end

  #         panel "Total School Admins" do
  #           ul do
  #             link_to AccountBlock::Account.joins(:role).where(roles: {name: "School Admin"}).size, admin_school_admins_url()
  #           end
  #         end
  #       end

  #       column do
  #         panel "Total Teachers" do
  #           ul do
  #             link_to AccountBlock::Account.joins(:role).where(roles: {name: "Teacher"}).size, admin_teachers_url()
  #           end
  #         end

  #         panel "Total Publishers" do
  #           ul do
  #             link_to AccountBlock::Account.joins(:role).where(roles: {name: "Publisher"}).size, admin_publishers_url()
  #           end
  #         end
  #       end
  #       column do
  #         panel "Total Ebooks" do
  #           ul do
  #             li do
  #               link_to "#{BxBlockBulkUploading::Ebook.all.size}", admin_ebooks_path
  #             end
  #           end
  #         end

  #         panel "Total Ebook Bundles" do
  #           ul do
  #             li do
  #               link_to "#{BxBlockBulkUploading::BundleManagement.all.size}", admin_bundle_managements_path
  #             end
  #           end
  #         end
  #       end
  #     end
  #   end
  # end
# end
unless Dashboard::Load.is_loaded_from_gem
  ActiveAdmin.register_page "Dashboard" do
    menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }
  
    content title: proc { I18n.t("active_admin.dashboard") } do
      if current_admin_user.super_admin?
        columns do
          column do
            panel "Total Students" do
              ul do
                link_to AccountBlock::Account.joins(:role).where(roles: {name: "Student"}).size, admin_students_url()
              end
            end
  
            panel "Total School Admins" do
              ul do
                link_to AccountBlock::Account.joins(:role).where(roles: {name: "School Admin"}).size, admin_school_admins_url()
              end
            end
          end
  
          column do
            panel "Total Teachers" do
              ul do
                link_to AccountBlock::Account.joins(:role).where(roles: {name: "Teacher"}).size, admin_teachers_url()
              end
            end
  
            panel "Total Publishers" do
              ul do
                link_to AccountBlock::Account.joins(:role).where(roles: {name: "Publisher"}).size, admin_publishers_url()
              end
            end
          end
          column do
            panel "Total Ebooks" do
              ul do
                li do
                  link_to "#{BxBlockBulkUploading::Ebook.all.size}", admin_ebooks_path
                end
              end
            end
  
            panel "Total Ebook Bundles" do
              ul do
                li do
                  link_to "#{BxBlockBulkUploading::BundleManagement.all.size}", admin_bundle_managements_path
                end
              end
            end
          end
        end
      else
        school = current_admin_user.school_id 
        columns do
          column do
            panel "Total Students" do
              ul do
                link_to  AccountBlock::Account.where(school_id: school).joins(:role).where(roles: { name: "Student" }).size, admin_students_url()
              end
            end
          end
        end

        columns do
          column do
            panel "Total Teacher" do
              ul do
                link_to  AccountBlock::Account.where(school_id: school).joins(:role).where(roles: { name: "Teacher" }).size, admin_teachers_url()
              end
            end
          end
        end
      end
    end
  end
end
