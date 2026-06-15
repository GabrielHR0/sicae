class Current < ActiveSupport::CurrentAttributes
  attribute :user, :escola

  def escola_schema_name
    escola&.schema_name
  end
end