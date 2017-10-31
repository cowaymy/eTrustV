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
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.mambership.MembershipRentalQuotationService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo
 *
 */
@Service("membershipRentalQuotationService")
public class MembershipRentalQuotationServiceImpl extends EgovAbstractServiceImpl implements MembershipRentalQuotationService {

	private static final Logger logger = LoggerFactory.getLogger(MembershipRentalQuotationServiceImpl.class);
	
	@Resource(name = "membershipRentalQuotationMapper")
	private MembershipRentalQuotationMapper membershipRentalQuotationMapper;
	
	

	@Override
	public List<EgovMap> quotationList(Map<String, Object> params) {
		return membershipRentalQuotationMapper.quotationList(params);
	}
	

	@Override
	public List<EgovMap> selCheckExpService(Map<String, Object> params) {
		return membershipRentalQuotationMapper.selCheckExpService(params);
	}
	
	
	
	
	@Override
	public List<EgovMap> newConfirm(Map<String, Object> params) {
		return membershipRentalQuotationMapper.newConfirm(params);
	}
	
	

	@Override
	public List<EgovMap> newOListuotationList(Map<String, Object> params) {
		return membershipRentalQuotationMapper.newOListuotationList(params);
	}
	
	
	@Override
	public  EgovMap newGetExpDate(Map<String, Object> params) {
		return membershipRentalQuotationMapper.newGetExpDate(params);
	}
	

	@Override
	public List<EgovMap> getSrvMemCode(Map<String, Object> params) {
		return membershipRentalQuotationMapper.getSrvMemCode(params);
	}
	

	@Override
	public  EgovMap mPackageInfo(Map<String, Object> params) {
		return membershipRentalQuotationMapper.mPackageInfo(params);
	}

	@Override
	public List<EgovMap> getPromotionCode(Map<String, Object> params) {
		return membershipRentalQuotationMapper.getPromotionCode(params);
	}
	
	
	@Override
	public EgovMap    getFilterCharge(Map<String, Object> params) {
		return  membershipRentalQuotationMapper.getFilterCharge(params);
		// return  (EgovMap)  params.get("p1");
	}
	
	
	
	@Override
	public List<EgovMap> getFilterPromotionCode(Map<String, Object> params) {
		return membershipRentalQuotationMapper.getFilterPromotionCode(params);
	}
	
	@Override
	public List<EgovMap> getPromoPricePercent(Map<String, Object> params) {
		return membershipRentalQuotationMapper.getPromoPricePercent(params);
	}
	
	
	@Override
	public List<EgovMap> getOrderCurrentBillMonth(Map<String, Object> params) {
		return membershipRentalQuotationMapper.getOrderCurrentBillMonth(params);
	}
	
	
	
	@Override
	public EgovMap    getOderOutsInfo(Map<String, Object> params) {
		membershipRentalQuotationMapper.getOderOutsInfo(params);  
		  
		   return  (EgovMap)  params.get("p1");
	}
	
	

