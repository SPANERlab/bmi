from .trace import Trace
from .query import Query
from .plot_iqr import Catplot

if __name__ == "__main__":
    Trace().run()
    Query().run()
    Catplot().run()
