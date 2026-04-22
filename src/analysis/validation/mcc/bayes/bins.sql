SELECT
    SUM(CASE WHEN score_mcc >= -0.1 AND score_mcc < 0.0 THEN 1 ELSE 0 END)
        AS bin_01_00,
    SUM(CASE WHEN score_mcc >= 0.0 AND score_mcc < 0.1 THEN 1 ELSE 0 END)
        AS bin_00_01,
    SUM(CASE WHEN score_mcc >= 0.1 AND score_mcc < 0.2 THEN 1 ELSE 0 END)
        AS bin_01_02,
    SUM(CASE WHEN score_mcc >= 0.2 AND score_mcc < 0.3 THEN 1 ELSE 0 END)
        AS bin_02_03,
    SUM(CASE WHEN score_mcc >= 0.3 AND score_mcc < 0.4 THEN 1 ELSE 0 END)
        AS bin_03_04,
    SUM(CASE WHEN score_mcc >= 0.4 AND score_mcc < 0.5 THEN 1 ELSE 0 END)
        AS bin_04_05,
    SUM(CASE WHEN score_mcc >= 0.5 AND score_mcc < 0.6 THEN 1 ELSE 0 END)
        AS bin_05_06
FROM READ_CSV_AUTO('{input_file}')
WHERE pipeline IN ('CSPBLDA', 'CSPGP', 'TSBLR', 'TSGP', 'BSCNN', 'BDCNN')
