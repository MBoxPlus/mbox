module Actions
  def Actions.set_output(name, value)
    puts "::set-output name=#{name}::#{value}"
  end
end