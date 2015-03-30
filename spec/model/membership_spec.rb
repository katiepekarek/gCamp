require 'rails_helper'

describe Membership do
  let(:user) { create_user }
  let(:project) { create_project }

  it 'is not valid without a user' do
    membership=Membership.new(user_id:'nil')
    expect(membership).not_to be_valid
  end

  it 'is valid with a unique user' do
    membership=Membership.new(user_id: user.id)
    membership.save
    expect(membership).to be_valid
  end

  it 'is not valid with a non-unique user' do
    membership=Membership.new(user_id: user.id, project_id: project.id, role:"member")
    membership.save
    membership_non_uniq=Membership.create(user_id: user.id, project_id: project.id, role:"owner")
    expect(membership_non_uniq.errors.messages).to eq({user: ["has already been added to this project"]})
  end

end
