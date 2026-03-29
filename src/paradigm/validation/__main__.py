from .channels import Channels
from .montage import Montage
from .shape import Shape
from .cache_config import CacheConfig

if __name__ == "__main__":
    Channels().run()
    Montage().run()
    CacheConfig().run()
    Shape().run()
