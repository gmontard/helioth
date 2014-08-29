class Instance

  attr_accessor :role

  def initialize(role: role)
    @role = role
  end

  def role?
    self.role.to_sym
  end

end
