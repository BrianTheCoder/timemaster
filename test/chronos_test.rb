require 'teststrap'

context "chronos" do
  setup do
    @time = Time.local(2010, 4, 20, 16, 20, 0)
    Timecop.freeze(@time)
  end

  asserts "i'm a failure :(" do
    topic
  end
end
