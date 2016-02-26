require 'rails_helper'

describe Song do
  it { should validate_presence_of(:title) }
end
