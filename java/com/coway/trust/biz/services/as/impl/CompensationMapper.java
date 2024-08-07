package com.coway.trust.biz.services.as.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 01/04/2019    ONGHC      1.0.1       - Restructure File
 * 18/06/2019    ONGHC      1.0.2       - Amend based on user request
 *********************************************************************************************/

@Mapper("CompensationMapper")
public interface CompensationMapper {

  List<EgovMap> selCompensationList(Map<String, Object> params);

  EgovMap selectCompenSationView(Map<String, Object> params);

  EgovMap selectOrdInfo(Map<String, Object> params);

  EgovMap selectBasicInfo(Map<String, Object> params);

  EgovMap selectLatestOrderLogByOrderID(Map<String, Object> params);

  EgovMap selectOrderAgreementByOrderID(Map<String, Object> params);

  EgovMap selectOrderInstallationInfoByOrderID(Map<String, Object> params);

  EgovMap selectOrderCCPFeedbackCodeByOrderID(Map<String, Object> params);

  EgovMap selectOrderCCPInfoByOrderID(Map<String, Object> params);

  EgovMap selectOrderSalesmanViewByOrderID(Map<String, Object> params);

  EgovMap selectOrderServiceMemberViewByOrderID(Map<String, Object> params);

  EgovMap selectOrderMailingInfoByOrderID(Map<String, Object> params);

  EgovMap selectOrderConfigInfo(Map<String, Object> params);

  EgovMap selectGSTCertInfo(Map<String, Object> params);

  String selectMemberInfo(String params);

  int insertCompensation(Map<String, Object> params);

  int updateCompensation(Map<String, Object> params);

  int chkCpsRcd(Map<String, Object> params);

  List<EgovMap> selectSalesOrdNoInfo(Map<String, Object> params);

  List<EgovMap> selectAttachmentFileInfo(Map<String, Object> params);

  List<EgovMap> selectBranchWithNM();

  List<EgovMap> selectCpsStatus();

  List<EgovMap> selectCpsTyp();

  List<EgovMap> selectCpsRespTyp();

  List<EgovMap> selectCpsCocTyp();

  List<EgovMap> selectCpsEvtTyp();

  List<EgovMap> selectCpsDftTyp(String stkCode);

  List<EgovMap> selectMainDept();
}
