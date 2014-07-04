def setup_factories
  filenames=Dir.new("#{Rails.root}/app/models").entries.select{|e| e.match(/.rb$/)}
  modelnames=filenames.map{|fn| fn.gsub(/.rb$/,'').camelize.constantize}
  modelnames.each do |thing|
    string=thing.to_s.underscore
    symbol=string.to_sym
    symbol_none="#{string.pluralize}_none".to_sym
    symbol_none_alt="no_#{string.pluralize}".to_sym
    symbol_some="#{string.pluralize}_some".to_sym
    symbol_some_alt="some_#{string.pluralize}".to_sym
    let(symbol){FactoryGirl.create symbol}
    let(symbol_none){thing.where(id: [0])}
    let(symbol_none_alt){thing.where(id: [0])}
    let(symbol_some){thing.where(id: eval(string).id)}
    let(symbol_some_alt){thing.where(id: eval(string).id)}
    let("params_new_#{string}".to_sym){ {symbol => {id: 1}} }
    let("params_full_#{string}".to_sym){ {id:1, symbol => {id: 1}} }
  end
  let(:params_id){ {id: 1} }
end


