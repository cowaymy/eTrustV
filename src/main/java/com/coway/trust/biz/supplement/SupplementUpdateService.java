package com.coway.trust.biz.supplement;

import java.io.IOException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;
import org.codehaus.jettison.json.JSONException;

import com.fasterxml.jackson.core.JsonProcessingException;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SupplementUpdateService {
  List<EgovMap> selectSupplementList( Map<String, Object> params )
    throws Exception;

  List<EgovMap> selectSupRefStus();

  List<EgovMap> selectSupRefStg();

  List<EgovMap> selectSupDelStus();

  List<EgovMap> selectSubmBrch();

  List<EgovMap> selectWhBrnchList() throws Exception;

  List<EgovMap> getSupplementDetailList( Map<String, Object> params ) throws Exception;

  List<EgovMap> getDelRcdLst( Map<String, Object> params ) throws Exception;

  List<EgovMap> getRtnItmRcdLst( Map<String, Object> params ) throws Exception;

  List<EgovMap> selectPosJsonList( Map<String, Object> params ) throws Exception;

  List<EgovMap> checkDuplicatedTrackNo( Map<String, Object> params );

  EgovMap selectOrderBasicInfo( Map<String, Object> params ) throws Exception;

  EgovMap selectCancDelInfo( Map<String, Object> params ) throws Exception;

  Map<String, Object> updateRefStgStatus( Map<String, Object> params ) throws Exception;

  EgovMap updOrdDelStatGdex( Map<String, Object> params ) throws IOException, JSONException, ParseException;

  EgovMap updOrdDelStatDhl( Map<String, Object> params ) throws IOException, JSONException, ParseException;

  EgovMap getStoSup( Map<String, Object> params );

  Map<String, Object> SP_STO_PRE_SUPP( Map<String, Object> param );

  void sendEmail( Map<String, Object> params );

  public List<EgovMap> selectDocumentList( Map<String, Object> params );

  List<EgovMap> selectPaymentMasterList( Map<String, Object> params );

  EgovMap selectOrderBasicLedgerInfo( Map<String, Object> params );

  List<EgovMap> getOderLdgr( Map<String, Object> params );

  List<EgovMap> getOderOutsInfo( Map<String, Object> params );

  List<EgovMap> getCustOrdDelInfo( Map<String, Object> params );

  Map<String, Object> updateDelStageInfo( Map<String, Object> params ) throws JsonProcessingException, IOException;

}
