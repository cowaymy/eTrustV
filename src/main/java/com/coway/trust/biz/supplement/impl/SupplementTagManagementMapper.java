package com.coway.trust.biz.supplement.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("supplementTagManagementMapper")
public interface SupplementTagManagementMapper {

  List<EgovMap> selectTagManagementList( Map<String, Object> params );

  List<EgovMap> selectTagStus();

  List<EgovMap> getMainTopicList();

  List<EgovMap> getInchgDeptList();

  List<EgovMap> getSubTopicList(Map<String, Object> params);

  List<EgovMap> getSubDeptList(Map<String, Object> params);

  EgovMap selectOrderBasicInfo(Map<String, Object> params);

  List<EgovMap> searchOrderBasicInfo(Map<String, Object> params);

  EgovMap selectViewBasicInfo(Map<String, Object> params);

  String getDocNo (int value);

  List<EgovMap> getResponseLst( Map<String, Object> params );

  void insertFileDetail(Map<String, Object> flInfo);

  int selectNextFileId();

  int getSeqSUP0006M();

  int getSeqCCR0006D();

  int getSeqCCR0007D();

  int getSeqSUP0007M();

  void insertSupplementTagMaster(Map<String, Object> params);

  void insertCCRMain(Map<String, Object> params);

  void insertCcrDetail(Map<String, Object> params);

  int insertTagCcrDetail( Map<String, Object> params );

  void updateCcrMain(Map<String, Object> params);

  void updateSupHqAttch(Map<String, Object> params);

  int insertCancMain( Map<String, Object> params );

  void updateCcrMainWithCid (Map<String, Object> params);

  public List<EgovMap> selectAttachListCareline(Map<String, Object> params);

  public List<EgovMap> selectAttachListHq(Map<String, Object> params);

  Map<String, Object> getCustEmailDtl( Map<String, Object> params );

}
