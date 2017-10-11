/**
 * 
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.mambership.MembershipPackageQMService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo  
 *
 */
@Service("membershipPackageQMService")
public class MembershipPackageQMServiceImpl extends EgovAbstractServiceImpl implements MembershipPackageQMService {

	@Resource(name = "membershipPackageQMMapper")
	private MembershipPackageQMMapper membershipPackageQMMapper;  
	
	@Override
	public List<EgovMap> selectList(Map<String, Object> params) {
		return membershipPackageQMMapper.selectList(params);
	} 
	  
	 
	@Override
	public List<EgovMap> selectPopDetail(Map<String, Object> params) {
		return membershipPackageQMMapper.selectPopDetail(params);
	}
	  
	 
	@Override
	public List<EgovMap> selectPopUpList(Map<String, Object> params) {
		return membershipPackageQMMapper.selectPopUpList(params);
	}
	

	
	
	
	
	@Override 
	public int  SAL0091M_update(Map<String, Object> params) {
		
		List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);
    	
		int o=0;
    	if (updateItemList.size() > 0) {  
			for (int i = 0; i < updateItemList.size(); i++) {
				Map<String, Object> updateMap = (Map<String, Object>) updateItemList.get(i);
			
				o = membershipPackageQMMapper.SAL0091M_update(updateMap) ;
			}
		}
    	
    	
		return o ;
	}
	
	public int  SAL0092M_update(Map<String, Object> params) {
		return membershipPackageQMMapper.SAL0092M_update(params);
	}
	public int  SAL0092M_insert(Map<String, Object> params) {
		return membershipPackageQMMapper.SAL0092M_insert(params);
	}
	
	
	public int  SAL0092M_delete(Map<String, Object> params) {
		return membershipPackageQMMapper. SAL0092M_delete(params);
	}

	@Override
	public List<EgovMap> selectGroupCode(Map<String, Object> params) {
		return membershipPackageQMMapper.selectGroupCode(params);
	}

	@Override
	public List<EgovMap> selectGroupCodeGroupby(Map<String, Object> params) {
		return membershipPackageQMMapper.selectGroupCodeGroupby(params);
	}
	
}
