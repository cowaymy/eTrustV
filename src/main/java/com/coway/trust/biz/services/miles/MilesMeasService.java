package com.coway.trust.biz.services.miles;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 15/08/2023    ONGHC      1.0.1          - INITIAL MilesMeasService
 *********************************************************************************************/

public interface MilesMeasService {

  List<EgovMap> getMilesMeasMasterList(Map<String, Object> params);

  List<EgovMap> getMilesMeasList(Map<String, Object> params);

  List<EgovMap> getMilesMeasDetailList(Map<String, Object> params);

  List<EgovMap> getMilesMeasRaw(Map<String, Object> params);

  List<EgovMap> selectSrvStat();

  List<EgovMap> selectSrvFailInst();

}
