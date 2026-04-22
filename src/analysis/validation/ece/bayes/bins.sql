SELECT
    SUM(CASE WHEN score_ece >= 0.0 AND score_ece < 0.05 THEN 1 ELSE 0 END) AS bin_000_005,
    SUM(CASE WHEN score_ece >= 0.05 AND score_ece < 0.1 THEN 1 ELSE 0 END) AS bin_005_010,
    SUM(CASE WHEN score_ece >= 0.1 AND score_ece < 0.15 THEN 1 ELSE 0 END) AS bin_010_015,
    SUM(CASE WHEN score_ece >= 0.15 AND score_ece < 0.2 THEN 1 ELSE 0 END) AS bin_015_020,
    SUM(CASE WHEN score_ece >= 0.2 AND score_ece < 0.25 THEN 1 ELSE 0 END) AS bin_020_025,
    SUM(CASE WHEN score_ece >= 0.25 AND score_ece < 0.3 THEN 1 ELSE 0 END) AS bin_025_030
FROM read_csv_auto('{input_file}')
WHERE pipeline IN ('CSPBLDA', 'CSPGP', 'TSBLR', 'TSGP', 'BSCNN', 'BDCNN')
