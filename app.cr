require "raze"
require "granite/adapter/pg"

class User < Granite::Base
  adapter pg
  field name : String
  field email : String
  field password : String
  field reset_password_at : Time
  field deleted_at : Time
  timestamps

  has_many :sessions
  has_many :messages
  has_many :tasks
end

class Session < Granite::Base
  adapter pg
  field ip : String
  field deleted_at : Time
  timestamps

  belongs_to :user
end

class Group < Granite::Base
  adapter pg
  field name : String
  field deleted_at : Time
  timestamps

  has_many :group_permissions
  has_many :project_user_groups
  has_many :step_groups
end

class Permission < Granite::Base
  adapter pg
  field name : String
  field deleted_at : Time
  timestamps

  has_many :group_permissions
end

class GroupPermission < Granite::Base
  adapter pg
  field name : String
  field deleted_at : Time
  timestamps

  belongs_to :group
  belongs_to :permission
end

class Project < Granite::Base
  adapter pg
  field name : String
  field description : String
  field metadata : JSON
  field deleted_at : Time
  timestamps

  belongs_to :user
  has_many :project_users
  has_many :categories
  has_many :flows
  has_many :users, through: project_users
end

class ProjectUser < Granite::Base
  adapter pg
  field deleted_at : Time
  timestamps

  belongs_to :user
  belongs_to :project
  has_many :project_user_groups
  has_many :project_user_roles
  has_many :groups, through: project_user_groups
  has_many :roles, through: project_user_roles
end

class ProjectUserGroup < Granite::Base
  adapter pg
  field deleted_at : Time
  timestamps

  belongs_to :project_user
  belongs_to :group
end

class Role < Granite::Base
  adapter pg
  field name : String
  field description : String
  field deleted_at : Time
  timestamps

  belongs_to :project
  has_many :project_user_roles
end

class ProjectUserRole < Granite::Base
  adapter pg
  field deleted_at : Time
  timestamps

  belongs_to :project_user
  belongs_to :role
end

class Category < Granite::Base
  adapter pg
  field name : String
  field description : String
  field deleted_at : Time
  timestamps

  belongs_to :project
  has_many :documents
end

class Flow < Granite::Base
  adapter pg
  field name : String
  field description : String
  field deleted_at : Time
  timestamps

  belongs_to :project
  has_many :steps
end

class Step < Granite::Base
  adapter pg
  field name : String
  field description : String
  field deleted_at : Time
  timestamps

  belongs_to :flow
  belongs_to :step
  has_many :step_roles
  has_many :step_groups
  has_many :tasks
  has_many :roles, through: step_roles
  has_many :groups, through: step_groups
end

class StepRole < Granite::Base
  adapter pg
  field deleted_at : Time
  timestamps

  belongs_to :step
  belongs_to :role
end

class StepGroup < Granite::Base
  adapter pg
  field deleted_at : Time
  timestamps

  belongs_to :step
  belongs_to :group
end

class Type < Granite::Base
  adapter pg
  field name : String
  field description : String
  field deleted_at : Time
  timestamps

  belongs_to :project
  has_many :attributes
  has_many :documents
end

class Attribute < Granite::Base
  adapter pg
  field name : String
  field description : String
  field metadata : JSON
  field deleted_at : Time
  timestamps

  belongs_to :type
end

class Document < Granite::Base
  adapter pg
  field name : String
  field metadata : JSON
  field expires_at : Time
  field finished_at : Time
  field deleted_at : Time
  timestamps

  belongs_to :type
  belongs_to :category
  has_many :tasks
  has_many :document_attributes
  has_many :messages
end

class DocumentAttribute < Granite::Base
  adapter pg
  field value : String
  field deleted_at : Time
  timestamps

  belongs_to :document
  belongs_to :attribute
end

class Task < Granite::Base
  adapter pg
  field metadata : JSON
  expires_at : Time
  finished_at : Time
  field deleted_at : Time
  timestamps

  belongs_to :document
  belongs_to :step
  belongs_to :user
end

class Message < Granite::Base
  adapter pg
  message : String
  field metadata : JSON
  field deleted_at : Time
  timestamps

  belongs_to :document
  belongs_to :user
end

get "/" do |ctx|
  User.all.to_json
end

get "/user/:id/sessions" do |ctx|
  User.find!(ctx.params["id"]).sessions.to_json
end

Raze.run
