require "raze"
require "granite/adapter/pg"

class User < Granite::Base
  adapter pg
  field name : String
  field email : String
  timestamps
end

get "/" do |ctx|
  User.all.to_json
end

Raze.run
