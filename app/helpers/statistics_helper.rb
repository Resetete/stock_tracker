module StatisticsHelper
  def profit_per_ticker(data)
    line_chart data.group(:ticker).group_by_day(:date).sum(:profit),
    title: 'Profit per ticker per day',
    height: '500px',
    suffix: ' EUR',
    round: 2,
    zeros: true,

    library: {
        yAxis: {
          crosshair: true,
          title: {
            text: 'Day'
          }
        },
        xAxis: {
          crosshair: true,
          title: {
            text: "Profit #{Wallet.pluck(:currency).uniq}"
          }
        }
    }
  end

  def total_profit(data)
    line_chart data.group_by_day(:date).sum(:profit),
    title: 'Total profit per day',
    height: '500px',
    suffix: ' EUR',
    round: 2,
    zeros: true,

    library: {
        yAxis: {
          crosshair: true,
          title: {
            text: 'Day'
          }
        },
        xAxis: {
          crosshair: true,
          title: {
            text: "Profit #{Wallet.pluck(:currency).uniq}"
          }
        }
    }
  end
end
