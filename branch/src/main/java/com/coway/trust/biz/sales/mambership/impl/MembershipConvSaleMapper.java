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
@Mapper("membershipConvSaleMapper")
public interface MembershipConvSaleMapper {

	int  SAL0095D_insert(Map<String, Object> params);
	int  SAL0088D_insert(Map<String, Object> params);
	int  PAY0007D_insert(Map<String, Object> params);
	int  PAY0024D_insert(Map<String, Object> params);
	int  PAY0016D_insert(Map<String, Object> params);
	int  PAY0031D_insert(Map<String, Object> params);
	int  PAY0032D_insert(Map<String, Object> params);
	int  PAY0032DFilter_insert(Map<String, Object> params);



	int  getTaxRate(Map<String, Object> params);
	EgovMap  getHasBill(Map<String, Object> params);


	int update_SAL0090D_Stus(Map<String, Object> params);
	int update_SAL0093D_Stus(Map<String, Object> params);
	int PAY0031D_INVC_ITM_UPDATE(Map<String, Object> params);






	String getDocNo(Map<String, Object> params);
	EgovMap  getSAL0095D_SEQ(Map<String, Object> params);
	EgovMap  getSAL0001D_Data(Map<String, Object> params);
	EgovMap  getSAL0090D_Data(Map<String, Object> params);
	EgovMap  getSAL0093D_Data(Map<String, Object> params);

	List<EgovMap> getFilterListData(Map<String, Object> params);
	EgovMap getNewAddr(Map<String, Object> params);

	EgovMap getMembershipByRefNo(Map<String, Object> params);


	void updateEligibleEVoucher(Map<String, Object> params);

}
