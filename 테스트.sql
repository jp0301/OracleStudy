
EXEC PRC_OPENSUB_INSERT('OPC006', 'SUB002', 'PRO001', 'BOK002', '2022-09-30', '2022-11-05', 15, 40, 45);
--OPENCOU 2022-09-12	2023-01-06
--OPENSUB 2022-09-12	2022-11-02

EXEC PRC_OPENSUB_UPDATE('OSJ003', '2022-11-12', '2022-12-10', 'OPC006', 'BOK002', 'SUB002', 20, 40, 40);

EXEC PRC_OPENSUB_DELETE('OSJ003');

