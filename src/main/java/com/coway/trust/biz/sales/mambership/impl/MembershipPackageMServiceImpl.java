/**
 * 
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.mambership.MembershipPackageMService;
import com.sun.media.jfxmedia.logging.Logger;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo  
 *
 */
@Service("membershipPackageMService")
public class MembershipPackageMServiceImpl extends EgovAbstractServiceImpl implements MembershipPackageMService {

	@Resource(name = "membershipPackageMMapper")
	private MembershipPackageMMapper membershipPackageMMapper;  
	
	@Override
	public List<EgovMap> selectList(Map<String, Object> params) {
		return membershipPackageMMapper.selectList(params);
	}
	  
	 
	@Override
	public List<EgovMap> selectPopDetail(Map<String, Object> params) {
		return membershipPackageMMapper.selectPopDetail(params);
	}
	  
	 
	@Override
	public List<EgovMap> selectPopUpList(Map<String, Object> params) {
		return membershipPackageMMapper.selectPopUpList(params);
	}
	

	
	
	
	
	@Override 
	public int  SAL0081D_update(Map<String, Object> params) {
		
		List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);
    	
		int o=0;
    	if (updateItemList.size() > 0) {  
			for (int i = 0; i < updateItemList.size(); i++) {
				Map<String, Object> updateMap = (Map<String, Object>) updateItemList.get(i);
			
				o = membershipPackageMMapper.SAL0081D_update(updateMap) ;
			}
		}
    	
    	
		return o ;
	}
	
	public int  SAL0082D_update(Map<String, Object> params) {
		return membershipPackageMMapper.SAL0082D_update(params);
	}
	public int  SAL0082D_insert(Map<String, Object> params) {
		return membershipPackageMMapper.SAL0082D_insert(params);
	}
	
	
	public int  SAL0082D_delete(Map<String, Object> params) {
		return membershipPackageMMapper.SAL0082D_delete(params);
	}

	@Override
	public List<EgovMap> selectGroupCode(Map<String, Object> params) {
		return membershipPackageMMapper.selectGroupCode(params);
	}

	@Override
	public List<EgovMap> selectGroupCodeGroupby(Map<String, Object> params) {
		return membershipPackageMMapper.selectGroupCodeGroupby(params);
	}
	
}
