class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render plain: "tests/index"
    headers['test-header'] = 'test'
    status 300
  end

  def show
    @id = params[:id]
  end

  def create

  end

end
