/**
 * 
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.mambership.MembershipPackageMService;
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
	
	@Resource(name = "membershipPackageMService") 
	private MembershipPackageMService  membershipPackageMService;     
	
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
	
	
	@Override
	public EgovMap getSAL0091M_SEQ(Map<String, Object> params) {
		return membershipPackageQMMapper.getSAL0091M_SEQ(params);
	}
	
	
	@Override
	public List<EgovMap> IsExistSVMPackage(Map<String, Object> params) {
		return membershipPackageQMMapper.IsExistSVMPackage(params); 
	}
	 
	
	
	
	@Override 
	public int  SAL0091M_insert(Map<String, Object> params) {  
		
		 //채번 
		 String  SEQ = String.valueOf(membershipPackageQMMapper.getSAL0091M_SEQ(params).get("seq"));  
		 params.put("SRV_MEM_PAC_ID", SEQ);
		 params.put("srvPacId", SEQ);
		 
		 params.put("txtDuration", Integer.parseInt(params.get("txtDuration").toString()));
		 
		 //master 
		 int o = membershipPackageQMMapper.SAL0091M_insert(params) ;
		 
		 if(o > 0){
			 
			    List<EgovMap> addItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ADD);
		    	
				int r=0;
		    	if (addItemList.size() > 0) {  
					for (int i = 0; i < addItemList.size(); i++) {
						
						Map<String, Object> updateMap = (Map<String, Object>) addItemList.get(i);
						Map<String, Object> iMap = new HashMap();
						
				        iMap.put("SRV_MEM_PAC_ID", SEQ);
				        iMap.put("SRV_MEM_ITM_STK_ID", updateMap.get("stkId"));
				        iMap.put("SRV_MEM_ITM_PRC", updateMap.get("srvItemPrice"));  
				        iMap.put("SRV_MEM_ITM_PV", "0");
				        iMap.put("SRV_MEM_ITM_PRIOD", updateMap.get("srvItemPeriod"));
				        iMap.put("SRV_MEM_ITM_REM", updateMap.get("srvRemark"));
				        iMap.put("SRV_MEM_ITM_STUS_ID", updateMap.get("code")  );
				        iMap.put("updator",params.get("updator") );
				        iMap.put("discontinue",updateMap.get("discontinue") );
				        
						r = membershipPackageQMMapper.SAL0092M_insert(iMap) ;
					}
				}
		 }
    	
		 membershipPackageMService.saveFilterInfo(params);
		 
		 
		return o ;
	}
	
	
	

}
