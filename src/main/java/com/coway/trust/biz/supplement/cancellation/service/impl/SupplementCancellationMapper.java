package com.coway.trust.biz.supplement.cancellation.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("supplementCancellationMapper")
public interface SupplementCancellationMapper {
  List<EgovMap> selectSupRefStus();

  List<EgovMap> selectSupRefStg();

  List<EgovMap> selectSupRtnStus();

  List<EgovMap> selectSupplementCancellationJsonList( Map<String, Object> params );

  List<EgovMap> selectSupplementItmList( Map<String, Object> params );

  EgovMap selectOrderBasicInfo( Map<String, Object> params );

  List<EgovMap> checkDuplicatedTrackNo( Map<String, Object> params );

  int updateRefStgStatus( Map<String, Object> params );

  int rollbackRefStgStatus( Map<String, Object> params );

  Map<String, Object> getCustomerInfo( Map<String, Object> params );

  List<EgovMap> selectSupDelStus();
}
