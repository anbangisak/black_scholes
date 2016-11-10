class ScholesController < ApplicationController
  before_filter :scholes_vals, :only => :cal_scholes
  before_filter :get_schole

  def scholes_home
  end

  def scholes_update_price
    begin
      cal_or_put_option = @schole.cal_option_val ? "c" : "p" 
      @display_price = Schole.black_scholes(cal_or_put_option,@schole.stock_price.to_f, params[:strike_price].to_f, @schole.years.to_f, params[:risk_free].to_f, params[:volatility].to_f)
      @message = "successful"
      @status = 200
    rescue => e
      p "#{e.to_s}"
      @message = "failed"
      @status = 500
    end
    respond_to do |format|
      format.json {
        render json: {:message => @message,:status=>@status, :display_price => @display_price ? @display_price : 0.00}, status: @status
      }
    end
  end

  def scholes_graph
  end

  def scholes_price
  end

  def cal_scholes
    @schole_new = current_user.scholes.new(schole_save_params) unless @schole
    respond_to do |format|
      if @schole_new && @schole_new.save
        format.html { redirect_to root_url, notice: 'Scholes was successfully saved.' }
      elsif @schole && @schole.update(schole_save_params)
        format.html { redirect_to root_url, notice: 'Scholes was successfully updated.' }
      else
        format.html { render :scholes_home }
      end
    end
  end

  def scholes_all
  end

  def scholes_save_all
    @schole = current_user.scholes.new(scholes_save_all_params)
    respond_to do |format|
      if @schole.save
        format.html { redirect_to scholes_path, notice: 'Scholes was successfully created.' }
      else
        format.html { render :scholes_all }
      end
    end
  end

  def index
    @scholes = Schole.all
  end

  private

    def scholes_params
      params.permit(:stock_price, :call_put_scholes, :years)
    end

    def schole_save_params
      {stock_price: params[:stock_price], cal_option_val: params[:call_put_scholes] == "call", put_option_val: params[:call_put_scholes] == "put", years: params[:years]}
    end

    def scholes_save_all_params
      params.permit(:stock_price, :call_put_scholes, :years, :strike_price, :risk_free, :volatility )
      {stock_price: params[:stock_price], cal_option_val: params[:call_put_scholes] == "call", put_option_val: params[:call_put_scholes] == "put", years: params[:years], strike_price: params[:strike_price], risk_free: params[:risk_free], volatility: params[:volatility]}
    end

    def scholes_vals
      scholes_params
      # @cal_option = black_scholes("c",params[:stock_price].to_f, params[:strike_price].to_f, params[:years].to_f, params[:risk_free].to_f, params[:volatility].to_f)
      # @put_option = black_scholes("p",params[:stock_price].to_f, params[:strike_price].to_f, params[:years].to_f, params[:risk_free].to_f, params[:volatility].to_f)
    end

    def get_schole
      @schole = current_user.scholes.last
    end
end
