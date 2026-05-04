SELECT
    SUM(CASE WHEN score_auroc >= 0.4 AND score_auroc < 0.5 THEN 1 ELSE 0 END)
        AS bin_04_05,
    SUM(CASE WHEN score_auroc >= 0.5 AND score_auroc < 0.6 THEN 1 ELSE 0 END)
        AS bin_05_06,
    SUM(CASE WHEN score_auroc >= 0.6 AND score_auroc < 0.7 THEN 1 ELSE 0 END)
        AS bin_06_07,
    SUM(CASE WHEN score_auroc >= 0.7 AND score_auroc < 0.8 THEN 1 ELSE 0 END)
        AS bin_07_08,
    SUM(CASE WHEN score_auroc >= 0.8 AND score_auroc < 0.9 THEN 1 ELSE 0 END)
        AS bin_08_09
FROM READ_CSV_AUTO('{input_file}')
WHERE pipeline IN ('CSPBLDA', 'CSPGP', 'TSBLR', 'TSGP', 'BSCNN', 'BDCNN')
