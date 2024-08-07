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
@Mapper("membershipMapper")
public interface MembershipMapper {

	List<EgovMap> selectMembershipList(Map<String, Object> params); //Referral Info


	/**
	 * Membership Management - View  => membership info tab
	 * @param params
	 * @return EgovMap
	 */
	EgovMap selectMembershipInfoTab(Map<String, Object> params);


	/**
	 * Membership Management - View  => order info tab
	 * @param params
	 * @return EgovMap
	 */
	EgovMap selectOderInfoTab(Map<String, Object> params);


	/**
	 * get address  in orderinfo of tab
	 * @param params
	 * @return EgovMap
	 */
	 EgovMap selectInstallAddr(Map<String, Object> params);

	 /**
	 * get address  in selectQuotInfo of tab
	 * @param params
	 * @return EgovMap
	 */
	 EgovMap selectQuotInfo(Map<String, Object> params);


	 List<EgovMap>  selectTraceOrders(Map<String, Object> params);


	/**
	 *
	 * @param params
	 * @return
	 */
	 List<EgovMap>  selectMembershipQuotInfo(Map<String, Object> params);

	/**
	 *
	 * @param params
	 * @return
	 */
	 List<EgovMap>  selectMembershipQuotFilter(Map<String, Object> params);

    /**
     *
     * @param params
     * @return
     */
	 List<EgovMap>  selectMembershipViewLeader(Map<String, Object> params);

    /**
     *
     * @param params
     * @return
     */
	 List<EgovMap>  selectMembershipFreeConF(Map<String, Object> params);

	/**
	 * membershipFree
	 * @param params
	 * @return EgovMap
	 */
	EgovMap selectMembershipFree_Basic(Map<String, Object> params);


	/**
	 * membershipFree
	 * @param params
	 * @return EgovMap
	 */
	EgovMap selectMembershipFree_installation(Map<String, Object> params);


	/**
	 * membershipFree
	 * @param params
	 * @return EgovMap
	 */
	EgovMap selectMembershipFree_srvconfig(Map<String, Object> params);

	List<EgovMap>  selectMembershipFree_oList(Map<String, Object> params);

	List<EgovMap>  selectMembershipFree_cPerson(Map<String, Object> params);

	List<EgovMap>  selectMembershipFree_bs(Map<String, Object> params);

	EgovMap callOutOutsProcedure(Map<String, Object> params);

	List<EgovMap>  selectMembershipFree_Packg(Map<String, Object> params);

	List<EgovMap>  selectMembershipFree_PChange(Map<String, Object> params);

	int  membershipFree_save(Map<String, Object> params);

	void srvConfigPeriod(Map<String, Object> params);

	EgovMap getSAL0095d_SEQ(Map<String, Object> params);

	List<EgovMap>  selectMembershipContatList(Map<String, Object> params);

	int  membershipNewContatSave(Map<String, Object> params);

	int  membershipNewContatUpdate(Map<String, Object> params);

	List<EgovMap> getOGDCodeList(Map<String, Object> params);

	List<EgovMap> getBrnchCodeListByBrnchId(Map<String, Object> params);

	int updateMembershipById(Map<String, Object> params);

	EgovMap selectSalesPerson(Map<String, Object> params);

	EgovMap selectConfigurationSalesPerson(Map<String, Object> params);

	EgovMap selectSvcExpire(Map<String, Object> params);
}
