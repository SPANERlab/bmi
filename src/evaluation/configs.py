from enum import Enum


class Splits(Enum):
    BNCI2014_001 = 9
    Liu2024 = 10
    Stieger2021 = 10
    PhysionetMI = 10
    Lee2019_MI = 10
    Cho2017 = 10
    Schirrmeister2017 = 5
    Shin2017A = 5
    BNCI2014_004 = 9
    Dreyer2023 = 10
    Weibo2014 = 5
    GrosseWentrup2009 = 5
    Brandl2020 = 5
    Forenzo2023 = 5
    HefmiIch2025 = 5
    Kumar2024 = 5
    Zhou2020 = 5
    Chang2025 = 5
    GuttmannFlury2025_MI = 5
    Yang2025 = 10
    Zhou2020 = 8


class Subjects(Enum):
    BNCI2014_001 = None
    Liu2024 = None
    Stieger2021 = None
    PhysionetMI = None
    Lee2019_MI = None
    Cho2017 = None
    Schirrmeister2017 = None
    Shin2017A = None
    BNCI2014_004 = None
    Dreyer2023 = None
    Weibo2014 = None
    GrosseWentrup2009 = None
    Brandl2020 = None
    Forenzo2023 = None
    HefmiIch2025 = None
    Kumar2024 = None
    Zhou2020 = None
    Chang2025 = None
    GuttmannFlury2025_MI = None
    Yang2025 = None
    Zhou2020 = [13, 14, 15, 16, 17, 18, 19, 20]


class Sessions(Enum):
    BNCI2014_001 = None
    Liu2024 = None
    Stieger2021 = [1, 2, 3, 4, 5, 6]
    PhysionetMI = None
    Lee2019_MI = None
    Cho2017 = None
    Schirrmeister2017 = None
    Shin2017A = None
    BNCI2014_004 = None
    Dreyer2023 = None
    Weibo2014 = None
    GrosseWentrup2009 = None
    Brandl2020 = None
    Forenzo2023 = None
    HefmiIch2025 = None
    Kumar2024 = None
    Zhou2020 = None
    Chang2025 = None
    GuttmannFlury2025_MI = None
    Yang2025 = None
    Zhou2020 = None


