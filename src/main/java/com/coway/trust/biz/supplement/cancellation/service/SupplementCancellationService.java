package com.coway.trust.biz.supplement.cancellation.service;

import java.io.IOException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;
import org.codehaus.jettison.json.JSONException;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SupplementCancellationService {

  List<EgovMap> selectSupRefStus();

  List<EgovMap> selectSupRefStg();

  List<EgovMap> selectSupRtnStus();

  List<EgovMap> selectSupDelStus();

  List<EgovMap> selectSupplementCancellationJsonList( Map<String, Object> params ) throws Exception;

  List<EgovMap> selectSupplementItmList( Map<String, Object> params ) throws Exception;

  EgovMap selectOrderBasicInfo( Map<String, Object> params ) throws Exception;

  List<EgovMap> checkDuplicatedTrackNo( Map<String, Object> params );

  Map<String, Object> updateRefStgStatus( Map<String, Object> params ) throws Exception;

  EgovMap selectOrderStockQty( Map<String, Object> params ) throws Exception;

  Map<String, Object> updateReturnGoodsQty( Map<String, Object> params ) throws Exception;

  EgovMap updOrdDelStatDhl( Map<String, Object> params ) throws IOException, JSONException, ParseException;

  List<EgovMap> getSupplementRtnItmDetailList( Map<String, Object> params ) throws Exception;

}
