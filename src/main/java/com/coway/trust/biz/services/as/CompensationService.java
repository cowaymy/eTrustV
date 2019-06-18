package com.coway.trust.biz.services.as;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 01/04/2019    ONGHC      1.0.1       - Restructure File
 * 18/06/2019    ONGHC      1.0.2       - Amend based on user request
 *********************************************************************************************/

public interface CompensationService {

  List<EgovMap> selCompensationList(Map<String, Object> params);

  public EgovMap selectCompenSationView(Map<String, Object> params);

  public EgovMap selectOrdInfo(Map<String, Object> params);

  EgovMap selectOrderBasicInfo(Map<String, Object> params, SessionVO sessionVO) throws Exception;

  EgovMap insertCompensation(Map<String, Object> params);

  EgovMap updateCompensation(Map<String, Object> params);

  List<EgovMap> selectSalesOrdNoInfo(Map<String, Object> params);

  List<EgovMap> selectBranchWithNM();

  List<EgovMap> getAttachmentFileInfo(Map<String, Object> params);

  List<EgovMap> selectCpsStatus();

  List<EgovMap> selectCpsTyp();

  List<EgovMap> selectCpsRespTyp();

  List<EgovMap> selectCpsCocTyp();

  List<EgovMap> selectCpsEvtTyp();

  List<EgovMap> selectCpsDftTyp(String stkCode);

  List<EgovMap> getMainDeptList();

  int chkCpsRcd(Map<String, Object> params);

}
