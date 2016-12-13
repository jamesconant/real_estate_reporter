class AgentFromJson
  def initialize(json)
    @json = json
  end

  def update_or_create
    attributes = append_agent_attributes({})
    attributes = append_brokerage_attributes(attributes)
    attributes = append_sale_attributes(attributes)
    attributes = append_review_attributes(attributes)
    attributes = append_property_attributes(attributes)

    agent = Agent.find_by(
      first_name: attributes[:first_name],
      last_name: attributes[:last_name],
      middle_initial: attributes[:middle_initial]
    )

    # this could / should go in the Agent model?
    if agent
      Agent.update(attributes)
    else
      Agent.create(attributes)
    end
  end

  private

  def append_agent_attributes(attributes)
    attributes.tap do |attrs|
      agent_json = @json['sale']['agent']['agent']
      attrs[:first_name] = agent_json['first_name']
      attrs[:last_name] = agent_json['last_name']
      attrs[:middle_initial] = agent_json['middle_initial']
    end
  end

  def append_brokerage_attributes(attributes)
    attributes.tap do |attrs|
      brokerage_name = @json['sale']['agent']['agent']['brokerage']
      brokerage = Brokerage.find_by(name: brokerage_name)

      if brokerage
        attrs[:brokerage_id] = brokerage.id
      else
        attrs[:brokerage_attributes] = { name: brokerage_name }
      end
    end
  end

  def append_sale_attributes(attributes)
    attributes.tap do |attrs|
      if attrs[:sales_attributes].try(:first)
        attrs[:sales_attributes].first[:price] = @json['sale']['price']
      else
        attrs[:sales_attributes] = [] << { price: @json['sale']['price'] }
      end
    end
  end

  def append_review_attributes(attributes)
    attributes.tap do |attrs|
      unless attrs[:sales_attributes].try(:first)
        attrs[:sales_attributes] = [{}]
      end

      review_attrs = attrs[:sales_attributes].first[:review_attributes] = {}
      review_json = @json['sale']['review']['review']
      review_attrs[:content] = review_json['content']
      review_attrs[:rating] = review_json['rating']
    end
  end

  def append_property_attributes(attributes)
    attributes.tap do |attrs|
      unless attrs[:sales_attributes].try(:first)
        attrs[:sales_attributes] = [{}]
      end

      property_attrs = attrs[:sales_attributes].first[:property_attributes] = {}
      property_json = @json['sale']['property']['property']
      property_attrs[:address] = property_json['address']
      property_attrs[:unit] = property_json['unit']
      property_attrs[:city] = property_json['city']
      property_attrs[:state] = property_json['state']
      property_attrs[:zip_code] = property_json['zip_code']
      property_attrs[:mls_id] = property_json['id']
    end
  end
end
