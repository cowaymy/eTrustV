package com.coway.trust.biz.supplement.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("supplementUpdateMapper")
public interface SupplementUpdateMapper {
  List<EgovMap> selectSupplementList( Map<String, Object> params );

  List<EgovMap> selectPosJsonList( Map<String, Object> params );

  List<EgovMap> selectSupRefStus();

  List<EgovMap> selectSupRefStg();

  List<EgovMap> selectSupDelStus();

  List<EgovMap> selectSubmBrch();

  List<EgovMap> selectWhBrnchList();

  List<EgovMap> getSupplementDetailList( Map<String, Object> params );

  List<EgovMap> getDelRcdLst( Map<String, Object> params );

  List<EgovMap> getRtnItmRcdLst( Map<String, Object> params );

  EgovMap selectOrderBasicInfo( Map<String, Object> params );

  EgovMap selectCancDelInfo( Map<String, Object> params );

  List<EgovMap> checkDuplicatedTrackNo( Map<String, Object> params );

  int updateRefStgStatus( Map<String, Object> params );

  int rollbackRefStgStatus( Map<String, Object> params );

  int updOrdDelStat( Map<String, Object> params );

  int updOrdDelDhlStat( Map<String, Object> params );

  Map<String, Object> getCustEmailDtl( Map<String, Object> params );

  Map<String, Object> getOrdInfo( Map<String, Object> params );

  int getWhLocId( String params );

  void updateDelLstDtl( Map<String, Object> params );

  void insertDelLstDtl( Map<String, Object> params );

  EgovMap getStoSup( Map<String, Object> params );

  Map<String, Object> SP_STO_PRE_SUPP( Map<String, Object> param );

  void revertStgStus( Map<String, Object> params );

  List<EgovMap> selectDocumentList( Map<String, Object> params );

  List<EgovMap> selectPaymentMasterList( Map<String, Object> params );

  EgovMap selectOrderBasicLedgerInfo( Map<String, Object> params );

  List<EgovMap> getOderLdgr( Map<String, Object> params );

  List<EgovMap> getOderOutsInfo( Map<String, Object> params );

  List<EgovMap> getCustOrdDelInfoPdo( Map<String, Object> params );

  List<EgovMap> getCustOrdDelInfoPdr( Map<String, Object> params );

  Map<String, Object> getOrdInfoPdo( Map<String, Object> param );

  Map<String, Object> getOrdInfoPdr( Map<String, Object> param );

  Map<String, Object> SP_LOGISTIC_REQUEST_SUPP( Map<String, Object> param );

  List<EgovMap> selectSupplementDailyOrderReportList( Map<String, Object> params );
}
