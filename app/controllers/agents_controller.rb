class AgentsController < ApplicationController
  def show
    @agent = Agent.find(params[:id])
    @uploaded_transactions = @agent.all_transactions.paginate(page: params[:page], per_page: 25)
    @transactions_as_buyer = @agent.transactions_as_buyer.paginate(page: params[:page], per_page: 25)
    @transactions_as_seller = @agent.transactions_as_seller.paginate(page: params[:page], per_page: 25)
  end

  def random_agent
    redirect_to agent_path(Agent.all.sample)
  end
end
