from .trace import Trace
from .query import Query
from .plot_iqr import Catplot
from .emissions_rate_quantiles import EmissionsRateQuantiles
from .pie import PieCharts

if __name__ == "__main__":
    Trace().run()
    Query().run()
    Catplot().run()
    EmissionsRateQuantiles().run()
    PieCharts().run()
