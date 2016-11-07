class ScholesController < ApplicationController
  before_filter :scholes_vals, :only => :cal_scholes 

  def scholes_home
  end

  def cal_scholes
    @schole = current_user.scholes.new(scholes_params)
    respond_to do |format|
      if @schole.save
        format.html { redirect_to root_url, notice: 'Scholes was successfully saved.' }
      else
        format.html { render :scholes_home }
      end
    end
  end


  private
    def cnd(x)
      a1, a2, a3, a4, a5 = 0.31938153, -0.356563782, 1.781477937, -1.821255978, 1.330274429
      l = x.abs
      k = 1.0 / (1.0 + 0.2316419 * l)
      w = 1.0 - 1.0 / Math.sqrt(2*Math::PI)*Math.exp(-l*l/2.0) * (a1*k + a2*k*k + a3*(k**3) + a4*(k**4) + a5*(k**5))
      w = 1.0 - w if x < 0
      return w
    end

    def black_scholes(callPutFlag, s, x, t, r, v)
      d1 = (Math.log(s/x)+(r+v*v/2.0)*t)/(v*Math.sqrt(t))
      d2 = d1-v*Math.sqrt(t)
      if callPutFlag == 'c'
        s*cnd(d1)-x*Math.exp(-r*t)*cnd(d2)
      else
        x*Math.exp(-r*t)*cnd(-d2)-s*cnd(-d1)
      end
    end

    def scholes_params
      params.permit(:stock_price, :strike_price, :years, :risk_free, :volatility)
    end

    def scholes_vals
      scholes_params
      @cal_option = black_scholes("c",params[:stock_price].to_f, params[:strike_price].to_f, params[:years].to_f, params[:risk_free].to_f, params[:volatility].to_f)
      @put_option = black_scholes("p",params[:stock_price].to_f, params[:strike_price].to_f, params[:years].to_f, params[:risk_free].to_f, params[:volatility].to_f)
    end
end