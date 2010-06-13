describe "every accessible many_to_one association", :shared => true do

  it "should allow to update an existing person via Profile#person_attributes" do
    Profile.all.size.should == 0
    Person.all.size.should  == 0

    profile = Profile.new :nick => 'snusnu'
    person = Person.create(:name => 'Martin')
    profile.person = person
    profile.save.should be_true

    Profile.all.size.should  == 1
    Person.all.size.should   == 1
    Person.first.name.should == 'Martin'

    profile.person_attributes = { :id => person.id, :name => 'Martin Gamsjaeger' }
    profile.save.should be_true

    Profile.all.size.should  == 1
    Person.all.size.should   == 1
    Person.first.name.should == 'Martin Gamsjaeger'
  end

  it "should return the attributes written to Profile#person_attributes from the Profile#person_attributes reader" do
    profile = Profile.new :nick => 'snusnu'
    profile.person_attributes.should be_nil
    profile.person_attributes = { :name => 'Martin' }
    profile.person_attributes.should == { :name => 'Martin' }
  end

end

describe "every accessible many_to_one association with a valid reject_if proc", :shared => true do

  it "should not allow to create a new person via Profile#person_attributes" do
    Profile.all.size.should == 0
    Person.all.size.should  == 0

    profile = Profile.new :nick => 'snusnu'
    profile.person_attributes = { :name => 'Martin' }

    Profile.all.size.should == 0
    Person.all.size.should  == 0

    begin
      profile.save.should be(false)
    rescue
      # swallow native FK errors which is basically like expecting save to be false
    end
  end

end

describe "every accessible many_to_one association with no reject_if proc", :shared => true do

  it "should allow to create a new person via Profile#person_attributes" do
    Profile.all.size.should == 0
    Person.all.size.should  == 0

    profile = Profile.new :nick => 'snusnu'
    profile.person_attributes = { :name => 'Martin' }

    Profile.all.size.should == 0
    Person.all.size.should  == 0

    profile.save.should be_true

    Profile.all.size.should  == 1
    Person.all.size.should   == 1
    Person.first.name.should == 'Martin'
  end

end

describe "every accessible many_to_one association with :allow_destroy => false", :shared => true do

  it "should not allow to delete an existing person via Profile#person_attributes" do
    Profile.all.size.should == 0
    Person.all.size.should  == 0

    person = Person.create(:name => 'Martin')
    profile = Profile.new :nick => 'snusnu'
    profile.person = person
    profile.save

    Profile.all.size.should == 1
    Person.all.size.should  == 1

    profile.person_attributes = { :id => person.id, :_delete => true }

    Profile.all.size.should == 1
    Person.all.size.should  == 1

    profile.save

    Profile.all.size.should == 1
    Person.all.size.should  == 1
  end

end

describe "every accessible many_to_one association with :allow_destroy => true", :shared => true do

  it "should allow to delete an existing person via Profile#person_attributes" do
    Profile.all.size.should == 0
    Person.all.size.should  == 0

    person = Person.create(:name => 'Martin')

    profile = Profile.new :nick => 'snusnu'
    profile.person = person
    profile.save.should be_true

    Profile.all.size.should == 1
    Person.all.size.should  == 1

    profile.person_attributes = { :id => person.id, :_delete => true }

    Profile.all.size.should == 1
    Person.all.size.should  == 1

    profile.save

    Person.all.size.should  == 0

    # TODO also test this behavior in situations where setting the FK to nil is allowed

  end

end
