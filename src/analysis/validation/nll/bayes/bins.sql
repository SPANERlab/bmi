SELECT
    SUM(CASE WHEN score_nll >= 0.50 AND score_nll < 0.70 THEN 1 ELSE 0 END)
        AS bin_050_070,
    SUM(CASE WHEN score_nll >= 0.70 AND score_nll < 0.90 THEN 1 ELSE 0 END)
        AS bin_070_090,
    SUM(CASE WHEN score_nll >= 0.90 AND score_nll < 1.10 THEN 1 ELSE 0 END)
        AS bin_090_110,
    SUM(CASE WHEN score_nll >= 1.10 AND score_nll < 1.30 THEN 1 ELSE 0 END)
        AS bin_110_130,
    SUM(CASE WHEN score_nll >= 1.30 AND score_nll < 1.50 THEN 1 ELSE 0 END)
        AS bin_130_150,
    SUM(CASE WHEN score_nll >= 1.50 AND score_nll < 1.70 THEN 1 ELSE 0 END)
        AS bin_150_170
FROM READ_CSV_AUTO('{input_file}')
WHERE pipeline IN ('CSPBLDA', 'CSPGP', 'TSBLR', 'TSGP', 'BSCNN', 'BDCNN')
