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
package com.coway.trust.biz.payment.invoice.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("invoicePOMapper")
public interface InvoicePOMapper {
	/**
	 * InvoicePO Master 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectOrderBasicInfoByOrderId(Map<String, Object> params);


	List<EgovMap> selectHTOrderBasicInfoByOrderId(Map<String, Object> params);

	/**
	 * InvoicePO Data 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectOrderDataByOrderId(Map<String, Object> params);

	/**
	 * update Invoice Statement
	 * @param params
	 * @return
	 */
	int updateInvoiceStatement(Map<String, Object> params);

	/**
	 * InvoiceStatement 조회
	 * @param params
	 * @return
	 */
	List<EgovMap>selectInvoiceStatementByOrdId(Map<String, Object> params);

	/**
	 * InvoiceStatement 저장
	 * @param params
	 * @return
	 */
	void insertInvoicStatement(Map<String, Object> params);

    List<EgovMap>selectInvoiceStatementStart(Map<String, Object> params);

    List<EgovMap>selectInvoiceStatementEnd(Map<String, Object> params);

    String selectCustBillId(Map<String, Object> params);

    List<EgovMap> selectInvoiceBillGroupList(Map<String, Object> params);
}
