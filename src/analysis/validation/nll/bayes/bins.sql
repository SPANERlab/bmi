SELECT
    SUM(CASE WHEN score_nll >= 0.45 AND score_nll < 0.65 THEN 1 ELSE 0 END)
        AS bin_045_065,
    SUM(CASE WHEN score_nll >= 0.65 AND score_nll < 0.85 THEN 1 ELSE 0 END)
        AS bin_065_085,
    SUM(CASE WHEN score_nll >= 0.85 AND score_nll < 1.05 THEN 1 ELSE 0 END)
        AS bin_085_105,
    SUM(CASE WHEN score_nll >= 1.05 AND score_nll < 1.25 THEN 1 ELSE 0 END)
        AS bin_105_125,
    SUM(CASE WHEN score_nll >= 1.25 AND score_nll < 1.45 THEN 1 ELSE 0 END)
        AS bin_125_145,
    SUM(CASE WHEN score_nll >= 1.45 AND score_nll < 1.65 THEN 1 ELSE 0 END)
        AS bin_145_165
FROM READ_CSV_AUTO('{input_file}')
WHERE pipeline IN ('CSPBLDA', 'CSPGP', 'TSBLR', 'TSGP', 'BSCNN', 'BDCNN')
