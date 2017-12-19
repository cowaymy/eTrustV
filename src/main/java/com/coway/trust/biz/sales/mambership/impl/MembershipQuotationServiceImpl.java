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
import com.coway.trust.biz.sales.mambership.MembershipQuotationService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo
 *
 */
@Service("membershipQuotationService")
public class MembershipQuotationServiceImpl extends EgovAbstractServiceImpl implements MembershipQuotationService {

	private static final Logger logger = LoggerFactory.getLogger(MembershipQuotationServiceImpl.class);
	
	@Resource(name = "membershipQuotationMapper")
	private MembershipQuotationMapper membershipQuotationMapper;
	

	@Resource(name = "membershipConvSaleMapper")
	private MembershipConvSaleMapper membershipConvSaleMapper;

	@Override
	public List<EgovMap> quotationList(Map<String, Object> params) {
		return membershipQuotationMapper.quotationList(params);
	}
	

	@Override
	public List<EgovMap> newOListuotationList(Map<String, Object> params) {
		return membershipQuotationMapper.newOListuotationList(params);
	}
	
	
	@Override
	public  EgovMap newGetExpDate(Map<String, Object> params) {
		return membershipQuotationMapper.newGetExpDate(params);
	}
	

	@Override
	public List<EgovMap> getSrvMemCode(Map<String, Object> params) {
		return membershipQuotationMapper.getSrvMemCode(params);
	}
	

	@Override
	public  EgovMap mPackageInfo(Map<String, Object> params) {
		return membershipQuotationMapper.mPackageInfo(params);
	}

	@Override
	public List<EgovMap> getPromotionCode(Map<String, Object> params) {
		return membershipQuotationMapper.getPromotionCode(params);
	}
	
	
	@Override
	public EgovMap    getFilterCharge(Map<String, Object> params) {
		return  membershipQuotationMapper.getFilterCharge(params);
		// return  (EgovMap)  params.get("p1");
	}
	
	
	
	@Override
	public List<EgovMap> getFilterPromotionCode(Map<String, Object> params) {
		return membershipQuotationMapper.getFilterPromotionCode(params);
	}
	
	@Override
	public EgovMap  getFilterPromotionAmt(Map<String, Object> params) {
		return membershipQuotationMapper.getFilterPromotionAmt(params);
	}
	 
	
	
	
	@Override
	public List<EgovMap> getPromoPricePercent(Map<String, Object> params) {
		return membershipQuotationMapper.getPromoPricePercent(params);
	}
	@Override
	public List<EgovMap> getFilterChargeList(Map<String, Object> params) {
//		return membershipQuotationMapper.getFilterChargeList(params);
		membershipQuotationMapper.getFilterCharge(params);
		return (List<EgovMap>) params.get("p1");
	}
	
	@Override
	public List<EgovMap> getFilterChargeListSum(Map<String, Object> params) {
		return membershipQuotationMapper.getFilterChargeListSum(params); 
	}
	
	   
	
	@Override
	public List<EgovMap> getOrderCurrentBillMonth(Map<String, Object> params) {
		return membershipQuotationMapper.getOrderCurrentBillMonth(params);
	}
	
	
	
	@Override
	public EgovMap    getOderOutsInfo(Map<String, Object> params) {
		
		  membershipQuotationMapper.getOderOutsInfo(params)  ;
		  
		  EgovMap   map =  (EgovMap)  ((ArrayList)params.get("p1")).get(0);
 		  logger.debug("map =============>" +map.toString());

		return    map;   
	}
	
	

