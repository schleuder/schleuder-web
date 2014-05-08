class SchleuderListCreator
  def self.create(listname, adminemail, adminkeypath=nil)
    errors, list = List.build(listname, adminemail, adminkeypath)

    showerror(errors) if errors.present?
    list
  end

  def self.showerror(msg)
    $stderr.puts "Error: #{msg}"
    exit 1
  end
end
