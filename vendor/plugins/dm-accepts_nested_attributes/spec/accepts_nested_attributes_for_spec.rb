require 'spec_helper'

describe "DataMapper::Model.accepts_nested_attributes_for" do

  FIXTURES = <<-RUBY

    class ::Branch
      include DataMapper::Resource
      property :id, Serial
      has 1, :shop
      has n, :items
      has n, :bookings, :through => :items
    end

    class ::Shop
      include DataMapper::Resource
      property :id,        Serial
      belongs_to :branch
    end

    class ::Item
      include DataMapper::Resource
      property :id,        Serial
      belongs_to :branch
      has n, :bookings
    end

    class ::Booking
      include DataMapper::Resource
      property :id,      Serial
      belongs_to :item
    end

  RUBY

  before(:all) do
    eval FIXTURES
    DataMapper.auto_migrate!
  end

  before(:each) do

    Object.send(:remove_const, 'Branch')  if Object.const_defined?('Branch')
    Object.send(:remove_const, 'Shop')    if Object.const_defined?('Shop')
    Object.send(:remove_const, 'Item')    if Object.const_defined?('Item')
    Object.send(:remove_const, 'Booking') if Object.const_defined?('Booking')

    eval FIXTURES # neither class_eval nor instance_eval work here

  end


  describe "when called with" do

    describe "no association_name" do

      it "should raise" do
        lambda { Branch.accepts_nested_attributes_for }.should raise_error(ArgumentError)
      end

    end

    describe "nil as association_name" do

      describe "and no options" do

        it "should raise" do
          lambda { Branch.accepts_nested_attributes_for(nil) }.should raise_error(ArgumentError)
        end

      end

      describe "and empty options" do

        it "should raise" do
          lambda { Branch.accepts_nested_attributes_for(nil, {}) }.should raise_error(ArgumentError)
        end

      end

      describe "and invalid options" do

        it "should raise" do
          lambda { Branch.accepts_nested_attributes_for(nil, { :foo => :bar }) }.should raise_error(ArgumentError)
        end

      end

      describe "and valid options" do

        it "should raise" do
          lambda { Branch.accepts_nested_attributes_for(nil, { :allow_destroy => true }) }.should raise_error(ArgumentError)
        end

      end

    end

    describe "an invalid association_name" do

      describe "and no options" do

        it "should raise" do
          lambda { Branch.accepts_nested_attributes_for(:foo) }.should raise_error(ArgumentError)
        end

      end

      describe "and empty options" do

        it "should raise" do
          lambda { Branch.accepts_nested_attributes_for(:foo, {}) }.should raise_error(ArgumentError)
        end

      end

      describe "and invalid options" do

        it "should raise" do
          lambda { Branch.accepts_nested_attributes_for(:foo, { :foo => :bar }) }.should raise_error(ArgumentError)
        end

      end

      describe "and valid options" do

        it "should raise" do
          lambda { Branch.accepts_nested_attributes_for(:foo, { :allow_destroy => true }) }.should raise_error(ArgumentError)
        end

      end

    end


    describe "a valid association_name", :shared => true do


      describe "and no options" do

        it "should not raise" do
          lambda { @model.accepts_nested_attributes_for @association }.should_not raise_error
        end

        it "should store the accessible association in .options_for_nested_attributes" do
          @model.options_for_nested_attributes[@association].should be_nil
          @model.accepts_nested_attributes_for @association
          relationship = @model.relationships[@association]
          @model.options_for_nested_attributes[relationship].should_not be_nil
        end

        it "should store the default options under the association_name in .options_for_nested_attributes" do
          @model.options_for_nested_attributes[@association].should be_nil
          @model.accepts_nested_attributes_for @association
          relationship = @model.relationships[@association]
          @model.options_for_nested_attributes[relationship].should == { :allow_destroy => false }
        end

        it "should create a \#{association_name}_attributes instance reader" do
          p = @model.new
          p.respond_to?("#{@association}_attributes").should be_false
          @model.accepts_nested_attributes_for @association
          p = @model.new
          p.respond_to?("#{@association}_attributes").should be_true
        end

        it "should create a \#{association_name}_attributes instance writer" do
          p = @model.new
          p.respond_to?("#{@association}_attributes=").should be_false
          @model.accepts_nested_attributes_for @association
          p = @model.new
          p.respond_to?("#{@association}_attributes=").should be_true
        end

      end

      describe "and empty options" do

        it "should not raise" do
          lambda { @model.accepts_nested_attributes_for @association, {} }.should_not raise_error
        end

        it "should store the accessible association in .autosave_associations" do
          @model.options_for_nested_attributes[@association].should be_nil
          @model.accepts_nested_attributes_for @association, {}
          relationship = @model.relationships[@association]
          @model.options_for_nested_attributes[relationship].should_not be_nil
        end

        it "should store the default options under the association_name in .autosave_associations" do
          @model.options_for_nested_attributes[@association].should be_nil
          @model.accepts_nested_attributes_for @association, {}
          relationship = @model.relationships[@association]
          @model.options_for_nested_attributes[relationship].should == { :allow_destroy => false }
        end

        it "should create a \#{association_name}_attributes instance reader" do
          p = @model.new
          p.respond_to?("#{@association}_attributes").should be_false
          @model.accepts_nested_attributes_for @association, {}
          p = @model.new
          p.respond_to?("#{@association}_attributes").should be_true
        end

        it "should create a \#{association_name}_attributes instance writer" do
          p = @model.new
          p.respond_to?("#{@association}_attributes=").should be_false
          @model.accepts_nested_attributes_for @association, {}
          p = @model.new
          p.respond_to?("#{@association}_attributes=").should be_true
        end

      end

      describe "and invalid options" do

        it "should raise" do
          lambda { @model.accepts_nested_attributes_for @association, { :foo => :bar } }.should raise_error(DataMapper::NestedAttributes::InvalidOptions)
        end

        it "should not store the accessible association in .autosave_associations" do
          @model.options_for_nested_attributes[@association].should be_nil
          lambda { @model.accepts_nested_attributes_for @association, { :foo => :bar } }.should raise_error(DataMapper::NestedAttributes::InvalidOptions)
          @model.options_for_nested_attributes[@association].should be_nil
        end

        it "should not create a \#{association_name}_attributes instance reader" do
          p = @model.new
          p.respond_to?("#{@association}_attributes").should be_false
          lambda { @model.accepts_nested_attributes_for @association, { :foo => :bar } }.should raise_error(DataMapper::NestedAttributes::InvalidOptions)
          p = @model.new
          p.respond_to?("#{@association}_attributes").should be_false
        end

        it "should not create a \#{association_name}_attributes instance writer" do
          p = @model.new
          p.respond_to?("#{@association}_attributes=").should be_false
          lambda { @model.accepts_nested_attributes_for @association, { :foo => :bar } }.should raise_error(DataMapper::NestedAttributes::InvalidOptions)
          p = @model.new
          p.respond_to?("#{@association}_attributes=").should be_false
        end

      end

      describe "and valid options" do

        it "should not raise" do
          lambda { @model.accepts_nested_attributes_for @association, :allow_destroy => true }.should_not raise_error
        end

        it "should store the accessible association in .autosave_associations" do
          @model.options_for_nested_attributes[@association].should be_nil
          @model.accepts_nested_attributes_for @association, :allow_destroy => true
          relationship = @model.relationships[@association]
          @model.options_for_nested_attributes[relationship].should_not be_nil
        end

        it "should accept :allow_destroy as the only option (and thus overwrite the default option)" do
          @model.options_for_nested_attributes[@association].should be_nil
          @model.accepts_nested_attributes_for @association, :allow_destroy => true
          relationship = @model.relationships[@association]
          @model.options_for_nested_attributes[relationship].should == { :allow_destroy => true }
        end

        it "should accept :reject_if as the only option (and add :allow_destroy => false)" do
          @model.options_for_nested_attributes[@association].should be_nil
          @model.accepts_nested_attributes_for @association, :reject_if => lambda { |attributes| nil }
          relationship = @model.relationships[@association]
          @model.options_for_nested_attributes[relationship].should_not be_nil
          @model.options_for_nested_attributes[relationship][:allow_destroy].should be_false
          @model.options_for_nested_attributes[relationship][:reject_if].should be_kind_of(Proc)
        end

        it "should accept both :allow_destroy and :reject_if as options" do
          @model.options_for_nested_attributes[@association].should be_nil
          @model.accepts_nested_attributes_for @association, :allow_destroy => true, :reject_if => lambda { |attributes| nil }
          relationship = @model.relationships[@association]
          @model.options_for_nested_attributes[relationship].should_not be_nil
          @model.options_for_nested_attributes[relationship][:allow_destroy].should be_true
          @model.options_for_nested_attributes[relationship][:reject_if].should be_kind_of(Proc)
        end

        it "should create a \#{association_name}_attributes instance reader" do
          p = @model.new
          p.respond_to?("#{@association}_attributes").should be_false
          @model.accepts_nested_attributes_for @association, :allow_destroy => true
          p = @model.new
          p.respond_to?("#{@association}_attributes=").should be_true
        end

        it "should create a \#{association_name}_attributes instance writer" do
          p = @model.new
          p.respond_to?("#{@association}_attributes").should be_false
          @model.accepts_nested_attributes_for @association, :allow_destroy => true
          p = @model.new
          p.respond_to?("#{@association}_attributes=").should be_true
        end

      end

    end

    describe "a valid association_name pointing to multiple resources", :shared => true do

      describe "and no options" do

        it "should not create a get_\#{association_name} instance reader" do
          p = @model.new
          p.respond_to?("get_#{@association}").should be_false
          lambda { @model.accepts_nested_attributes_for @association }.should_not raise_error
          p = @model.new
          p.respond_to?("get_#{@association}").should be_false
        end

      end

      describe "and empty options" do

        it "should not create a get_\#{association_name} instance reader" do
          p = @model.new
          p.respond_to?("get_#{@association}").should be_false
          lambda { @model.accepts_nested_attributes_for @association, {} }.should_not raise_error
          p = @model.new
          p.respond_to?("get_#{@association}").should be_false
        end

      end

      describe "and invalid options" do

        it "should not create a get_\#{association_name} instance reader" do
          p = @model.new
          p.respond_to?("get_#{@association}").should be_false
          lambda { @model.accepts_nested_attributes_for @association, { :foo => :bar } }.should raise_error(DataMapper::NestedAttributes::InvalidOptions)
          p = @model.new
          p.respond_to?("get_#{@association}").should be_false
        end

      end

      describe "and valid options" do

        it "should not create a get_\#{association_name} instance reader" do
          p = @model.new
          p.respond_to?("get_#{@association}").should be_false
          lambda { @model.accepts_nested_attributes_for @association, { :allow_destroy => :true } }.should_not raise_error
          p = @model.new
          p.respond_to?("get_#{@association}").should be_false
        end

      end

    end

    # ----------------------------------------------------------------------------------------
    # ----------------------------------------------------------------------------------------
    # ----------------------------------------------------------------------------------------


    describe "a valid belongs_to association_name" do

      before(:each) do
        @model = Item
        @association = :branch
      end

      it_should_behave_like "a valid association_name"

    end

    describe "a valid has(1) association_name" do

      before(:each) do
        @model = Branch
        @association = :shop
      end

      it_should_behave_like "a valid association_name"

    end

    describe "a valid has(n) association_name" do

      before(:each) do
        @model = Branch
        @association = :items
      end

      it_should_behave_like "a valid association_name"
      it_should_behave_like "a valid association_name pointing to multiple resources"

    end

    describe "a valid has(n, :through) association_name" do

      before(:each) do
        @model = Branch
        @association = :bookings
      end

      it_should_behave_like "a valid association_name"
      it_should_behave_like "a valid association_name pointing to multiple resources"

    end

  end

end
