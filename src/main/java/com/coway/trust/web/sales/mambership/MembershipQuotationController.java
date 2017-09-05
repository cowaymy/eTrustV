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
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.mambership.MembershipQuotationService;

import egovframework.rte.psl.dataaccess.util.EgovMap;



/**
 * 
 * @author hamhg
 *
 */
@Controller
@RequestMapping(value = "/sales/membership")
public class  MembershipQuotationController {

	private static Logger logger = LoggerFactory.getLogger(MembershipQuotationController.class);
	
	@Resource(name = "membershipQuotationService")
	private MembershipQuotationService membershipQuotationService;      
	
	@RequestMapping(value = "/membershipQuotation.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  membershipQuotation.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		return "sales/membership/membershipQuotationList";
	}
	
	@RequestMapping(value = "/mViewQuotation.do")
	public String mViewQuotation(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  mViewQuotation.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		return "sales/membership/mViewQuotationPop";
	}
	
	

	@RequestMapping(value = "/mNewQuotation.do")
	public String mNewQuotation(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  mNewQuotation.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		return "sales/membership/mNewQuotationPop";
	}
	



	@RequestMapping(value = "/newOListuotationList" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  newOListuotationList(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {


		
		logger.debug("in  newOListuotationList ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		List<EgovMap>  list = membershipQuotationService.newOListuotationList(params);
		
		return ResponseEntity.ok(list);
	}
	
	
	

	@RequestMapping(value = "/quotationList" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  quotationList(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {


		String[] VALID_STUS_ID = request.getParameterValues("VALID_STUS_ID");

		params.put("VALID_STUS_ID", VALID_STUS_ID);
		
		
		logger.debug("in  PaymentConfig ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		List<EgovMap>  list = membershipQuotationService.quotationList(params);
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/newGetExpDate")
	public ResponseEntity<Map> newGetExpDate(@RequestParam Map<String, Object> params, Model model)
			throws Exception {

		logger.debug("in  newGetExpDate ");

		EgovMap newGetExpDate = null;

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		newGetExpDate = membershipQuotationService.newGetExpDate(params);
		
		Map<String, Object> map = new HashMap();
		map.put("expDate", newGetExpDate);

		return ResponseEntity.ok(map);
	}
	
	
	@RequestMapping(value = "/getSrvMemCode" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  getSrvMemCode(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		
		
		logger.debug("in  PaymentConfig ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		List<EgovMap>  list = membershipQuotationService.getSrvMemCode(params);
		
		return ResponseEntity.ok(list);
	}
	
	
	@RequestMapping(value = "/mPackageInfo" ,method = RequestMethod.GET)
	public ResponseEntity<Map> mPackageInfo(@RequestParam Map<String, Object> params, Model model)
			throws Exception {

		logger.debug("in  packageInfo ");

		EgovMap packageInfo = null;

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		packageInfo = membershipQuotationService.mPackageInfo(params);
		
		Map<String, Object> map = new HashMap();
		map.put("packageInfo", packageInfo);

		return ResponseEntity.ok(map);
	}
	
	

	@RequestMapping(value = "/getPromotionCode" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  getPromotionCode(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		
		
		logger.debug("in  PaymentConfig ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		List<EgovMap>  list = membershipQuotationService.getPromotionCode(params);
		
		return ResponseEntity.ok(list);
	}
	
	

	@RequestMapping(value = "/getFilterCharge" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  getFilterCharge(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		
		
		logger.debug("in  getFilterCharge ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		List<EgovMap>  list = membershipQuotationService.getFilterCharge(params);
		
		return ResponseEntity.ok(list);
	}
	

	@RequestMapping(value = "/mFilterChargePop.do")
	public String mFilterChargePop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  mNewQuotation.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		return "sales/membership/mFilterChargePop";
	}
	



	
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	
}
