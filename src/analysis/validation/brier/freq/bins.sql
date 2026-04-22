SELECT
    SUM(CASE WHEN score_brier >= 0.16 AND score_brier < 0.19 THEN 1 ELSE 0 END) AS bin_016_019,
    SUM(CASE WHEN score_brier >= 0.19 AND score_brier < 0.22 THEN 1 ELSE 0 END) AS bin_019_021,
    SUM(CASE WHEN score_brier >= 0.22 AND score_brier < 0.25 THEN 1 ELSE 0 END) AS bin_021_025,
    SUM(CASE WHEN score_brier >= 0.25 AND score_brier < 0.28 THEN 1 ELSE 0 END) AS bin_025_028,
    SUM(CASE WHEN score_brier >= 0.28 AND score_brier < 0.31 THEN 1 ELSE 0 END) AS bin_028_031,
    SUM(CASE WHEN score_brier >= 0.31 AND score_brier < 0.34 THEN 1 ELSE 0 END) AS bin_031_034
FROM read_csv_auto('{input_file}')
WHERE pipeline IN ('CSPLDA', 'CSPSVM', 'TSLR', 'TSSVM', 'SCNN', 'DCNN')
