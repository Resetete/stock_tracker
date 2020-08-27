module StatisticsHelper
  def profit_per_ticker(data)
    line_chart data.group(:ticker).group_by_day(:date).sum(:profit),
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
