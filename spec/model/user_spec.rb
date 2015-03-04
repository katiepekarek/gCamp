describe Project do

  it "is valid with a full name email and password" do

    user=User.new(first_name:'Name', last_name: 'Smith', email:'user@yahoo.com', password: '1234', password_confirmation: '1234' )

    expect(user).to be_valid

  end

  it "is not valid without a first_name" do

    user = User.new(first_name: nil, last_name: 'Smith', email:'user@yahoo.com', password: '1234', password_confirmation: '1234')
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")

  end

  it "is not valid without a last name" do

    user = User.new(first_name: "charlie", last_name: nil, email:'user@yahoo.com', password: '1234', password_confirmation: '1234')
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")

  end

  it "is not valid without an email" do

    user = User.new(first_name: 'Sam', last_name: 'Smith', email: nil, password: '1234', password_confirmation: '1234')
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")

  end

end
