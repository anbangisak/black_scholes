class Schole < ActiveRecord::Base
  belongs_to :user

  def self.cnd(x)
    a1, a2, a3, a4, a5 = 0.31938153, -0.356563782, 1.781477937, -1.821255978, 1.330274429
    l = x.abs
    k = 1.0 / (1.0 + 0.2316419 * l)
    w = 1.0 - 1.0 / Math.sqrt(2*Math::PI)*Math.exp(-l*l/2.0) * (a1*k + a2*k*k + a3*(k**3) + a4*(k**4) + a5*(k**5))
    w = 1.0 - w if x < 0
    return w
  end

  def self.black_scholes(callPutFlag, s, x, t, r, v)
    d1 = (Math.log(s/x)+(r+v*v/2.0)*t)/(v*Math.sqrt(t))
    d2 = d1-v*Math.sqrt(t)
    if callPutFlag == 'c'
      s*Schole.cnd(d1)-x*Math.exp(-r*t)*Schole.cnd(d2)
    else
      x*Math.exp(-r*t)*Schole.cnd(-d2)-s*Schole.cnd(-d1)
    end
  end

  def display_price
    cal_or_put_option = self.cal_option_val ? "c" : "p" 
      @display_price = Schole.black_scholes(
        cal_or_put_option,
        (self.stock_price ? self.stock_price.to_f : 60.0),
        (self.strike_price ? self.strike_price.to_f : 65.0),
        (self.years ? self.years.to_f : 0.25),
        (self.risk_free ? self.risk_free.to_f : 8),
        (self.volatility ? self.volatility.to_f : 30)
        )
  end
end
