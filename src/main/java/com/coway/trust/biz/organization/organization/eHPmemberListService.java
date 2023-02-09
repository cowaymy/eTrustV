package com.coway.trust.biz.organization.organization;


import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface eHPmemberListService {

  List<EgovMap> getAttachList(Map<String, Object> params);

  List<EgovMap> selectEHPMemberList(Map<String, Object> params);

  List<EgovMap> selectEHPApplicantList(Map<String, Object> params);

  String saveEHPMember(Map<String, Object> params, SessionVO sessionVO );

  void eHPmemberStatusInsert(Map<String, Object> params);

  void eHPmemberStatusUpdate(Map<String, Object> params);

  void eHPApplicantStatusUpdate(Map<String, Object> params);

  void eHPMemberUpdate(Map<String, Object> params) throws Exception;

  EgovMap selectEHPmemberListView(Map<String, Object> params);

  List<EgovMap> selectEHPmemberView(Map<String, Object> params);

  List<EgovMap> selectCollectBranch();

  List<EgovMap> eHPselectStatus();

  EgovMap selectEHPMemberListView(Map<String, Object> params);

  List<EgovMap> getDetailCommonCodeList(Map<String, Object> params);

  List<EgovMap> selectHPOrientation(Map<String, Object> params);

  List<EgovMap> selectHpApplByEmail(Map<String, Object> params);

  List<EgovMap> selecteHPFailRemark(Map<String, Object> params);

  List<EgovMap> getMemberExistByNRIC(Map<String, Object> params);
}
