package com.coway.trust.biz.organization.organization.impl;
import java.util.List;
import java.util.Map;

//import com.coway.trust.biz.organization.organization.vo.DocSubmissionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("eHPmemberListMapper")
public interface eHPmemberListMapper {

  EgovMap selectDocNo(String code);

  void updateDocNo(Map<String, Object> params);

  String selectMemberId( Map<String, Object> params);

  List<EgovMap> selectAttachList(Map<String, Object> params);

  int selectNextFileId();

  void insertFileDetail(Map<String, Object> flInfo);

  List<EgovMap> selectEHPMemberList(Map<String, Object> params);

  List<EgovMap> selectEHPApplicantList(Map<String, Object> params);

  String saveEHPMember(Map<String, Object> params) ;

  void eHPmemberStatusInsert(Map<String, Object> params) ;

  void eHPmemberStatusUpdate(Map<String, Object> params) ;

  void eHPApplicantStatusUpdate(Map<String, Object> params) ;

  void insertEHPMemApp(Map<String, Object> params);

  void eHPMemberUpdate(Map<String, Object> params) throws Exception;

  EgovMap selectEHPmemberListView(Map<String, Object> params);

  List<EgovMap> selectEHPmemberView(Map<String, Object> params);

  List<EgovMap>selectCollectBranch();

  List<EgovMap> eHPselectStatus();

  EgovMap getEHPMemberListView(Map<String, Object> params);

  List<EgovMap> getDetailCommonCodeList(Map<String, Object> params);

  List<EgovMap> selectHPOrientation(Map<String, Object> params);

  List<EgovMap> selectHpApplByEmail(Map<String, Object> params);

  List<EgovMap> selecteHPFailRemark(Map<String, Object> params);

  List<EgovMap> getMemberExistByNRIC(Map<String, Object> params);

}
