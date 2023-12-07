/**
 *
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.util.ArrayList;
import java.util.List;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.sales.mambership.MembershipService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo
 *
 */
@Service("membershipService")
public class MembershipServiceImpl extends EgovAbstractServiceImpl implements MembershipService {

//	private static Logger logger = LoggerFactory.getLogger(OrderListServiceImpl.class);

	@Resource(name = "membershipMapper")
	private MembershipMapper membershipMapper;

	//@Autowired
	//private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "commonMapper")
	private CommonMapper commonMapper;

	@Override
	public List<EgovMap> selectMembershipList(Map<String, Object> params) {
		return membershipMapper.selectMembershipList(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#selectOderInfoTab(java.util.Map)
	 */
	@Override
	public EgovMap selectMembershipInfoTab(Map<String, Object> params) {
		return membershipMapper.selectMembershipInfoTab(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#selectOderInfoTab(java.util.Map)
	 */
	@Override
	public  EgovMap selectOderInfoTab(Map<String, Object> params) {
		return membershipMapper.selectOderInfoTab(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#selectQuotInfo(java.util.Map)
	 */
	@Override
	public  EgovMap selectQuotInfo(Map<String, Object> params) {
		return membershipMapper.selectQuotInfo(params);
	}



	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#selectInstallAddr(java.util.Map)
	 */
	@Override
	public EgovMap  selectInstallAddr(Map<String, Object> params) {
		return membershipMapper.selectInstallAddr(params);
	}

	@Override
	public List<EgovMap> selectTraceOrders(Map<String, Object> params) {
		return membershipMapper.selectTraceOrders(params);
	}


    /*
     * (non-Javadoc)
     * @see com.coway.trust.biz.sales.mambership.MembershipService#selectMembershipQuotInfo(java.util.Map)
     */
	@Override
	public List<EgovMap>    selectMembershipQuotInfo(Map<String, Object> params) {
		return membershipMapper.selectMembershipQuotInfo(params);
	}
	/*
     * (non-Javadoc)
     * @see com.coway.trust.biz.sales.mambership.MembershipService#selectMembershipQuotInfo(java.util.Map)
     */
	@Override
	public List<EgovMap>    selectMembershipQuotFilter(Map<String, Object> params) {
		return membershipMapper.selectMembershipQuotFilter(params);
	}


	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#selectMembershipViewLeader(java.util.Map)
	 */
	@Override
	public List<EgovMap>    selectMembershipViewLeader(Map<String, Object> params) {

		List<EgovMap> resultList = new ArrayList<EgovMap>();

		resultList = membershipMapper.selectMembershipViewLeader(params);

		double c7 = 0.00;

		for(EgovMap result : resultList){

			c7  += Float.parseFloat(result.get("c4").toString()) - Float.parseFloat(result.get("c5").toString());

			result.put("c7" , String.format("%.2f", c7));

		}


		 return resultList;
	}


	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#selectMembershipFreeConF(java.util.Map)
	 */
	@Override
	public List<EgovMap>    selectMembershipFreeConF(Map<String, Object> params) {
		return membershipMapper.selectMembershipFreeConF(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#selectMembershipFree_Basic(java.util.Map)
	 */
	@Override
	public EgovMap selectMembershipFree_Basic(Map<String, Object> params) {
		return membershipMapper.selectMembershipFree_Basic(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#selectMembershipFree_installation(java.util.Map)
	 */
	@Override
	public EgovMap selectMembershipFree_installation(Map<String, Object> params) {
		return membershipMapper.selectMembershipFree_installation(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#selectMembershipFree_srvconfig(java.util.Map)
	 */
	@Override
	public EgovMap selectMembershipFree_srvconfig(Map<String, Object> params) {
		return membershipMapper.selectMembershipFree_srvconfig(params);
	}



	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#selectMembershipViewLeader(java.util.Map)
	 */
	@Override
	public List<EgovMap>    selectMembershipFree_bs(Map<String, Object> params) {
		return membershipMapper.selectMembershipFree_bs(params);
	}
	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#selectMembershipViewLeader(java.util.Map)
	 */
	@Override
	public List<EgovMap>    selectMembershipFree_oList(Map<String, Object> params) {
		return membershipMapper.selectMembershipFree_oList(params);
	}
	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#selectMembershipViewLeader(java.util.Map)
	 */
	@Override
	public List<EgovMap>    selectMembershipFree_cPerson(Map<String, Object> params) {
		return membershipMapper.selectMembershipFree_cPerson(params);
	}



	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#callOutOutsProcedure(java.util.Map)
	 */
	@Override
	public EgovMap callOutOutsProcedure(Map<String, Object> params) {
		return membershipMapper.callOutOutsProcedure(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#selectMembershipFree_Packg(java.util.Map)
	 */
	@Override
	public List<EgovMap>    selectMembershipFree_Packg(Map<String, Object> params) {
		return membershipMapper.selectMembershipFree_Packg(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#selectMembershipFree_PChange(java.util.Map)
	 */
	@Override
	public List<EgovMap>    selectMembershipFree_PChange(Map<String, Object> params) {
		return membershipMapper.selectMembershipFree_PChange(params);
	}


	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#selectMembershipFree_save(java.util.Map)
	 */
	@Override
	public int  membershipFree_save(Map<String, Object> params) {

		EgovMap     seq = membershipMapper.getSAL0095d_SEQ(params);
		params.put("SAVE_SR_MEM_ID", seq.get("seq"));
		int  saveCnt = membershipMapper.membershipFree_save(params);

		if(saveCnt> 0){
			membershipMapper.srvConfigPeriod(params);
		}

		return  saveCnt;
	}


	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#srvConfigPeriod(java.util.Map)
	 */
	@Override
	public void   srvConfigPeriod(Map<String, Object> params) {
		  membershipMapper.srvConfigPeriod(params);
	}


	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#callOutOutsProcedure(java.util.Map)
	 */
	@Override
	public EgovMap getSAL0095d_SEQ(Map<String, Object> params) {
		return membershipMapper.getSAL0095d_SEQ(params);
	}



	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#selectMembershipViewLeader(java.util.Map)
	 */
	@Override
	public List<EgovMap>    selectMembershipContatList(Map<String, Object> params) {
		return membershipMapper.selectMembershipContatList(params);
	}



	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#membershipNewContatSave(java.util.Map)
	 */
	@Override
	public  int    membershipNewContatSave(Map<String, Object> params) {
		return membershipMapper.membershipNewContatSave(params);
	}


	/*
	 * (non-Javadoc)
	 * @see com.coway.trust.biz.sales.mambership.MembershipService#membershipNewContatUpdate(java.util.Map)
	 */
	@Override
	public  int    membershipNewContatUpdate(Map<String, Object> params) {
		return membershipMapper.membershipNewContatUpdate(params);
	}

	@Override
	public List<EgovMap> getOGDCodeList(Map<String, Object> params) {

		List<EgovMap> a = membershipMapper.getOGDCodeList(params);

		System.out.println("=========");
		for(EgovMap e : a){
			System.out.println(e);
		}

		return a;
	//	return membershipMapper.getOGDCodeList(params);
	}

	@Override
	public List<EgovMap> getBrnchCodeListByBrnchId(Map<String, Object> params) {


		return membershipMapper.getBrnchCodeListByBrnchId(params);
	}

	@Override
	public int updateMembershipById (Map<String, Object> params){
		return membershipMapper.updateMembershipById (params);
	}

	@Override
	public EgovMap checkMembershipSalesPerson(Map<String,Object> params){
		params.put("module","SALES");
		params.put("subModule","MEMBERSHIP");
		params.put("paramCode","MEM_TYPE");

		List<EgovMap> memType = commonMapper.selectSystemConfigurationParamVal(params);
		if(!memType.isEmpty()){
			params.put("memType", memType);
		}

		return membershipMapper.selectSalesPerson(params);
	}

	@Override
	public EgovMap checkMembershipConfigurationSalesPerson(Map<String,Object> params){
		params.put("module","SALES");
		params.put("subModule","MEMBERSHIP");
		params.put("paramCode","MEM_TYPE");

		List<EgovMap> memType = commonMapper.selectSystemConfigurationParamVal(params);
		if(!memType.isEmpty()){
			params.put("memType", memType);
		}

		return membershipMapper.selectConfigurationSalesPerson(params);
	}

	@Override
	public EgovMap selectSvcExpire (Map<String, Object> params){
		return membershipMapper.selectSvcExpire(params);
	}
}
