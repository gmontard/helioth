class User

  attr_accessor :role, :instance

  def initialize(role: role, instance: {role: role})
    @role = role
    @instance = Instance.new(instance)
  end

  def role?
    self.role.to_sym
  end

end
