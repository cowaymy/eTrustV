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
package com.coway.trust.biz.homecare.sales.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.SalesReqCancelVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * sample에 관한 데이터처리 매퍼 클래스
 *
 * @author 표준프레임워크센터
 * @since 2014.01.24
 * @version 1.0
 * @see
 *
 *      <pre>
 *  == 개정이력(Modification Information) ==
 *
 *          수정일          수정자           수정내용
 *  ----------------    ------------    ---------------------------
 *   2014.01.24        표준프레임워크센터          최초 생성
 *
 *      </pre>
 */
@Mapper("htOrderDetailMapper")
public interface htOrderDetailMapper {

	EgovMap selectBasicInfo(Map<String, Object> params); //Basic Info

	EgovMap selectLatestOrderLogByOrderID(Map<String, Object> params); //Order Log View

	EgovMap selectOrderAgreementByOrderID(Map<String, Object> params); //Order Log View

	EgovMap selectOrderInstallationInfoByOrderID(Map<String, Object> params); //Installation Info

	List<EgovMap> selectOrderReferralInfoList(Map<String, Object> params); //Referral Info

	List<EgovMap> selectCallLogList(Map<String, Object> params); //Call Log

	List<EgovMap> selectPaymentMasterList(Map<String, Object> params); //Payment Listing

	List<EgovMap> selectAutoDebitResultList(Map<String, Object> params); //Auto Debit Result

	EgovMap selectOrderCCPFeedbackCodeByOrderID(Map<String, Object> params); //CCP Feedback Code

	EgovMap selectOrderCCPInfoByOrderID(Map<String, Object> params); //CCP Remark

	EgovMap selectOrderSalesmanViewByOrderID(Map<String, Object> params); //Salesman Info

	EgovMap selectOrderServiceMemberViewByOrderID(Map<String, Object> params); //Cody Info

	List<EgovMap> selectOrderSameRentalGroupOrderList(Map<String, Object> params); //Auto Debit Result

	EgovMap selectOrderMailingInfoByOrderID(Map<String, Object> params); //Cody Info

	EgovMap selectOrderRentPaySetInfoByOrderID(Map<String, Object> params); //Cody Info

	EgovMap selectThirdPartyInfo(Map<String, Object> params); //Cody Info

	List<EgovMap> selectMembershipInfoList(Map<String, Object> params); //Membership Info Result

	List<EgovMap> selectDocumentList(Map<String, Object> params); //Document Result

	EgovMap selectGuaranteeInfo(Map<String, Object> params); //Guarantee Info

	List<EgovMap> selectAutoDebitList(Map<String, Object> params); //Auto Debit Result

	List<EgovMap> selectEcashList(Map<String, Object> params); //eCash Result

	List<EgovMap> selectDiscountList(Map<String, Object> params); //Discount

	EgovMap selectOrderConfigInfo(Map<String, Object> params); //Guarantee Info

	EgovMap selectGSTCertInfo(Map<String, Object> params); //Guarantee Info

	String selectMemberInfo(String params); //Member Info

	List<EgovMap> selectLast6MonthTransList(Map<String, Object> params); //Last 6 Months Transaction

	List<EgovMap> selectLast6MonthTransListNew(Map<String, Object> params); //Last 6 Months Transaction

	EgovMap selectCurrentBSResultByBSNo(Map<String, Object> params); //Guarantee Info

	List<EgovMap> selectASInfoList(Map<String, Object> params); //Last 6 Months Transaction

	List<EgovMap> selectCovrgAreaList(Map<String, Object> params);

	EgovMap getHTCovrgAreaList(Map<String, Object> params);

	void updateCovrgAreaStatus(Map<String, Object> params);

	List<EgovMap> selectCovrgAreaListByGrp(Map<String, Object> params);

	int  updateCoverageAreaActive(Map<String, Object> params);

	int  updateCoverageAreaInactive(Map<String, Object> params);

	int  updateCSOrderStatus(Map<String, Object> params);

	List<EgovMap> selectResnCodeList(Map<String, Object> params);

	void insertCSReqCancel(Map<String, Object> params);

	void updateCSMembershipStatus(Map<String, Object> params);

    List<EgovMap> selectHcAcBulkOrderDtlList(Map<String, Object> params);
}
