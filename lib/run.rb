def run_it
  p = Person.new

  command = Command::Signup.new(name: 'alex', email_address: 'bob@alexaitken.com', password: '123456')

  command.execute(p)

  p.commit

  [p, command]
end
