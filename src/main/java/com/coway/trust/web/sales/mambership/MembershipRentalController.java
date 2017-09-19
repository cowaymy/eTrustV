/**
 * 
 */
package com.coway.trust.web.sales.mambership;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.mambership.MembershipRentalService;
import com.coway.trust.biz.sales.mambership.MembershipService;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;



/**
 * 
 * @author hamhg
 *
 */
@Controller
@RequestMapping(value = "/sales/membershipRental")
public class  MembershipRentalController {

	private static Logger logger = LoggerFactory.getLogger(MembershipRentalController.class);
	
	@Resource(name = "membershipRentalService")
	private MembershipRentalService  membershipRentalService;   

	@Resource(name = "membershipService")
	private MembershipService membershipService;
	
	
	@RequestMapping(value = "/membershipRentalList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  membershipRentalList.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		
		return "sales/membership/membershipRentalList";  
	}
	

	@RequestMapping(value = "/mRContSalesViewPop.do")
	public String mRContSalesViewPop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  mRContSalesViewPop.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		model.addAttribute("srvCntrctId",params.get("srvCntrctId")); 
		return "sales/membership/mRContSalesViewPop";  
		
	}
	
	
	

	@RequestMapping(value = "/inc_mRMerInfo.do")
	public String inc_mRMerInfo(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  inc_mRMerInfo.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		
		return "sales/membership/inc_mRentalMemgershipInfoPop";  
		
	}
	
	@RequestMapping(value = "/inc_mROrderInfo.do")
	public String inc_mROrderInfo(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  inc_mROrderInfo.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		
		return "sales/membership/inc_mRentalOrderInfoPop";  
		
	}
	
	
	@RequestMapping(value = "/inc_mRPayInfo.do")
	public String inc_mRPayInfo(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  inc_mRPayInfo.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		
		return "sales/membership/inc_mRentalPaymentInfoPop";  
		
	}
	
	
	@RequestMapping(value = "/inc_mRPayListInfo.do")
	public String inc_mRPayListInfo(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  inc_mRPayListInfo.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		
		return "sales/membership/inc_mRentalPaymentListPop";  
		
	}
	

	@RequestMapping(value = "/inc_mRCallLogInfo.do")
	public String inc_mRCallLogInfo(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  inc_mRCallLogInfo.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		
		return "sales/membership/inc_mRentalCallLogListPop";  
		
	}
	
	

	@RequestMapping(value = "/mRLedgerPop.do")
	public String mRLedgerPop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  mRLedgerPop.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		model.addAttribute("srvCntrctId",params.get("srvCntrctId")); 
		model.addAttribute("srvCntrctOrdId",params.get("srvCntrctOrdId")); 
		return "sales/membership/mRLedgerViewPop";  
		
	}
	
	

	@RequestMapping(value = "/selectList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		logger.debug("in  selectList ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		
		String[]   cmbStatus =request.getParameterValues("cmbStatus");
		String[]   cmbSRVCStatus =request.getParameterValues("cmbSRVCStatus");
		
		params.put("cmbStatus", cmbStatus);
		params.put("cmbSRVCStatus", cmbSRVCStatus);
		
		
		List<EgovMap> list = membershipRentalService.selectList(params);

	
		return ResponseEntity.ok(list);
	}
	

	
	@RequestMapping(value = "/inc_mRMeminfoData", method = RequestMethod.GET)
	public ResponseEntity<Map>  inc_mRMeminfoData(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		logger.debug("in  inc_mRMeminfoData ");
		
		EgovMap cSalesInfo = null;
		
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		cSalesInfo = membershipRentalService.selectCcontactSalesInfo(params);
		
		Map<String, Object> map = new HashMap();
		map.put("cSalesInfo", cSalesInfo);
		
		return ResponseEntity.ok(map);
		
	}
	
	
	

	@RequestMapping(value = "/inc_mROrderInfoData", method = RequestMethod.GET)
	public ResponseEntity<Map>  inc_mROrderInfoData(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		logger.debug("in  inc_mROrderInfoData ");
		
		EgovMap orderInfo = null;
		EgovMap addressInfo = null;
		EgovMap configInfo = null;
		
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		
		orderInfo 	   = membershipService.selectOderInfoTab(params);
		//addressInfo    = membershipService.selectInstallAddr(params);
		configInfo    = membershipRentalService.selectConfigInfo(params);
		
		
		
		Map<String, Object> map = new HashMap();
		map.put("orderInfo", orderInfo);
		map.put("addressInfo", addressInfo);
		map.put("configInfo", configInfo);
		
		return ResponseEntity.ok(map);
		
	}
	

	@RequestMapping(value = "/inc_mRPayListInfoData", method = RequestMethod.GET)
	public ResponseEntity<Map>  inc_mRPayListInfoData(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		logger.debug("in  inc_mRPayListInfoData ");
		
		EgovMap paysetInfo = null;
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		
		paysetInfo    = membershipRentalService.selectPatsetInfo(params);
		
		
		
		Map<String, Object> map = new HashMap();
		map.put("paysetInfo", paysetInfo);
		return ResponseEntity.ok(map);
		
	}




	@RequestMapping(value = "/inc_mRPayThirdPartyInfoData", method = RequestMethod.GET)
	public ResponseEntity<Map>  inc_mRPayThirdPartyInfoData(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		logger.debug("in  inc_mRPayThirdPartyInfoData ");
		  
		EgovMap paysetInfo = null;
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		
		paysetInfo    = membershipRentalService.selectPayThirdPartyInfo(params);
		
		
		
		Map<String, Object> map = new HashMap();
		map.put("paysetThirdPartyInfo", paysetInfo);
		return ResponseEntity.ok(map);
		
	}
	
	


	@RequestMapping(value = "/callLogList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> callLogList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		logger.debug("in  callLogList ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		List<EgovMap> list = membershipRentalService.selectCallLogList(params);

	
		return ResponseEntity.ok(list);
	}
	
	
	


	@RequestMapping(value = "/paymentList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> paymentList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		logger.debug("in  paymentList ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap> list = membershipRentalService.selectPaymentList(params);

	
		return ResponseEntity.ok(list);
	}
	

	@RequestMapping(value = "/paymenDetailtList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> paymenDetailtList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		logger.debug("in  paymentDetailList ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap> list = membershipRentalService.selectPaymentDetailList(params);

	
		return ResponseEntity.ok(list);
	}
	
	
	
	
	

	@RequestMapping(value = "/inc_mRPayBillingInfo", method = RequestMethod.GET)
	public ResponseEntity<Map>  inc_mRPayBillingInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		logger.debug("in  inc_mRPayBillingInfo ");
		  
		EgovMap outInfo = null;
		EgovMap unbillMthInfo = null;
		EgovMap acontLedInfo = null;
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		
		unbillMthInfo     = membershipRentalService.selectPayUnbillInfo(params);
		acontLedInfo    = membershipRentalService.accServiceContractLedgers(params);
		
		double currentSchedule =0;
		double monthlyFee =0;
		double unbillMth =0 ;
		double billSchedule  =0;
		double unbillAmt  =0;
		double outstanding =0;
		
		if (null != unbillMthInfo) {
            currentSchedule =CommonUtils.intNvl(unbillMthInfo.get("srvPaySchdulNo"));
            monthlyFee = CommonUtils.intNvl(unbillMthInfo.get("srvPaySchdulAmt"));
        }
		
		      
		billSchedule =  CommonUtils.intNvl( acontLedInfo.get("srvLdgrCntrctSchdulNo"));
		outstanding = 	CommonUtils.intNvl( acontLedInfo.get("srvLdgrAmt"));	 
				
		if (currentSchedule > 0)  {
             unbillMth = currentSchedule - billSchedule;
          
             if (unbillMth > 0){
            	 unbillAmt  = monthlyFee * unbillMth;
             }
        }
		 
		Map<String, Object> map = new HashMap();
		map.put("unBillAmount", unbillAmt);
		map.put("outstandingAmount", outstanding);
		map.put("scheduleNo", currentSchedule);
		map.put("monthlyFee", monthlyFee);
		
		return ResponseEntity.ok(map);
		
	}
	
	
	

	@RequestMapping(value = "/getMRLedgerInfo", method = RequestMethod.GET)
	public ResponseEntity<Map>  getMRLedgerInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		logger.debug("in  getMRLedgerInfo ");
		  
		EgovMap baseInfo = null;   
		EgovMap orderMailingInfo = null;
		EgovMap addressInfo = null;
		EgovMap salesInfo = null;
		
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		baseInfo 			= membershipService.selectMembershipFree_Basic(params);
		orderMailingInfo   = membershipRentalService.selectOrderMailingInfo(params);
		//addressInfo      = membershipService.selectInstallAddr(params);
		salesInfo 			= membershipRentalService.selectCcontactSalesInfo(params);
		
		
		
		Map<String, Object> map = new HashMap();
		map.put("baseInfo", baseInfo);
		map.put("orderMailingInfo", orderMailingInfo);
		map.put("addressInfo", addressInfo);
		map.put("salesInfo", salesInfo);
		
		return ResponseEntity.ok(map);
		
	}
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	
}