	@Override
	public void    insertQuotationInfo(Map<String, Object> params) {
		 
		boolean isVerifyGSTEURCertificate   = true;
		boolean verifyGSTZeroRateLocation = true;
		
		
		

		  ////////	 get taxRate////////////////
		 int  TAXRATE = membershipConvSaleMapper.getTaxRate(params);
		  ////////	 InvoiceNum  채번 ////////////////
		 
		 if( TAXRATE ==6){
			 isVerifyGSTEURCertificate =false;
			 verifyGSTZeroRateLocation =false;
		 }
		  
		  
		if(verifyGSTZeroRateLocation){
		
    		 	params.put("srvMemPacNetAmt", params.get("srvMemPacAmt"));
    		    params.put("srvMemPacTaxes", "0");
    		    params.put("srvMemBSAmt", params.get("srvMemBSAmt"));
    		    params.put("srvMemBSNetAmt", params.get("srvMemBSAmt"));
    		    params.put("srvMemBSTaxes", "0");
			 
//		 }else if(verifyGSTZeroRateLocation){
		 }else if(isVerifyGSTEURCertificate){
			 
			 	params.put("srvMemPacNetAmt", params.get("srvMemPacAmt"));
			    params.put("srvMemPacTaxes", "0");
			    params.put("srvMemBSAmt", params.get("srvMemBSAmt"));
			    params.put("srvMemBSNetAmt", params.get("srvMemBSAmt"));
			    params.put("srvMemBSTaxes", "0");
			    
		 }else {
			 
			 double   srvMemPacAmt =  0;  
			 double   srvMemPacNetAmt  =  0;
			 double   srvMemBSNetAmt =0;
			 double	  srvMemBSAmt=0;
			 
			 
			 srvMemPacAmt 	  	= CommonUtils.intNvl((String)params.get("srvMemPacAmt"));
			 srvMemPacNetAmt 	= CommonUtils.intNvl((String)params.get("srvMemPacNetAmt"));
			 srvMemBSNetAmt  	= CommonUtils.intNvl((String)params.get("srvMemBSNetAmt"));
			 srvMemBSAmt			= CommonUtils.intNvl((String)params.get("srvMemBSAmt"));
			 
			 srvMemPacNetAmt  = Math.round((double)(srvMemPacAmt  * 100 / 106 ));
			 params.put("srvMemPacNetAmt", srvMemPacNetAmt);
			 params.put("srvMemPacTaxes", srvMemPacNetAmt - srvMemPacNetAmt);
			 
			 srvMemBSNetAmt	=Math.round((double)(srvMemBSAmt  * 100 / 106 ));
			 params.put("srvMemBSNetAmt",srvMemBSNetAmt );
			 params.put("srvMemBSTaxes",srvMemBSAmt - srvMemBSNetAmt );
		 }
		
		
		params.put("DOCNO", "20");
		EgovMap  docNoMp = membershipQuotationMapper.getEntryDocNo(params); 
		
		params.put("srvMemQuotNo",docNoMp.get("docno"));
		EgovMap   seqMap = membershipQuotationMapper.getSAL0093D_SEQ (params);
		
		logger.debug("seqMap =============>" +seqMap.toString());
		
		String  SAL0093D_SEQ = String.valueOf(seqMap.get("seq"));
		
		if("".equals(SAL0093D_SEQ)){
			throw new ApplicationException(AppConstants.FAIL, "can't  get SAL0095d_SEQ !!");
		}
		
		logger.debug("SAL0093D_SEQ =============>");
		logger.debug("SAL0093D_SEQ : {}", SAL0093D_SEQ);
		logger.debug("SAL0093D_NO : {}", docNoMp.get("docno"));
		
		params.put("SAL0093D_SEQ" , SAL0093D_SEQ);
		params.put("SAL0093D_NO" , 		docNoMp.get("docno"));
		

		
		//1. insert 
		membershipQuotationMapper.insertQuotationInfo(params);
		  
		String isFilter =(String) params.get("isFilterCharge");
		 
		 
		 if("TRUE".equals(isFilter)){
			 //2. get getMembershipFilterChargeList 프로시져 호출 
			 //3. 프로시져 result foreach 
			 
			 params.put("ORD_ID" , params.get("srvSalesOrderId"));
			 params.put("PROMO_ID" , params.get("srvPromoId"));
			 
			 membershipQuotationMapper.getFilterCharge(params) ;
			
			 logger.debug("map =============>" +params.toString());
			 
			 ArrayList  list = (ArrayList) params.get("p1");
			 EgovMap  eFilterMap = null;
			 
			 if(list.size() >0 ){
				 for(int a =0; a<list.size() ; a++){
					  
					 eFilterMap = new EgovMap();
					 Map rMap  = (Map) list.get(a);
					 
					 
					 eFilterMap.put("SrvMemQuotFilterID", SAL0093D_SEQ);
					 eFilterMap.put("StkID", rMap.get("filterId"));
					 
					 eFilterMap.put("StkPeriod", rMap.get("lifePriod") );
					 eFilterMap.put("StkLastChangeDate", rMap.get("lastChngDt")); 
					 
					 eFilterMap.put("StkFilterPrice", rMap.get("oriPrc"));
					 eFilterMap.put("StkChargePrice", rMap.get("prc"));
					 
//					 if(verifyGSTZeroRateLocation){
					 if(isVerifyGSTEURCertificate){
						 
						 eFilterMap.put("StkNetAmt", rMap.get("prc"));
						 eFilterMap.put("StkTaxes", rMap.get("0"));
						 
					 }else if(verifyGSTZeroRateLocation){
						 eFilterMap.put("StkNetAmt", rMap.get("prc"));
						 eFilterMap.put("StkTaxes", rMap.get("0"));
					 }else {
						 
						 double   chargePrice =  CommonUtils.intNvl(String.valueOf(rMap.get("prc")));
						 double   stkNetAmt  =  0;
						 
						 stkNetAmt = Math.round((float)(chargePrice  * 100 / 106 ));
						 
						 eFilterMap.put("StkNetAmt", stkNetAmt);
						 eFilterMap.put("StkTaxes", chargePrice -stkNetAmt  );
					 }
					 
					 membershipQuotationMapper.insertSrvMembershipQuot_Filter(eFilterMap);
				 }
			 }
		 }
	}
	   
	
	@Override
	public EgovMap    getMembershipFilterChargeList(Map<String, Object> params) {
		 return  membershipQuotationMapper.getMembershipFilterChargeList(params); 
	}
	
 
	@Override
	public void    insertSrvMembershipQuot_Filter(Map<String, Object> params) {
		  membershipQuotationMapper.insertSrvMembershipQuot_Filter(params);
	}
	
	

	@Override
	public EgovMap    getSAL0093D_SEQ(Map<String, Object> params) {
		return  membershipQuotationMapper.getSAL0093D_SEQ(params);
	}
	
	
	@Override
	public List<EgovMap> mActiveQuoOrder(Map<String, Object> params) {
		return membershipQuotationMapper.mActiveQuoOrder(params);
	}
	
	@Override
	public List<EgovMap> selectSrchMembershipQuotationPop(Map<String, Object> params) {
		return membershipQuotationMapper.selectSrchMembershipQuotationPop(params);
	}


	@Override
	public void updateStus(Map<String, Object> params) {
		  membershipQuotationMapper.update_SAL0093D_Stus(params);
		
	}
	
	
}



