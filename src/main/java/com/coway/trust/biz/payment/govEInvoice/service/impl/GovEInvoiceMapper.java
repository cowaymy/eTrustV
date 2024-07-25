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
package com.coway.trust.biz.payment.govEInvoice.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("govEInvoiceMapper")
public interface GovEInvoiceMapper {
	List<EgovMap> selectGovEInvoiceList(Map<String, Object> params);

	EgovMap selectGovEInvoiceMain(Map<String, Object> params);

	List<EgovMap> selectEInvStat(Map<String, Object> params);

	List<EgovMap> selectEInvCommonCode(Map<String, Object> params);

	List<EgovMap> selectGovEInvoiceDetail(Map<String, Object> params);

	Map<String, Object> createEInvClaim(Map<String, Object> param);

	Map<String, Object> createEInvClaimDaily(Map<String, Object> param);

	int saveEInvBatchMain(Map<String, Object> params);

	int saveEInvDeactivateBatchEInv(Map<String, Object> params);

	int saveEInvConfirmBatch(Map<String, Object> params);

	int selectInvoiceGroupIdSeq();

	List<Map<String, Object>> selectEInvSendList(Map<String, Object> params);

	List<Map<String, Object>> selectEInvLineSendList(Map<String, Object> params);

	int updEInvJsonString(Map<String, Object> params);

	int selectApiInvoiceSeq();

	void insertApiAccessLog(Map<String, Object> params);

	int insertApiDetailAccessLog(Map<String, Object> params);

	void updateEInvMain(Map<String, Object> formMap);

	int updEInvByDocId(Map<String, Object> params);
}
