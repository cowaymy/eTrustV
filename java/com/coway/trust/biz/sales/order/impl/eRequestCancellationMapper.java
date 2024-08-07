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

@Mapper("eRequestCancellationMapper")

public interface eRequestCancellationMapper {

	List<EgovMap> selectOrderList(Map<String, Object> params); //Referral Info

	EgovMap selectBasicInfo(Map<String, Object> params); //Basic Info

	EgovMap selectLatestOrderLogByOrderID(Map<String, Object> params); //Order Log View

	EgovMap selectOrderAgreementByOrderID(Map<String, Object> params); //Order Log View

	EgovMap selectOrderInstallationInfoByOrderID(Map<String, Object> params); //Installation Info

	EgovMap selectOrderCCPFeedbackCodeByOrderID(Map<String, Object> params); //CCP Feedback Code

	EgovMap selectOrderCCPInfoByOrderID(Map<String, Object> params); //CCP Remark

	EgovMap selectOrderSalesmanViewByOrderID(Map<String, Object> params); //Salesman Info

	EgovMap selectOrderServiceMemberViewByOrderID(Map<String, Object> params); //Cody Info

	EgovMap selectOrderMailingInfoByOrderID(Map<String, Object> params); //Cody Info

	EgovMap selectOrderConfigInfo(Map<String, Object> params); //Guarantee Info

	EgovMap selectGSTCertInfo(Map<String, Object> params); //Guarantee Info

	String selectMemberInfo(String params); //Member Info

	EgovMap selectOrderRentPaySetInfoByOrderID(Map<String, Object> params); //Cody Info

	EgovMap selectGuaranteeInfo(Map<String, Object> params); //Guarantee Info

	List<EgovMap> selectCallLogList(Map<String, Object> params); //Call Log

	int selectCcpDecisionMById(Map<String, Object> params);

	int selectECashDeductionItemById(Map<String, Object> params);

	int validRequestOCRStus(Map<String, Object> params);

	EgovMap cancelReqInfo(Map<String, Object> params);

	void updateCcpStatus(Map<String, Object> params); // CCP

	void insertReqEditOrdInfo(Map<String, Object> params);

	List<EgovMap> selectRequestApprovalList(Map<String, Object> params);

	int updateApprStus(Map<String, Object> params);

	int updSAL0001D_instAddr(Map<String, Object> params);

	int updSAL0045D(Map<String, Object> params);

	int updSAL0001D_custCntc(Map<String, Object> params);


}
