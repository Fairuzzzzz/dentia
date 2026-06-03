class Odontogram < ApplicationRecord
  belongs_to :objective_examination

  def teeth_data=(value)
    if value.is_a?(String)
      super(JSON.parse(value))
    else
      super(value)
    end
  rescue JSON::ParserError
    super({})
  end
end
