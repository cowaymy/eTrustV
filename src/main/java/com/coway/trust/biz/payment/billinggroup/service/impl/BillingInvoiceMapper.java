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
package com.coway.trust.biz.payment.billinggroup.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("billingInvoiceMapper")
public interface BillingInvoiceMapper {
	/**
	 * CompanyList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectCompanyInvoiceList(Map<String, Object> params);

	/**
	 * RentalStatement List 조회
	 * @param params
	 * @return
	 */
	List<EgovMap>selectRentalStatementList(Map<String, Object> params);

	/**
	 * MembershipInvoice List 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectMembershipInvoiceList(Map<String, Object> params);

	/**
	 * OutrightInvoice List 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectOutrightInvoiceList(Map<String, Object> params);

	/**
	 * CompanyStatement List 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectCompanyStatementList(Map<String, Object> params);

	/**
	 * ProformaInvoice List 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectProformaInvoiceList(Map<String, Object> params);

	/**
	 * AdvancedRentalInvoice List 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectAdvancedRentalInvoiceList(Map<String, Object> params);
	List<EgovMap> selectProductUsageMonth(Map<String, Object> params);
	List<EgovMap> selectProductBasicInfo(Map<String, Object> params);


	/**
	 * Penalty Invoice Bill Date 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectPenaltyBillDate(Map<String, Object> params);

	/**
	 * Outright Invoice List Count 조회
	 * @param params
	 * @return
	 */
	int selectOutrightInvoiceListCount(Map<String, Object> params);


	/**
	 * Summary Invoice List 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> searchSummaryInvoiceList(Map<String, Object> params);

	/**
	 * Summary Account List 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> searchSummaryAccountList(Map<String, Object> params);



}
