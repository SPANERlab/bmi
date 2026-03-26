"""
Find all available left right imagery datasets.
"""

import json
from moabb.paradigms import LeftRightImagery as MOABBLeftRightImagery


class LeftRightImagery:
    def run(self):
        paradigm = MOABBLeftRightImagery()
        with open(f"datasets.json", "w") as f:
            json.dump(list(sorted([d.__class__.__name__ for d in paradigm.datasets])), f, indent=2)
