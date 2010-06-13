describe "every accessible many_to_many association", :shared => true do

  it "should allow to update an existing project via Person#projects_attributes" do
    pending_if "#{DataMapper::Spec.adapter_name} doesn't support M2M", !HAS_M2M_SUPPORT do
      Person.all.size.should            == 0
      Project.all.size.should           == 0
      ProjectMembership.all.size.should == 0

      person = Person.create :name => 'snusnu'
      project = Project.create(:name => 'dm-accepts_nested_attributes')
      project_membership = ProjectMembership.create(:person => person, :project => project)

      Person.all.size.should            == 1
      Project.all.size.should           == 1
      ProjectMembership.all.size.should == 1

      person.projects_attributes = [{ :id => project.id, :name => 'still dm-accepts_nested_attributes' }]
      person.save

      Person.all.size.should            == 1
      ProjectMembership.all.size.should == 1
      Project.all.size.should           == 1

      Project.first.name.should == 'still dm-accepts_nested_attributes'
    end
  end

  it "should return the attributes written to Person#projects_attributes from the Person#projects_attributes reader" do
    person = Person.new :name => 'snusnu'
    person.projects_attributes.should be_nil
    person.projects_attributes = [{ :name => 'write specs' }]
    person.projects_attributes.should == [{ :name => 'write specs' }]
  end

end

describe "every accessible many_to_many association with a valid reject_if proc", :shared => true do

  it "should not allow to create a new project via Person#projects_attributes" do
    Person.all.size.should            == 0
    Project.all.size.should           == 0
    ProjectMembership.all.size.should == 0

    person = Person.create :name => 'snusnu'

    Person.all.size.should            == 1
    ProjectMembership.all.size.should == 0
    Project.all.size.should           == 0

    person.projects_attributes = [{ :name => 'dm-accepts_nested_attributes' }]
    person.save

    Person.all.size.should            == 1
    ProjectMembership.all.size.should == 0
    Project.all.size.should           == 0
  end

end

describe "every accessible many_to_many association with no reject_if proc", :shared => true do

  it "should allow to create a new project via Person#projects_attributes" do
    Person.all.size.should            == 0
    Project.all.size.should           == 0
    ProjectMembership.all.size.should == 0

    person = Person.create :name => 'snusnu'

    Person.all.size.should            == 1
    ProjectMembership.all.size.should == 0
    Project.all.size.should           == 0

    person.projects_attributes = [{ :name => 'dm-accepts_nested_attributes' }]

    Person.all.size.should            == 1
    ProjectMembership.all.size.should == 0
    Project.all.size.should           == 0

    person.save

    Person.all.size.should            == 1
    ProjectMembership.all.size.should == 1
    Project.all.size.should           == 1

    Project.first.name.should == 'dm-accepts_nested_attributes'
  end

end

describe "every accessible many_to_many association with :allow_destroy => false", :shared => true do

  it "should not allow to delete an existing project via Person#projects_attributes" do
    person = Person.create :name => 'snusnu'

    project = Project.create(:name => 'dm-accepts_nested_attributes')
    project_membership = ProjectMembership.create(:person => person, :project => project)

    Person.all.size.should            == 1
    ProjectMembership.all.size.should == 1
    Project.all.size.should           == 1

    person.projects_attributes = [{ :id => project.id, :_delete => true }]

    Person.all.size.should            == 1
    ProjectMembership.all.size.should == 1
    Project.all.size.should           == 1

    person.save

    Person.all.size.should            == 1
    ProjectMembership.all.size.should == 1
    Project.all.size.should           == 1
  end

end

describe "every accessible many_to_many association with :allow_destroy => true", :shared => true do

  it "should allow to delete an existing project via Person#projects_attributes" do
    pending_if "#{DataMapper::Spec.adapter_name} doesn't support M2M", !HAS_M2M_SUPPORT do
      person = Person.create :name => 'snusnu'

      project_1 = Project.create(:name => 'dm-accepts_nested_attributes')
      project_2 = Project.create(:name => 'dm-is-localizable')
      project_membership_1 = ProjectMembership.create(:person => person, :project => project_1)
      project_membership_2 = ProjectMembership.create(:person => person, :project => project_2)

      Person.all.size.should            == 1
      ProjectMembership.all.size.should == 2
      Project.all.size.should           == 2

      person.projects_attributes = [{ :id => project_1.id, :_delete => true }]

      Person.all.size.should            == 1
      ProjectMembership.all.size.should == 2
      Project.all.size.should           == 2

      person.save

      Person.all.size.should            == 1
      ProjectMembership.all.size.should == 1
      Project.all.size.should           == 1
    end
  end

end
