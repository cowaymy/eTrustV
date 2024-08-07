package com.coway.trust.biz.supplement.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

import com.coway.trust.biz.sales.order.vo.SupplementMasterVO;
import com.coway.trust.biz.sales.order.vo.SupplementDetailVO;

/*********************************************************************************************
 * DATE PIC VERSION COMMENT -------------------------------------------------------------------------------------------- 14/05/2024 TOMMY 1.0.1 - RE-STRUCTURE SupplementSubmissionMapper
 *
 *********************************************************************************************/

@Mapper("supplementSubmissionMapper")
public interface SupplementSubmissionMapper {

  List<EgovMap> selectSupplementSubmissionJsonList(Map<String, Object> params);

  List<EgovMap> selectSupplementSubmissionItmList(Map<String, Object> params);

  int selectExistSupplementSubmissionSofNo(Map<String, Object> params);

  List<EgovMap> selectSupplementItmList(Map<String, Object> params);

  List<EgovMap> chkSupplementStockList(Map<String, Object> params);

  EgovMap selectMemBrnchByMemberCode(Map<String, Object> params);

  EgovMap selectMemberByMemberIDCode(Map<String, Object> params);

  int getSeqSUP0003M();

  int getSeqSUP0004D();

  int selectNextFileId();

  int getSeqSUP0001M();

  int getSeqSUP0002D();

  void insertFileDetail(Map<String, Object> flInfo);

  void insertSupplementSubmissionMaster(Map<String, Object> params);

  void insertSupplementSubmissionDetail(Map<String, Object> params);

  List<EgovMap> selectAttachList(Map<String, Object> params);

  EgovMap selectSupplementSubmissionView(Map<String, Object> params);

  List<EgovMap> selectSupplementSubmissionItmView(Map<String, Object> params);

  void updateSupplementSubmissionStatus(Map<String, Object> params);

  void insertSupplementM(SupplementMasterVO supplementMasterVO);

  void insertSupplementD(SupplementDetailVO supplementDetailVO);

  Map<String, Object> SP_LOGISTIC_REQUEST_SUPP(Map<String, Object> param);

  EgovMap selectSupplementSubmItmList(Map<String, Object> params);

  void deleteSupplementM(Map<String, Object> params);

  void deleteSupplementD(Map<String, Object> params);

  EgovMap selectRequestNoBySupRefNo(Map<String, Object> params);

  void deleteStockBookingSMO(Map<String, Object> params);

  void updateStockTransferMReq(Map<String, Object> params);

  void updateStockTransferDReq(Map<String, Object> params);

}