# fmt: off
class Channels(Enum):
    BNCI2014_001 = ["FC3", "FC1", "FCz", "FC2", "FC4", "C5", "C3", "C1", "Cz", "C2", "C4", "C6", "CP3", "CP1", "CPz", "CP2", "CP4"]
    Liu2024 = ["FC3", "FCz", "FC4", "C3", "Cz", "C4", "CP3", "CP4"]
    Stieger2021 = ["FC5", "FC3", "FC1", "FCz", "FC2", "FC4", "FC6", "C5", "C3", "C1", "Cz", "C2", "C4", "C6", "CP5", "CP3", "CP1", "CPz", "CP2", "CP4", "CP6"]
    PhysionetMI = ["FC5", "FC3", "FC1", "FCz", "FC2", "FC4", "FC6", "C5", "C3", "C1", "Cz", "C2", "C4", "C6", "CP5", "CP3", "CP1", "CPz", "CP2", "CP4", "CP6"]
    Lee2019_MI = ["FC5", "FC3", "FC1", "FC2", "FC4", "FC6", "C5", "C3", "C1", "Cz", "C2", "C4", "C6", "CP5", "CP3", "CP1", "CPz", "CP2", "CP4", "CP6"]
    Cho2017 = ["FC5", "FC3", "FC1", "FCz", "FC2", "FC4", "FC6", "C5", "C3", "C1", "Cz", "C2", "C4", "C6", "CP5", "CP3", "CP1", "CPz", "CP2", "CP4", "CP6"]
    Schirrmeister2017 = ["FC5", "FC3", "FC1", "FCz", "FC2", "FC4", "FC6", "FCC5h", "FCC3h", "FFC1h", "FCC2h", "FCC4h", "FCC6h", "C5", "C3", "C1", "Cz", "C2", "C4", "C6", "CCP5h", "CCP3h", "CCP1h", "CCP2h", "CCP4h", "CCP6h", "CP5", "CP3", "CP1", "CPz", "CP2", "CP4", "CP6"]
    Shin2017A = ["FCC5h", "FCC3h", "FCC4h", "FCC6h", "Cz", "CCP5h", "CCP3h", "CCP4h", "CCP6h"]
    BNCI2014_004 = ["C3", "Cz", "C4"]
    Dreyer2023 = ["FC5", "FC3", "FC1", "FCz", "FC2", "FC4", "FC6", "C5", "C3", "C1", "Cz", "C2", "C4", "C6", "CP5", "CP3", "CP1", "CPz", "CP2", "CP4", "CP6"]
    Weibo2014 = ["FC5", "FC3", "FC1", "FCz", "FC2", "FC4", "FC6", "C5", "C3", "C1", "Cz", "C2", "C4", "C6", "CP5", "CP3", "CP1", "CPz", "CP2", "CP4", "CP6"]
    GrosseWentrup2009 = ["6", "39", "7", "27", "59", "28", "103", "70", "66", "123", "91", "122", "41", "8", "40", "26", "58", "25", "57", "72", "105", "71", "90", "120", "89", "10", "43", "11", "54", "22", "55", "23"]
    GrosseWentrup2009_1020 = ["FC5", "FC3", "FC1", "FC2", "FC4", "FC6", "FCC5h", "FCC3h", "FFC1h", "FCC2h", "FCC4h", "FCC6h", "C5", "C3", "C1", "Cz", "C2", "C4", "C6", "CCP5h", "CCP3h", "CCP1h", "CCP2h", "CCP4h", "CCP6h", "CP5", "CP3", "CP1", "CPz", "CP2", "CP4", "CP6"]
    Brandl2020 = ["FC5", "FC3", "FC1", "FCz", "FC2", "FC4", "FC6", "C5", "C3", "C1", "Cz", "C2", "C4", "C6", "CP5", "CP3", "CP1", "CPz", "CP2", "CP4", "CP6"]
    Forenzo2023 = ["FC5", "FC3", "FC1", "FC2", "FC4", "FC6", "C5", "C3", "C1", "C2", "C4", "C6", "CP5", "CP3", "CP1", "CP2", "CP4", "CP6"]
    HefmiIch2025 = ["FC5", "FC1", "FC2", "FC6", "C3", "Cz", "C4", "CP5", "CP1", "CP2", "CP6"]
    Kumar2024 = ["FC5", "FC1", "FC2", "FC6", "C3", "Cz", "C4", "CP5", "CP1", "CP2", "CP6"]
    Zhou2020 = ["FC5", "FC3", "FC1", "FCz", "FC2", "FC4", "FC6", "C5", "C3", "C1", "Cz", "C2", "C4", "C6", "CP5", "CP3", "CP1", "CPz", "CP2", "CP4", "CP6"]
    Chang2025 = ["FC5", "FC3", "FC1", "FCz", "FC2", "FC4", "FC6", "C5", "C3", "C1", "Cz", "C2", "C4", "C6", "CP5", "CP3", "CP1", "CP2", "CP4", "CP6"]
    GuttmannFlury2025_MI = ["FC5", "FC3", "FC1", "FCz", "FC2", "FC4", "FC6", "C5", "C3", "C1", "Cz", "C2", "C4", "C6", "CP5", "CP3", "CP1", "CPz", "CP2", "CP4", "CP6"]
    Yang2025 = ["FC5", "FC3", "FC1", "FCz", "FC2", "FC4", "FC6", "C5", "C3", "C1", "Cz", "C2", "C4", "C6", "CP5", "CP3", "CP1", "CP2", "CP4", "CP6"]
# fmt: on
