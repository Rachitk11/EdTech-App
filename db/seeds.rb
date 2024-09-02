# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# AdminUser.where(role: "super_admin").delete_all
# AdminUser.delete_all
AdminUser.create(email: "admin@example.com", password: "password", password_confirmation: "password", role: "super_admin") unless AdminUser.find_by_email('admin@example.com')
# BxBlockBulkUploading::Ebook.delete_all
BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
BxBlockRolesPermissions::Role.find_or_create_by(name: 'Teacher')
BxBlockRolesPermissions::Role.find_or_create_by(name: 'School Admin')
BxBlockRolesPermissions::Role.find_or_create_by(name: 'Publisher')
