require "morse_spec_helpers/version"
begin
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f } if Rails.root.present?
rescue
end

module MorseSpecHelpers

  def acts_as_a_list
    describe 'acts_as_list' do
      describe 'given a blank position on save' do
        it 'should add itself to the list' do
          @instance.position = nil
          @instance.save
          @instance.position.should_not be_nil
        end
      end
    end
  end

  def boolean_default_false(method)
    exists(method)
    it "should default to false" do
      new_thing=@instance.class.new
      expect(new_thing.send(method)).to be_falsey
    end
  end

  def boolean_default_true(method)
    exists(method)
    it "should default to true" do
      new_thing=@instance.class.new
      expect(new_thing.send(method)).to be_truthy
    end
  end

  def exists(method)
    context "must respond to #{method}" do
      it "should respond to #{method}" do
        expect(@instance).to respond_to(method)
      end
    end
  end

  def exposes(variable)
    it "exposes variable #{variable}" do
      expect(controller.send(variable)).to_not be_nil
    end
  end

  def mandatory_array(method)
    context "#{method}" do
      exists(method)
      it "should be an Array" do
        expect(@instance.send(method).is_a?(Array)).to be_truthy
      end
    end
  end

  def mandatory_belongs_to(model)
    context "#{model}" do
      context "where the id is incorrect" do
        before do
          allow(model).to receive(:find_by_id).and_return(nil)
        end
        it "should be invalid" do
          expect(@instance).to_not be_valid
        end
      end
      context "where the id is correct" do
        before do
          allow(model).to receive(:find_by_id).and_return(true)
        end
        it "should be valid" do
          expect(@instance).to be_valid
        end
      end
    end
  end

  def mandatory_date(method)
    context "#{method} is a mandatory date" do
      it "should reject a blank #{method}" do
        @instance.send("#{method}=","")
        expect(@instance).not_to be_valid
      end
      it "should accept a normal date for #{method}" do
        @instance.send("#{method}=",Date.today)
        expect(@instance).to be_valid
      end
      mandatory_thing(method)
    end
  end

  def mandatory_date_or_default(method, default)
    describe "#{method} is a mandatory date that defaults to a value" do
      context "where it is present" do
        it "should be valid" do
          allow(@instance).to receive(method).and_return(Date.today)
          expect(@instance).to be_valid
        end
      end
      context "where it is not present" do
        it "should set to the default" do
          @instance.send("#{method}=", nil)
          expect(@instance).to be_valid
          expect(@instance.send(method)).to eq(default) 
        end
      end
    end
  end

  def mandatory_datetime(method,time=nil)
    context "#{method} is a mandatory datetime" do
      it "should reject a blank #{method}" do
        @instance.send("#{method}=","")
        expect(@instance).not_to be_valid
      end
      it "should accept a normal datetime for #{method}" do
        @instance.send("#{method}=",time||Time.now)
        expect(@instance).to be_valid
      end
      mandatory_thing(method)
    end
  end

  def mandatory_email(method)
    context "#{method} is a mandatory email" do
      it "should reject a blank #{method}" do
        @instance.send("#{method}=","")
        expect(@instance).not_to be_valid
      end
      it "should reject a badly formatted email for #{method}" do
        @instance.send("#{method}=","test@test")
        expect(@instance).to_not be_valid
      end
      it "should accept a properly formatted email for #{method}" do
        @instance.send("#{method}=","test@test.com")
        expect(@instance).to be_valid
      end
      it "should reject a normal string for #{method}" do
        @instance.send("#{method}=","test")
        expect(@instance).to_not be_valid
      end
      mandatory_thing(method)
    end
  end

  def mandatory_float(method)
    context "#{method} is a mandatory float" do
      it "should reject a blank #{method}" do
        @instance.send("#{method}=","")
        expect(@instance).not_to be_valid
      end
      it "should accept a normal float for #{method}" do
        @instance.send("#{method}=",1.1)
        expect(@instance).to be_valid
      end
      mandatory_thing(method)
    end
  end

  def mandatory_integer(method)
    context "#{method} is a mandatory integer" do
      it "should reject a blank #{method}" do
        @instance.send("#{method}=","")
        expect(@instance).not_to be_valid
      end
      it "should accept a normal integer for #{method}" do
        @instance.send("#{method}=",1)
        expect(@instance).to be_valid
      end
      mandatory_thing(method)
    end
  end

  def mandatory_relation(method)
    context "#{method}" do
      exists(method)
      it "should be an ActiveRecord::Relation" do
        expect(@instance.send(method).is_a?(ActiveRecord::Relation)).to be_truthy
      end
    end
  end

  def mandatory_string(method)
    context "#{method} is a mandatory string" do
      it "should reject a blank #{method}" do
        @instance.send("#{method}=","")
        expect(@instance).not_to be_valid
      end
      it "should accept a normal string for #{method}" do
        @instance.send("#{method}=","test")
        expect(@instance).to be_valid
      end
      mandatory_thing(method)
    end
  end

  def mandatory_string_from_collection(method,collection)
    context "#{method} is a mandatory string" do
      exists(method)
      it "should reject a blank #{method}" do
        @instance.send("#{method}=","")
        expect(@instance).not_to be_valid
      end
      context "where the value is not within the acceptable options" do
        it "should reject it" do
          @instance.send("#{method}=","zgodnflax")
          expect(@instance).to_not be_valid
        end
      end
      context "where the value is within the acceptable options" do
        it "should accept it" do
          @instance.send("#{method}=",collection.first)
          expect(@instance).to be_valid
        end
      end
    end
  end

  def mandatory_string_with_default(method,default)
    context "#{method} is a mandatory string which defaults to #{default}" do
      it "should set a blank string to #{default}" do
        @instance.send("#{method}=",nil)
        expect(@instance).to be_valid
        expect(@instance.send(method)).to eq(default)
      end
    end
  end

  def mandatory_thing(method)
    context "#{method} is mandatory" do
      exists(method)
      it "should reject a nil #{method}" do
        @instance.send("#{method}=","")
        expect(@instance).not_to be_valid
      end
    end
  end

  def mandatory_time(method,time=nil)
    context "#{method} is a mandatory time" do
      it "should reject a blank #{method}" do
        @instance.send("#{method}=","")
        expect(@instance).not_to be_valid
      end
      it "should accept a normal time for #{method}" do
        @instance.send("#{method}=",time||Time.now)
        expect(@instance).to be_valid
      end
      mandatory_thing(method)
    end
  end

  def one_date_not_after_the_other(first,second)
    context "for dates, where both #{first} and #{second} exist" do
      before do
        @first=Date.today-1.week
        @second=Date.today+1.week
      end
      context "where #{first} is before #{second}" do
        before do
          @instance.send("#{first}=",@first)
          @instance.send("#{second}=",@second)
        end
        it "should be valid" do
          expect(@instance).to be_valid
        end
      end
      context "where #{first} is the same as #{second}" do
        before do
          @instance.send("#{first}=",@first)
          @instance.send("#{second}=",@first)
        end
        it "should be valid" do
          expect(@instance).to be_valid
        end
      end
      context "where #{first} is after #{second}" do
        before do
          @instance.send("#{first}=",@second)
          @instance.send("#{second}=",@first)
        end
        it "should not be valid" do
          expect(@instance).to_not be_valid
        end
      end
    end
  end

  def one_datetime_not_after_the_other(first,second)
    context "for datetimes, where both #{first} and #{second} exist" do
      before do
        t=Time.now
        @first=t-1.week
        @second=t+1.week
      end
      one_thing_not_after_the_other(first,second)
    end
  end

  def one_thing_not_after_the_other(first,second)
    context "where #{first} is before #{second}" do
      before do
        @instance.send("#{first}=",@first)
        @instance.send("#{second}=",@second)
      end
      it "should be valid" do
        expect(@instance).to be_valid
      end
    end
    context "where #{first} is the same as #{second}" do
      before do
        @instance.send("#{first}=",@first)
        @instance.send("#{second}=",@first)
      end
      it "should be valid" do
        expect(@instance).to be_valid
      end
    end
    context "where #{first} is after #{second}" do
      before do
        @instance.send("#{first}=",@second)
        @instance.send("#{second}=",@first)
      end
      it "should not be valid" do
        expect(@instance).to_not be_valid
      end
    end
  end

  def optional_belongs_to(model)
    context "#{model}" do
      let(:model_id){"#{model.to_s.underscore}_id"}
      context "where the id is incorrect" do
        before do
          allow(model).to receive(:find_by_id).and_return(nil)
        end
        it "should set the id to nil" do
          @instance.valid?
          expect(@instance.send(model_id)).to be_nil
        end
        it "should be valid" do
          expect(@instance).to be_valid
        end
      end
      context "where the id is correct" do
        before do
          allow(model).to receive(:where).and_return(model.where("id is not null").first)
        end
        it "should be valid" do
          expect(@instance).to be_valid
        end
      end
    end
  end

  def optional_date(method)
    context "#{method} is an optional date" do
      exists(method)
      it "should make a blank #{method} nil" do
        @instance.send("#{method}=","")
        expect(@instance).to be_valid
        expect(@instance.send(method)).to be_nil
      end
      it "should accept a normal date for #{method}" do
        @instance.send("#{method}=",Date.today)
        expect(@instance).to be_valid
      end
    end
  end

  def optional_datetime(method)
    context "#{method} is an optional datetime" do
      exists(method)
      it "should make a blank #{method} nil" do
        @instance.send("#{method}=","")
        expect(@instance).to be_valid
        expect(@instance.send(method)).to be_nil
      end
      it "should accept a normal datetime for #{method}" do
        @instance.send("#{method}=",Time.now)
        expect(@instance).to be_valid
      end
    end
  end

  def optional_email(method)
    context "#{method} is an optional email" do
      it "should make a blank #{method} nil" do
        @instance.send("#{method}=","")
        expect(@instance).to be_valid
        expect(@instance.send(method)).to be_nil
      end
      it "should reject a badly formatted email for #{method}" do
        @instance.send("#{method}=","test@test")
        expect(@instance).to_not be_valid
      end
      it "should accept a properly formatted email for #{method}" do
        @instance.send("#{method}=","test@test.com")
        expect(@instance).to be_valid
      end
      it "should reject a normal string for #{method}" do
        @instance.send("#{method}=","test")
        expect(@instance).to_not be_valid
      end
    end
  end

  def optional_float(method)
    context "#{method} is an optional float" do
      exists(method)
      it "should make a blank #{method} nil" do
        @instance.send("#{method}=","")
        expect(@instance).to be_valid
        expect(@instance.send(method)).to be_nil
      end
      it "should accept a normal float for #{method}" do
        @instance.send("#{method}=",1.0)
        expect(@instance).to be_valid
      end
    end
  end

  def optional_integer(method)
    context "#{method} is an optional integer" do
      exists(method)
      it "should make a blank #{method} nil" do
        @instance.send("#{method}=","")
        expect(@instance).to be_valid
        expect(@instance.send(method)).to be_nil
      end
      it "should accept a normal integer for #{method}" do
        @instance.send("#{method}=",1)
        expect(@instance).to be_valid
      end
    end
  end

  def optional_time(method)
    context "#{method} is an optional time" do
      exists(method)
      it "should make a blank #{method} nil" do
        @instance.send("#{method}=","")
        expect(@instance).to be_valid
        expect(@instance.send(method)).to be_nil
      end
      it "should accept a normal time for #{method}" do
        @instance.send("#{method}=",Time.now)
        expect(@instance).to be_valid
      end
    end
  end

  def optional_string(method)
    context "#{method} is an optional string" do
      exists(method)
      it "should make a blank #{method} nil" do
        @instance.send("#{method}=","")
        expect(@instance).to be_valid
        expect(@instance.send(method)).to be_nil
      end
      it "should accept a normal string for #{method}" do
        @instance.send("#{method}=","test")
        expect(@instance).to be_valid
      end
    end
  end

  def optional_string_from_collection(method,collection)
    context "#{method} is an optional string" do
      exists(method)
      it "should make a blank #{method} nil" do
        @instance.send("#{method}=","")
        expect(@instance).to be_valid
        expect(@instance.send(method)).to be_nil
      end
      context "where the value is not within the acceptable options" do
        it "should not accept it" do
          @instance.send("#{method}=","zgodnflax")
          expect(@instance).to_not be_valid
        end
      end
      context "where the value is within the acceptable options" do
        it "should accept it" do
          @instance.send("#{method}=",collection.first)
          expect(@instance).to be_valid
        end
      end
    end
  end

  def processes_attachment_to_attribute(method)
    describe "#{method} processing" do
      describe "accessors" do
        %w{attachment attachment_title attachment_alt attachment_remove}.each do |suffix|
          it "should respond to #{method}_#{suffix}" do
            expect(@instance).to respond_to("#{method}_#{suffix}")
          end
        end
        describe "processing" do
          describe "where all is good" do
            it "should process the #{method} attachment properly" do
              @instance.send("#{method}=",nil)
              @instance.valid?
              expect(@instance.send(method)).to be_nil
              @instance.send("#{method}_attachment=",fixture_file_upload("../support/images/placeholder.png", 'image/png'))
              @instance.send("#{method}_attachment_title=","test")
              @instance.valid?
              expect(@instance.send(method)).to_not be_nil
            end
          end
          describe "where the #{method} attachment has errors" do
            it "should be invalid and add attachment errors to #{method} attachment" do
              @instance.send("#{method}=",nil)
              @instance.valid?
              expect(@instance.send(method)).to be_nil
              @instance.send("#{method}_attachment_title=",nil)
              @instance.send("#{method}_attachment=",fixture_file_upload("../support/images/placeholder.png", 'image/png'))
              expect(@instance.valid?).to_not be_truthy
              expect(@instance.errors[method]).to_not be_empty
              expect(@instance.send(method)).to be_nil
            end
          end
        end
      end
    end
  end

  def processes_multiple_attachments_to_attribute(method)
    describe "#{method} processing" do
      it "should respond to #{method}" do
        expect(@instance.respond_to?(method)).to be_truthy
      end
      describe "accessors" do
        %w{attachment attachment_title attachment_alt attachment_remove}.each do |suffix|
          it "should respond to #{method.to_s.singularize}_#{suffix}" do
            expect(@instance).to respond_to("#{method.to_s.singularize}_#{suffix}")
          end
        end
        describe "processing" do
          describe "where all is good" do
            it "should process the #{method} attachment properly" do
              @instance.send("#{method}=",[])
              @instance.valid?
              expect(@instance.send(method)).to be_empty
              @instance.send("#{method.to_s.singularize}_attachment=",fixture_file_upload("../support/images/placeholder.png", 'image/png'))
              @instance.send("#{method.to_s.singularize}_attachment_alt=","test")
              @instance.valid?
              expect(@instance.send(method)).to_not be_empty
            end
          end
          describe "where the #{method} attachment has errors" do
            it "should be invalid and add attachment errors to #{method} attachment" do
              @instance.send("#{method}=",[])
              @instance.valid?
              expect(@instance.send(method)).to be_empty
              @instance.send("#{method.to_s.singularize}_attachment_alt=",nil)
              @instance.send("#{method.to_s.singularize}_attachment=",fixture_file_upload("../support/images/placeholder.png", 'image/png'))
              expect(@instance.valid?).to_not be_truthy
              expect(@instance.errors[method]).to_not be_empty
              expect(@instance.send(method)).to be_empty
            end
          end
        end
      end
    end
  end

  def redirects_to(path)
    it "should redirect to #{path}" do
      expect(response).to redirect_to(path)
    end
  end

  def returns_200
    it "returns http success" do
      expect(response).to be_success
    end
  end

  def sets_flash(method)
    it "should set flash #{method}" do
      expect(flash[method]).to_not be_nil
    end
  end

  def sets_flash_alert
    sets_flash(:alert)
  end

  def sets_flash_error
    sets_flash(:error)
  end

  def sets_flash_notice
    sets_flash(:notice)
  end

  def should_be_valid
    it "should be valid" do
      expect(@instance).to be_valid
    end
  end

  def should_not_be_valid
    it "should not be valid" do
      expect(@instance).to_not be_valid
    end
  end

  def there_can_be_only_one(thing)
    it "should allow only one #{thing}" do
      model=@instance.class
      model_for_factory_girl=model.to_s.underscore
      thing1=FactoryGirl.create model_for_factory_girl, thing=>true
      thing2=FactoryGirl.create model_for_factory_girl, thing=>false
      thing2.update_attribute(thing,true)
      thing2.save
      thing1.reload
      expect(thing1.send(thing)).to be_falsey
      expect(thing2.send(thing)).to be_truthy
    end
  end

  def view_allow(thing)
    if thing.is_a?(Array) || thing.is_a?(ActiveRecord::Relation)
      allow(view).to receive(thing.first.class.name.underscore.pluralize.to_sym).and_return(thing)
    else
      allow(view).to receive(thing.class.name.underscore.to_sym).and_return(thing)
    end
  end

  def view_allow_simple_form_for(thing, f=:f)
    form=SimpleForm::FormBuilder.new(thing.class, thing, self, {})
    allow(view).to receive(f).and_return(form)
  end
end
