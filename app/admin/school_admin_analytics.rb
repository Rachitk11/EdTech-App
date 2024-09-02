ActiveAdmin.register_page "School Admin Analytics" do
  menu parent: "Analytics"#, label: "School Admin Analytics"

  content title: "School Admin Analytics" do
    columns do
      column do
        panel "Total Students" do
          ul do
            li do
              link_to AccountBlock::Account.joins(:role).where(roles: {name: "Student"}).size, admin_students_url()
            end
          end
        end
        panel "Total Teachers" do
          ul do
            li do
              link_to AccountBlock::Account.joins(:role).where(roles: {name: "Teacher"}).size, admin_teachers_url()
            end
          end
        end
      end

      column do
        panel "Total Publishers" do
          ul do
            li do
              link_to AccountBlock::Account.joins(:role).where(roles: {name: "Publisher"}).size, admin_publishers_url()
            end
          end
        end
        panel "Total Ebooks" do
          ul do
            li do
              link_to "#{BxBlockBulkUploading::Ebook.all.count}", admin_ebooks_path
            end
          end
        end
      end
    end
  end
end
