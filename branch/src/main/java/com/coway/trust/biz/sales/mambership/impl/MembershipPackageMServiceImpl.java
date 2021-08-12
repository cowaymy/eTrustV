/**
 * 
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.mambership.MembershipPackageMService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo  
 *
 */
@Service("membershipPackageMService")
public class MembershipPackageMServiceImpl extends EgovAbstractServiceImpl implements MembershipPackageMService {

	private static Logger logger = LoggerFactory.getLogger(MembershipPackageMServiceImpl.class);
	
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
	public List<EgovMap> IsExistSVMPackage(Map<String, Object> params) {
		return membershipPackageMMapper.IsExistSVMPackage(params); 
	} 
	
	
	

	@Override
	public EgovMap getSAL0081D_SEQ(Map<String, Object> params) {
		return membershipPackageMMapper.getSAL0081D_SEQ(params);
	}
	
	 
	@Override 
	public int  SAL0081D_insert(Map<String, Object> params) {  
		
		 //채번 
		 String  SEQ = String.valueOf(membershipPackageMMapper.getSAL0081D_SEQ(params).get("seq"));  
		 params.put("SRV_CNTRCT_PAC_ID", SEQ);
		 params.put("srvPacId", SEQ);
		 
		 //master 
		 int o = membershipPackageMMapper.SAL0081D_insert(params) ;
		 
		 if(o > 0){
			 
			    List<EgovMap> addItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ADD);
			    
				int r=0;
		    	if (addItemList.size() > 0) {  
					for (int i = 0; i < addItemList.size(); i++) {
						
						Map<String, Object> updateMap = (Map<String, Object>) addItemList.get(i);
						Map<String, Object> iMap = new HashMap();
					    
						iMap.put("srvContractPacID", SEQ);
				        iMap.put("srvPacItemProductID", updateMap.get("stockID"));
				        iMap.put("srvPacItemServiceFreq", updateMap.get("serviceFreq"));  
				        iMap.put("srvPacItemRental", updateMap.get("rentalFee") );
				        iMap.put("srvPacItemRemark", updateMap.get("remark"));
				        iMap.put("srvPacItemStatusID", updateMap.get("code"));
				        iMap.put("updator",params.get("updator") );
				        iMap.put("discontinue",updateMap.get("discontinue") );
				        
						r = membershipPackageMMapper.SAL0082D_insert(iMap) ;
						
					}
				}
		 }
		 saveFilterInfo(params);
    	
		return o ;
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


	@Override
	public List<EgovMap> selectFilterList(Map<String, Object> params) {
		return membershipPackageMMapper.selectFilterList(params);
	}
	
	
	@Override 
	public int  saveFilterInfo(Map<String, Object> params) {		

		logger.debug("=========================== saveFilterInfo ================================");
		
		List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ALL);
		Map<String, Object>  formData = (Map<String, Object>) params.get("formData");
		
		int o=0;
		if (updateItemList.size() > 0) {  
			for (int i = 0; i < updateItemList.size(); i++) {
				Map<String, Object> updateMap = (Map<String, Object>) updateItemList.get(i);
				
				updateMap.put("userId", params.get("userId"));
				updateMap.put("srvPacType", formData.get("srvPacType"));
				updateMap.put("srvPacId", formData.get("srvPacId"));
				if(StringUtils.isEmpty(updateMap.get("srvPacId"))){

					updateMap.put("srvPacId", params.get("srvPacId"));
				}
				
				o = membershipPackageMMapper.saveFilterInfo(updateMap) ;
			}
		}
		
		
		return o ;
	}


	@Override
	public String selectStkCode(Map<String, Object> params) {
		return membershipPackageMMapper.selectStkCode(params);
	}

}
