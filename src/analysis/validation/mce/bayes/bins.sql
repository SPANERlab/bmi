SELECT
    SUM(CASE WHEN score_mce >= 0.0 AND score_mce < 0.1 THEN 1 ELSE 0 END)
        AS bin_000_010,
    SUM(CASE WHEN score_mce >= 0.1 AND score_mce < 0.2 THEN 1 ELSE 0 END)
        AS bin_010_020,
    SUM(CASE WHEN score_mce >= 0.2 AND score_mce < 0.3 THEN 1 ELSE 0 END)
        AS bin_020_030,
    SUM(CASE WHEN score_mce >= 0.3 AND score_mce < 0.4 THEN 1 ELSE 0 END)
        AS bin_030_040,
    SUM(CASE WHEN score_mce >= 0.4 AND score_mce < 0.5 THEN 1 ELSE 0 END)
        AS bin_040_050,
    SUM(CASE WHEN score_mce >= 0.5 AND score_mce < 0.6 THEN 1 ELSE 0 END)
        AS bin_050_060,
    SUM(CASE WHEN score_mce >= 0.6 AND score_mce < 0.7 THEN 1 ELSE 0 END) AS bin_060_070
FROM READ_CSV_AUTO('{input_file}')
WHERE pipeline IN ('CSPBLDA', 'CSPGP', 'TSBLR', 'TSGP', 'BSCNN', 'BDCNN')
