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
package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;

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
@Mapper("membershipQuotationMapper")
public interface MembershipQuotationMapper {

  List<EgovMap> quotationList(Map<String, Object> params);

  List<EgovMap> newOListuotationList(Map<String, Object> params);

  EgovMap newGetExpDate(Map<String, Object> params);

  List<EgovMap> getSrvMemCode(Map<String, Object> params);

  EgovMap mPackageInfo(Map<String, Object> params);

  List<EgovMap> getPromotionCode(Map<String, Object> params);

  EgovMap getFilterCharge(Map<String, Object> params);

  List<EgovMap> getFilterPromotionCode(Map<String, Object> params);

  List<EgovMap> getPromoPricePercent(Map<String, Object> params);

  List<EgovMap> getOrderCurrentBillMonth(Map<String, Object> params);

  List<EgovMap> getFilterChargeList(Map<String, Object> params);

  List<EgovMap> getFilterChargeListSum(Map<String, Object> params);

  EgovMap getOderOutsInfo(Map<String, Object> params);

  EgovMap getOutrightMemLedge(Map<String, Object> params);

  EgovMap getFilterPromotionAmt(Map<String, Object> params);

  void insertQuotationInfo(Map<String, Object> params);

  EgovMap getMembershipFilterChargeList(Map<String, Object> params);

  void insertSrvMembershipQuot_Filter(Map<String, Object> params);

  EgovMap getSAL0093D_SEQ(Map<String, Object> params);

  EgovMap mSubscriptionEligbility(Map<String, Object> params);

  EgovMap getSVMConfig(Map<String, Object> params);

  EgovMap getSalesOrderLastExpiredDate(Map<String, Object> params);

  EgovMap getServicePacIdExist(Map<String, Object> params);

  List<EgovMap> mActiveQuoOrder(Map<String, Object> params);

  List<EgovMap> selectSrchMembershipQuotationPop(Map<String, Object> params);

  EgovMap getEntryDocNo(Map<String, Object> params);

  void update_SAL0093D_Stus(Map<String, Object> params);

  EgovMap getMaxPeriodEarlyBirdPromo(Map<String, Object> params);

  List<EgovMap> mEligibleEVoucher(Map<String, Object> params);

  List<EgovMap> getPromoDetails(Map<String, Object> params);

}
