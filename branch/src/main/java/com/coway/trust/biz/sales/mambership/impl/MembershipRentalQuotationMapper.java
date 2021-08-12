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
@Mapper("membershipRentalQuotationMapper")
public interface MembershipRentalQuotationMapper {
	
	List<EgovMap>   quotationList(Map<String, Object> params);
	List<EgovMap>   newConfirm(Map<String, Object> params);
	List<EgovMap>   selCheckExpService(Map<String, Object> params);
	
	

	
	List<EgovMap>   newOListuotationList(Map<String, Object> params);
	EgovMap    newGetExpDate(Map<String, Object> params);
	List<EgovMap>   getSrvMemCode(Map<String, Object> params);
	EgovMap    mPackageInfo(Map<String, Object> params);
	List<EgovMap>   getPromotionCode(Map<String, Object> params);
	EgovMap 	  getFilterCharge(Map<String, Object> params);
	
	List<EgovMap>   getFilterPromotionCode(Map<String, Object> params);
	List<EgovMap>   getPromoPricePercent(Map<String, Object> params);
	
	List<EgovMap>   getOrderCurrentBillMonth(Map<String, Object> params);
	
	EgovMap  getOderOutsInfo(Map<String, Object> params)	;
	
	List<EgovMap>   getFilterChargeList(Map<String, Object> params);
	
	List<EgovMap>   getFilterChargeListSum(Map<String, Object> params);
	
	EgovMap  getFilterPromotionAmt(Map<String, Object> params);
	 
	 
	void  insertQuotationInfo(Map<String, Object> params);
	 
	EgovMap  getMembershipFilterChargeList(Map<String, Object> params);
	
	void  insertSrvMembershipQuot_Filter(Map<String, Object> params); 

	EgovMap   getSAL0083D_SEQ(Map<String, Object> params);
	EgovMap   getSAL0083D_DocNo(Map<String, Object> params);
	
	
	List<EgovMap>   mActiveQuoOrder(Map<String, Object> params);
	
	List<EgovMap>   selectSrchMembershipQuotationPop(Map<String, Object> params);
	
	EgovMap cnvrToSalesOrderInfo(Map<String, Object> params);
	
	EgovMap cnvrToSalesAddrInfo(Map<String, Object> params);
	
	EgovMap cnvrToSalesCntcInfo(Map<String, Object> params);
	
	List<EgovMap> cnvrToSalesfilterChgList(Map<String, Object> params);
	
	EgovMap cnvrToSalesPackageInfo(Map<String, Object> params);
	
	EgovMap cnvrToSalesOrderInfo2nd(Map<String, Object> params);
	
	EgovMap cnvrToSalesThrdParty(Map<String, Object> params);
	
	int getSrvCntrctIdSeq();
	
	int getCntrctIdSeq();
	
	int getCnfmIdSeq();
	
	int getSrvPaySchdulIdSeq();
	
	int getSrvPrdIdSeq();
	
	void insertSrvContract(Map<String, Object> params);
	
	void insertSrvContractSub(Map<String, Object> params);
	
	int serviceCntractQotatCnt(Map<String, Object> params);
	
	void updateSAL0083D(Map<String, Object> params);
	
	void insertSrvPaySchdul(Map<String, Object> params);
	
	EgovMap cnvrToSalesSrvConfigur(Map<String, Object> params);
	
	void insertSrvConfigPeriod(Map<String, Object> params);
	
	void insertSrvCntrctConfirm(Map<String, Object> params);
	
	void insertAccInvoicePo(Map<String, Object> params);
	
	void insertRentPaySet(Map<String, Object> params);
	
	void insertAccClaimAdt(Map<String, Object> params);
	
	void updateSAL0090D(Map<String, Object> params);
	
	void spInstRscRentalBill(Map<String, Object> params);
	int selectGSTZeroRateLocation(Map<String, Object> params);
	int selectGSTEURCertificate(Map<String, Object> params);
}
