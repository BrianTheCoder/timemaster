require 'teststrap'

context "chronos" do
  setup do
    @time = Time.local(2010, 4, 20, 16, 20, 0)
    Timecop.freeze(@time)
  end

  asserts "creates all the appropriate time based keys" do
    
  end
end
