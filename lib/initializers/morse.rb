class ActiveRecord::Base

  def associated_object_exists(klass,fn,required=true)
    id=self.send(fn)
    id_setter=(fn.to_s+'=').to_sym
    unless klass.find_by_id(id)
      self.send(id_setter,nil)
      id=nil
    end
    if required==true and id.nil?
      errors.add(fn,"does not exist")
      return false
    end
  end

  def blank_to_nil(thing)
    if self.send(thing).blank?
      self.send(thing.to_s+'=',nil)
    end
  end

  def process_attachment(options={})
    options={:model_name=>:asset, :uploader_name=>:attachment}.merge(options)
    model_name=options[:model_name]
    uploader_name=options[:uploader_name]
    klass=eval(model_name.to_s.camelize)
    if self.send(uploader_name)
      a=klass.new(uploader_name=>self.send(uploader_name))
      if a.save
        self.send(model_name,a)
        self.send(uploader_name,nil)
        save
      else
        errors.add(uploader_name,'had a problem saving')
      end
    end
    if klass.find_by_id(self.id)
      self.reload
    end
  end

  def survive_if(thing)
    if self.send(thing)==true
      errors.add(:base,"Cannot destroy while #{thing} is true")
      false
    elsif  self.send(thing).is_a?(Array) and self.send(thing).any?
      errors.add(:base,"Cannot destroy while #{thing} has members")
      false
    end
  end

  def there_can_be_only_one(thing)
    if new_record?
      enemies=self.class.where("#{thing} = ?",true)
    else
      enemies=self.class.where("#{thing} = ? and id != ? ",true,id)
    end
    if enemies.any?
      enemies.each do |e|
        e.default_land=false
        e.save
      end
    end
  end

  def there_must_be_one(thing)
    existing=self.class.where("#{thing} = ?",true)
    if existing.empty?
      self.send("#{thing}=",true)
    end
  end

  def validate_integer_or_default(thing,default)
    unless self.send(thing)
      self.send("#{thing}=",default)
    end
  end

  def validate_mandatory_boolean(thing,message="must be true")
    unless self.send(thing)==true
      errors.add(thing,message)
    end
  end
end

#class Array
#  def sum
#    inject( nil ) { |sum,x| sum ? sum+x : x }
#  end
#end
