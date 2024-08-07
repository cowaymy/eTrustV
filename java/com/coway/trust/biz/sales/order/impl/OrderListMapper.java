/*
 * Copyright 2011 MOPAS(Ministry of Public Administration and Security).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("orderListMapper")
public interface OrderListMapper {

  List<EgovMap> selectOrderList(Map<String, Object> params); // Referral Info

  List<EgovMap> getApplicationTypeList(Map<String, Object> params);

  List<EgovMap> getUserCodeList();

  List<EgovMap> getOrgCodeList(Map<String, Object> params);

  List<EgovMap> getGrpCodeList(Map<String, Object> params);

  EgovMap getMemberOrgInfo(Map<String, Object> params);

  List<EgovMap> getBankCodeList(Map<String, Object> params);

  List<EgovMap> getOderLdgr(Map<String, Object> params);

  EgovMap selectInstallParam(Map<String, Object> params);

  List<EgovMap> selectProductReturnView(Map<String, Object> params);

  EgovMap selectPReturnParam(Map<String, Object> params);

  int insert_LOG0039D(Map<String, Object> params);

  int updateState_LOG0038D(Map<String, Object> params);

  int insert_SAL0009D(Map<String, Object> params);

  int updateState_SAL0020D(Map<String, Object> params);

  int updateState_SAL0071D(Map<String, Object> params);

  void SP_RETURN_BILLING_EARLY_TERMI(Map<String, Object> params);

  int updateState_SAL0001D(Map<String, Object> params);

  String select_SeqCCR0006D(Map<String, Object> params);

  String select_SeqCCR0007D(Map<String, Object> params);

  void insert_CCR0006D(Map<String, Object> params);

  void insert_CCR0007D(Map<String, Object> params);

  int updateFailed_LOG0038D(Map<String, Object> params);

  void updateFailed_SAL0020D(Map<String, Object> params);

  int insertFailed_LOG0039D(Map<String, Object> params);

  EgovMap getPrCTInfo(Map<String, Object> params);

  int chkRcdTms(Map<String, Object> params);

  List<EgovMap> selectOrderListVRescue(Map<String, Object> params);

  EgovMap newSearchCancelSAL0001D(Map<String, Object> params);

  int chkSubPromo(Map<String, Object> params);

  int chkMainPromo(Map<String, Object> params);

  EgovMap revSubCboPckage(Map<String, Object> params);

  EgovMap revMainCboPckage(Map<String, Object> params);

  void insertSAL0254D(Map<String, Object> params);

	// KR HAN
//	void updateBarcodeChange(Map<String, Object> formMap);

  // KR_HAN : ADD
  void SP_RETURN_BILLING_EARLY_TERMI_SERIAL(Map<String, Object> params);

  // KR_HAN : ADD
  EgovMap selectOrderSerial(Map<String, Object> params);

  EgovMap selectDelvryNo(Map<String, Object> params);

  List<EgovMap> selectCboPckLinkOrdSub(Map<String, Object> params);

  List<EgovMap> selectCboPckLinkOrdSub2(Map<String, Object> params);


  List<EgovMap> getCustIdOfOrderList(Map<String, Object> params);

  List<EgovMap> selectOrderListCody(Map<String, Object> params);

  // 20210310 - LaiKW - Added 2 steps query before selectOrderList/selectOrderListCody
  List<EgovMap> getSirimOrdID(Map<String, Object> params);
  int getMemberID(Map<String, Object> params);

  int insert_SAL0299D(Map<String, Object> params);

	EgovMap selectPRFailReason(Map<String, Object> params);

	int selectCustBillId(Map<String, Object> params);

	List<EgovMap> getOderOutsInfo(Map<String, Object> params);

	EgovMap selectOrderId(Map<String, Object> params); // Basic Info

	EgovMap selectHeaderInfo(Map<String, Object> params);

	List<EgovMap> selectHistInfo(Map<String, Object> params);

	List<EgovMap> selectMatrixInfo(Map<String, Object> params);

	List<EgovMap> selectAccLinkInfo(Map<String, Object> params);
}
