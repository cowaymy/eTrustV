/**
 *
 */
package com.coway.trust.biz.sales.mambership;

import java.util.List;


import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo
 *
 */
public interface MembershipService {

	/**
	 *
	 * @param params
	 * @return
	 */
	List<EgovMap> selectMembershipList(Map<String, Object> params);


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
	 * Membership Management - View  => order info tab
	 * @param params
	 * @return EgovMap
	 */
	EgovMap selectQuotInfo(Map<String, Object> params);


	/**
	 * get address  in orderinfo of tab
	 * @param params
	 * @return EgovMap
	 */
	EgovMap selectInstallAddr(Map<String, Object> params);

	List<EgovMap> selectTraceOrders(Map<String, Object> params);

	List<EgovMap>   selectMembershipQuotInfo(Map<String, Object> params);

	List<EgovMap>   selectMembershipQuotFilter(Map<String, Object> params);

	List<EgovMap>   selectMembershipViewLeader(Map<String, Object> params);

	List<EgovMap>   selectMembershipFreeConF(Map<String, Object> params);

	EgovMap selectMembershipFree_Basic(Map<String, Object> params);

	EgovMap selectMembershipFree_installation(Map<String, Object> params);

	EgovMap selectMembershipFree_srvconfig(Map<String, Object> params);

	List<EgovMap>   selectMembershipFree_oList(Map<String, Object> params);

	List<EgovMap>   selectMembershipFree_cPerson(Map<String, Object> params);

	List<EgovMap>   selectMembershipFree_bs(Map<String, Object> params);

	EgovMap   callOutOutsProcedure(Map<String, Object> params);

	List<EgovMap>   selectMembershipFree_Packg(Map<String, Object> params);

	List<EgovMap>   selectMembershipFree_PChange(Map<String, Object> params);

	int  membershipFree_save(Map<String, Object> params);

	void  srvConfigPeriod(Map<String, Object> params);

	EgovMap   getSAL0095d_SEQ(Map<String, Object> params);

	List<EgovMap>   selectMembershipContatList(Map<String, Object> params);

	int  membershipNewContatSave(Map<String, Object> params);

	int  membershipNewContatUpdate(Map<String, Object> params);

	List<EgovMap> getOGDCodeList(Map<String, Object> params);

	List<EgovMap> getBrnchCodeListByBrnchId(Map<String, Object> params);

	int updateMembershipById (Map<String, Object> params);

	EgovMap checkMembershipSalesPerson(Map<String, Object> params);

	EgovMap selectSvcExpire(Map<String, Object> params);

	EgovMap checkMembershipConfigurationSalesPerson(Map<String, Object> params);

}