	@Override
	public EgovMap    insertQuotationInfo(Map<String, Object> params) {
		
		
		EgovMap  trnMap = new  EgovMap();
		
		String taxCode ="";
		
		EgovMap   docMap = membershipRentalQuotationMapper.getSAL0083D_DocNo (params);
		EgovMap   seqMap = membershipRentalQuotationMapper.getSAL0083D_SEQ (params);
		
		logger.debug("seqMap =============>" +seqMap.toString());
		logger.debug("docMap =============>" +docMap.toString());
		
		
		String  SAL0093D_SEQ = String.valueOf(seqMap.get("seq"));
		String docNo = String.valueOf(docMap.get("docno"));
		   
		if("".equals(SAL0093D_SEQ)){
			throw new ApplicationException(AppConstants.FAIL, "can't  get SAL0093D_SEQ !!");
		}
		
		logger.debug("params : {}", params.toString());
		logger.debug("SAL0093D_SEQ =============>");
		logger.debug("SAL0093D_SEQ : {}", SAL0093D_SEQ);
		logger.debug("docNo : {}", docNo);

		
		params.put("qotatId" , SAL0093D_SEQ);
		params.put("qotatRefNo" , docNo);
		
		   
		
		//1. insert 
		membershipRentalQuotationMapper.insertQuotationInfo(params);
		  
		String isFilter =(String) params.get("isFilterCharge");
		 
		 
		 if("true".equals(isFilter)){
			 
			 //2. get getMembershipFilterChargeList 프로시져 호출 
			 //3. 프로시져 result foreach 
			 
			 params.put("ORD_ID" , params.get("qotatOrdId"));
			 params.put("PROMO_ID" , params.get("qotatProductId"));
			 
			 membershipRentalQuotationMapper.getFilterCharge(params) ;
			
			 logger.debug("map =============>" +params.toString());
			 
			 ArrayList  list = (ArrayList) params.get("p1");
			 EgovMap  eFilterMap = null;
			 
			 if(list.size() >0 ){
				 for(int a =0; a<list.size() ; a++){
					  
					 eFilterMap = new EgovMap();
					 Map rMap  = (Map) list.get(a);
					 
					 
					 eFilterMap.put("qotatId", SAL0093D_SEQ);
					 eFilterMap.put("qotatItmStkId", rMap.get("filterId"));
					 eFilterMap.put("qotatItmExpDt", rMap.get("lastChngDt")); 
					 eFilterMap.put("qotatItmChrg", rMap.get("prc"));
					 
					 if("39".equals(taxCode)){
    				
						 		eFilterMap.put("qotatItmAmt", "0");
						 		eFilterMap.put("qotatItmGstRate", "0");
						 		eFilterMap.put("ItmGstTaxCodeId", "39");
						 		
					}else if ("28".equals(taxCode)){
						
								eFilterMap.put("qotatItmAmt", "0");
								eFilterMap.put("qotatItmGstRate", "0");
								eFilterMap.put("ItmGstTaxCodeId", "29");
					}else{

    						 	double   chargePrice =  CommonUtils.intNvl((String)rMap.get("prc"));
    						 	double   itemAmount  =  CommonUtils.intNvl((String)rMap.get("oriPrc"));
    						 	double   amt  =Math.round((float)(chargePrice  * 100 / 106 ));
    						
    						 	eFilterMap.put("qotatItmChrg", amt);
    						 	eFilterMap.put("qotatItmTxs", (itemAmount  -amt ));
    						 	eFilterMap.put("qotatItmGstRate", "6");
    						 	eFilterMap.put("ItmGstTaxCodeId", "32");
					}
					 
					 membershipRentalQuotationMapper.insertSrvMembershipQuot_Filter(eFilterMap);
				 }
			 }
		 }
		 

		trnMap.put("qotatId", SAL0093D_SEQ);
		trnMap.put("qotatRefNo", docNo);
			
		 return trnMap ;
	}
	
	
	@Override
	public EgovMap    getMembershipFilterChargeList(Map<String, Object> params) {
		 return  membershipRentalQuotationMapper.getMembershipFilterChargeList(params); 
	}
	 
 
	@Override
	public void    insertSrvMembershipQuot_Filter(Map<String, Object> params) {
		membershipRentalQuotationMapper.insertSrvMembershipQuot_Filter(params);
	}
	
	

	@Override
	public EgovMap    getSAL0083D_SEQ(Map<String, Object> params) {
		return  membershipRentalQuotationMapper.getSAL0083D_SEQ(params);
	}
	
	
	@Override
	public List<EgovMap> mActiveQuoOrder(Map<String, Object> params) {
		return membershipRentalQuotationMapper.mActiveQuoOrder(params);
	}
	
	@Override
	public List<EgovMap> selectSrchMembershipQuotationPop(Map<String, Object> params) {
		return membershipRentalQuotationMapper.selectSrchMembershipQuotationPop(params);
	}
	
	
}



